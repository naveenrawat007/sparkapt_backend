module Api
  module Admin
    class NotificationsController < Api::MainController
      before_action :authorize_admin_request, except: [:index, :get_latest_notification]

      def index
        render json: { message: "Notifications.", status: 200, notifications: ActiveModelSerializers::SerializableResource.new(Notification.last(50).reverse, each_serializer: NotificationSerializer)} and return
      end

      def get_latest_notification
        render json: { message: "Notifications.", status: 200, notifications: ActiveModelSerializers::SerializableResource.new(Notification.last(7).reverse, each_serializer: NotificationSerializer)} and return
      end

      def create
        if @current_user
          notification = Notification.create(notification_params)
          if notification.save
            render json: { message: "Notification Create Sucessfully.", status: 200, notifications: ActiveModelSerializers::SerializableResource.new(Notification.last(50).reverse, each_serializer: NotificationSerializer)} and return
          else
            render json: { message: "Notification not created", status: 400} and return
          end
        else
          render json: { message: "Admin not found", status: 400}
        end
      end

      private

      def notification_params
        params.require(:notification).permit(:title, :description)
      end

    end
  end
end
