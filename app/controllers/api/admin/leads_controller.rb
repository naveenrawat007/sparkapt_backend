module Api
  module Admin
    class LeadsController < Api::MainController
      before_action :authorize_admin_request, except: [:create]

      def create
        lead = Lead.create(lead_params)
        lead.update(important_to_you: params[:lead][:imp_details], source: "LAH")
      end

      def index
        render json: { message: "Lead List.", status: 200, leads: ActiveModelSerializers::SerializableResource.new(Lead.all.order(created_at: :asc), each_serializer: LeadSerializer)}
      end

      def show
        assistant = User.find_by_id(params[:id].to_i)
        if assistant
          render json: {status: 200 , assistant: UserSerializer.new(assistant, root: false)}
        else
          render json: { message: "Assistant not found.", status: 401 }
        end
      end

      private

      def lead_params
        params.require(:lead).permit(:city, :name, :email, :phone, :reach_out, :move_in, :bedrooms, :bathrooms, :budget, :comment)
      end

    end
  end
end
