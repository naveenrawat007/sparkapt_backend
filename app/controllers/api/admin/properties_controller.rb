module Api
  module Admin
    class PropertiesController < Api::MainController
      before_action :authorize_admin_request, except: [:get_property_types, :show, :get_properties, :filter_property, :get_lat_longs]
      before_action :authorize_request, only: [:get_property_types, :get_properties, :filter_property], except: [:get_lat_longs, :show]

      def get_property_types
        render json: { message: "Property Types.", status: 200, property_types: ActiveModelSerializers::SerializableResource.new(Type.all, each_serializer: PropertyTypeSerializer)} and return
      end

      def get_lat_longs
        result = []
        if params[:property_ids].present? && params[:property_ids].kind_of?(Array)
          params[:property_ids].each do |id|
            property = Property.find_by(id: id.to_i)
            if property
              lat_long_hash = { id: property&.id, lat: property.lat, long: property.long}
              result.push(lat_long_hash)
            end
          end
          render json: { status: 200, lat_longs: result}
        end
      end

      def filter_property
        is_valid = validate_property
        if is_valid
          if params[:city_id].present?
            properties = get_city_properties(params[:city_id])
            result = FilterPropertyService.new(params, properties).call
            render json: {message: result.message, properties: result.properties, status: result.status}
          else
            render json: { message: "City not found", status: 400} and return
          end
        else
          render json: { message: "Please Subscribe us to get Apartment Details", status: 400}
        end
      end

      def import_properties
        if params[:properties].present? && params[:properties].kind_of?(Array) && params[:properties].count > 2
          # begin
            result = ImportPropertyService.new(params).call
            render json: {message: result.message, status: result.status} and return
          # rescue Exception => e
          #   render json: {message: "Invalid Data or some missing fields.Please check and try again", status: 400} and return
          # end
        else
          render json: { message: "Invalid Data.", status: 400}
        end
      end

      def get_properties
        is_valid = validate_property
        if is_valid
          if params[:city_id].present?
            properties = get_city_properties(params[:city_id])
            properties = properties.price_filter(0, params[:max_price]).order(created_at: :asc)
            render json: { message: "Properties.", status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties.uniq, each_serializer: PropertySerializer)} and return
          else
            render json: { message: "City not found", status: 402}
          end
        else
          if params[:city_id].present?
            render json: { message: "Please Subscribe us to get Apartment Details", status: 400}
          end
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
        property_data = JSON.parse(params[:property])
        property = Property.new(name: property_data["name"], email: property_data["email"], phone: property_data["phone"], specials: property_data["specials"], price: property_data["price"], submarket: property_data["submarket"], zip: property_data["zip"], built_year: property_data["built_year"], escort: property_data["escort"], management_company: property_data["management_company"], web_link: property_data["web_link"], manager_name: property_data["manager_name"], google_rating: property_data["google_rating"], lat: property_data["lat"], long: property_data["long"], address: property_data["address"], google_map: property_data["google_map"], photo_gallery_link: property_data["photo_gallery_link"])

        if params[:image].present?
          property.image = params[:image]
        end

        property.city_id = params[:city_id].to_i if params[:city_id].present?
        if property.save
          property_type = Type.all
          property_type.each do |type|

            property_type_detail = type.type_details.create(available: property_data[type&.type_code.to_s]["available"], notes: property_data[type&.type_code.to_s]["notes"], price: property_data[type&.type_code.to_s]["price"])

            property_type_detail.update(property_id: property&.id)

            property_mapped = PropertyType.create(property_id: property&.id, type_id: type&.id)
          end

          render json: { message: "Property Created Sucessfully.", status: 200}
        else
          render json: { message: "Property not Created.", status: 400}
        end
      end

      def update
        property_data = JSON.parse(params[:property])
        property = Property.find(params[:id].to_i)
        if property
          property.assign_attributes(name: property_data["name"], email: property_data["email"], phone: property_data["phone"], specials: property_data["specials"], price: property_data["price"], submarket: property_data["submarket"], zip: property_data["zip"], built_year: property_data["built_year"], escort: property_data["escort"], management_company: property_data["management_company"], web_link: property_data["web_link"], manager_name: property_data["manager_name"], google_rating: property_data["google_rating"], lat: property_data["lat"], long: property_data["long"], address: property_data["address"], google_map: property_data["google_map"], photo_gallery_link: property_data["photo_gallery_link"])

          if params[:image].present?
            property.image = params[:image]
          end

          property.city_id = params[:city_id].to_i if params[:city_id].present?
          if property.save
            property.type_details.destroy_all
            if property_data["property_type_details"]
              property_data["property_type_details"].each do |type_detail|
                type = Type.find_by(name: type_detail['property_type'])
                if type
                  if type_detail['price'] != ""
                    property_type_detail = type.type_details.create(notes: type_detail['notes'], price: type_detail['price'], available: type_detail['available'], floor_plan: type_detail['floor_plan'], size: type_detail['size'], floor_plan: type_detail['floor_plan'], property_type_name: type_detail['property_type'])
                    property_type_detail.update(property_id: property&.id)
                  end
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

      def destroy
        property = Property.find_by(id: params[:id].to_i)
        if property
          if property.destroy
            render json: { message: "Property Deleted.", status: 200} and return
          else
            render json: {message: "Property not found.", status: 400} and return
          end
        else
          render json: {message: "Property not found.", status: 400}
        end
      end

      private

      def get_city_properties(id)
        city = City.find_by(id: id)&.name
        if city == 'All'
          properties = Property.all
        else
          properties = Property.where(city_id: id)
        end
      end

      def validate_property
        if @current_user.is_admin == false
          if @current_user.is_trial == true
            return true
          elsif @current_user.subscriptions.present? && @current_user.try(:subscriptions)&.last&.status == "Active"
            return true
          else
            return false
          end
        else
          return true
        end
      end

      def property_params
        params.require(:property).permit(:name, :email, :phone, :specials, :price, :submarket, :zip, :built_year, :escort, :management_company, :web_link, :manger_name, :google_rating, :lat, :long, :address, :google_map, :photo_gallery_link)
      end

    end
  end
end
