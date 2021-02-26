module Api
  module Admin
    class PropertiesController < Api::MainController
      before_action :authorize_admin_request, except: [:get_property_types, :index]
      before_action :authorize_request, only: [:get_property_types, :index]

      def get_property_types
        render json: { message: "Property Types.", status: 200, property_types: ActiveModelSerializers::SerializableResource.new(Type.all, each_serializer: PropertyTypeSerializer)} and return
      end

      def index
        if params[:city_id].present?
          city = City.find(params[:city_id].to_i)&.name
          if city == 'All'
            properties = Property.all.order(created_at: :asc)
          else
            properties = Property.where(city_id: params[:city_id].to_i).order(created_at: :asc)
          end
          render json: { message: "Properties.", status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties, each_serializer: PropertySerializer)} and return
        else
          render json: { message: "City not found", status: 400}
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

      private

      def property_params
        params.require(:property).permit(:name, :email, :phone, :specials, :price, :submarket, :zip, :built_year, :escort, :management_company, :web_link, :manger_name, :google_rating)
      end

    end
  end
end
