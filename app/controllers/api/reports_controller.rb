module Api
  class ReportsController < MainController

    def properties_report
      if params[:report_code].present?
        report = Report.find_by(report_code: params[:report_code].to_s)
        if report
          properties = Property.where(id: report&.property_ids)
          render json: { message: report&.message, name: report&.name, status: 200, properties: ActiveModelSerializers::SerializableResource.new(properties.uniq, each_serializer: PropertySerializer)} and return
        else
          render json: { message: "Property Report not found.", status: 400 } and return
        end
      else
        render json: { message: "Report Code is Missing.", status: 400}
      end
    end

  end
end
