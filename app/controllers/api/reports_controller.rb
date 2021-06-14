module Api
  class ReportsController < MainController
    before_action :authorize_request, only: [:index]

    def index
      reports = []
      @current_user.clients.includes(:reports).references(:reports).each do |client|
        client.reports.order(created_at: :desc).each do |report|
          report_hash = { title: report.title, created_at: report.created_at.strftime("%a, %d %b %Y"), client_name: client.name, code: report.report_code}
          reports.push(report_hash)
        end
      end
      render json: {reports: reports, status: 200}
    end

    def properties_report
      if params[:report_code].present?
        report = Report.find_by(report_code: params[:report_code].to_s)
        if report
          properties = Property.where(id: report&.property_ids)
          render json: { message: report&.message, is_show: report&.is_show, name: report&.name, agent_email: report.agent_email ,status: 200, ids: report&.property_ids, properties: ActiveModelSerializers::SerializableResource.new(properties.uniq, each_serializer: PropertySerializer)} and return
        else
          render json: { message: "Property Report not found.", status: 400 } and return
        end
      else
        render json: { message: "Report Code is Missing.", status: 400}
      end
    end

    def tour_request
      begin
        UserWelcomeMailer.tour_req(params).deliver_now
      rescue Exception => e
        render json: {message: "Error Occurred while sending mail !!", status: 401} and return
      end
      render json: {message: "Property Tour Request send to agent Sucessfully !!", status: 200}
    end

  end
end
