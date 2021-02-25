module Api
  module Admin
    class PropertiesController < Api::MainController
      before_action :authorize_admin_request, except: [:get_property_types]

      def get_property_types
        render json: { message: "Property Types.", status: 200, property_types: ActiveModelSerializers::SerializableResource.new(Type.all, each_serializer: PropertyTypeSerializer)} and return
      end

      def index
        render json: { message: "Properties.", status: 200, properties: ActiveModelSerializers::SerializableResource.new(Property.all, each_serializer: PropertySerializer)} and return
      end

      def create
        property = Property.new(property_params)
        property.city_id = params[:city_id].to_i if params[:city_id].present?
        if property.save
          property_type = Type.find((params[:property][:property_type]).to_i)
          property_type_detail = property_type.type_details.create(move_in: params[:property][:move_in], notes: params[:property][:notes], price: params[:property][:type_price])
          property_type_detail.update(property_id: property&.id)
          property_mapped = PropertyType.create(property_id: property&.id, type_id: property_type&.id)
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
