module Api
  module Admin
    class PlansController < Api::MainController
      before_action :authorize_admin_request

      def index
        if @current_user
          render json: { message: "SmartApt Plans.", status: 200, plans: ActiveModelSerializers::SerializableResource.new(Plan.all.order(created_at: :asc), each_serializer: PlanSerializer)} and return
        else
          render json: { message: "Admin not found", status: 400}
        end
      end

    end

  end
end