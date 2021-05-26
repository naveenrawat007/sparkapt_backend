module Api
  module Admin
    class AssistantsController < Api::MainController
      before_action :authorize_admin_request


      def create_virtual_assistant
        va_user = User.new(configure_sign_up_params)
        if va_user.save
          name = va_user.first_name + " " + va_user.last_name
          va_user.update_attributes(name: name, is_va: true)
          render json: { message: "Virtual Assistant created sucessfully.", status: 200 } and return
        end
      end

      def assistants_list
        render json: { message: "User List.", status: 200, assistants: ActiveModelSerializers::SerializableResource.new(User.where(is_va: true).order(created_at: :asc), each_serializer: UserSerializer)} and return
      end

      def destroy_assistant
        assistant = User.find_by_id(params[:id].to_i)
        if assistant.destroy
          render json: { message: "Virtual Assistant deleted sucessfully.", status: 200 , assistants: ActiveModelSerializers::SerializableResource.new(User.where(is_va: true).order(created_at: :asc), each_serializer: UserSerializer)}
        else
          render json: { message: "Assistant not found.", status: 401 }
        end
      end

      def show
        assistant = User.find_by_id(params[:id].to_i)
        if assistant
          render json: {status: 200 , assistant: UserSerializer.new(assistant, root: false)}
        else
          render json: { message: "Assistant not found.", status: 401 }
        end
      end

      def update_assistant
        assistant = User.find_by_id(params[:id].to_i)
        if assistant.update(configure_sign_up_params)
          name = assistant.first_name + " " + assistant.last_name
          assistant.update_attributes(name: name)
          render json: { message: "Virtual Assistant update Sucessfully.", status: 200 } and return
        else
          render json: { message: "Assistant not Update.", status: 401 }
        end
      end

      private
      def configure_sign_up_params
        params.require(:user).permit(:first_name, :last_name, :name, :email, :password, :phone_no)
      end

    end
  end
end
