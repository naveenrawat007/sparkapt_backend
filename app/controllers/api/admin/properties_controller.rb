module Api
  module Admin
    class PropertiesController < Api::MainController
      before_action :authorize_admin_request, except: [:get_property_types, :show, :get_properties, :filter_property]
      before_action :authorize_request, only: [:get_property_types, :show, :get_properties, :filter_property]

      def get_property_types
        render json: { message: "Property Types.", status: 200, property_types: ActiveModelSerializers::SerializableResource.new(Type.all, each_serializer: PropertyTypeSerializer)} and return
      end

      def filter_property
        is_valid = validate_property
        if is_valid
          result = FilterPropertyService.new(params).call
          render json: {message: result.message, properties: result.properties, status: result.status}
        else
          render json: { message: "Your Trial period is over. Please Subscribe us to get properties", status: 400}
        end
      end

      def get_properties
        is_valid = validate_property
        if is_valid
          if params[:city_id].present?
            city = City.find_by(id: params[:city_id].to_i)&.name
            if city == 'All'
              properties = Property.all.price_filter(0, params[:max_price]).order(created_at: :asc)
            else
              properties = Property.where(city_id: params[:city_id].to_i).price_filter(0, params[:max_price]).order(created_at: :asc)
            end
            render json: { message: "Properties.", status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties, each_serializer: PropertySerializer)} and return
          else
            render json: { message: "City not found", status: 402}
          end
        else
          render json: { message: "Your Trial period is over. Please Subscribe us to get properties", status: 400}
        end
      end

      def show
        if params[:id].present?
          property = Property.find_by(id: params[:id])
          if property
            render json: { message: "Property detail", status: 200, property: PropertySerializer.new(property,root: false)}
          else
            render json: { message: "Property not found.", status: 400}
          end
        else
          render json: { message: "Property Id is missing", status: 400}
        end
      end

      def create
        property = Property.new(property_params)
        property.city_id = params[:city_id].to_i if params[:city_id].present?
        if property.save
          property_type = Type.all
          property_type.each do |type|

            property_type_detail = type.type_details.create(move_in: params[type&.type_code], notes: params[:property][type&.type_code][:notes], price: params[:property][type&.type_code][:price])

            property_type_detail.update(property_id: property&.id)

            property_mapped = PropertyType.create(property_id: property&.id, type_id: type&.id)
          end

          render json: { message: "Property Created Sucessfully.", status: 200}
        else
          render json: { message: "Property not Created.", status: 400}
        end
      end

      def update
        property = Property.find(params[:id].to_i)
        if property
          property.assign_attributes(property_params)
          property.city_id = params[:city_id].to_i if params[:city_id].present?
          if property.save
            if params[:property][:property_type_details]
              params[:property][:property_type_details].each do |type_detail|
                data = TypeDetail.find(type_detail['id'].to_i)
                if data
                  data.update(notes: type_detail['notes'], price: type_detail['price'], move_in: type_detail['move_in_date'])
                else
                  render json: { message: "PropertyType not Found.", status: 400} and return
                end
              end
            else
              render json: { message: "PropertyType Details params not exist.", status: 400} and return
            end
            render json: { message: "Property Update Sucessfully.", status: 200}
          else
            render json: { message: "Property not Updated.", status: 400}
          end
        else
          render json: { message: "Property not Found.", status: 400}
        end
      end

      private

      def validate_property
        if @current_user.is_admin == false
          if @current_user.is_trial == true || (@current_user.subscriptions.present? && @current_user.try(:subscriptions)&.last&.status == "active")
            return true
          else
            return false
          end
        else
          return true
        end
      end

      def property_params
        params.require(:property).permit(:name, :email, :phone, :specials, :price, :submarket, :zip, :built_year, :escort, :management_company, :web_link, :manger_name, :google_rating, :lat, :long)
      end

    end
  end
end
