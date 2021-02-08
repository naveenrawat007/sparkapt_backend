module Api
  module Admin
    class SubscriptionsController < Api::MainController
      before_action :authorize_admin_request

      def index
        if @current_user
          render json: { message: "Subscription List.", status: 200, subscriptions: ActiveModelSerializers::SerializableResource.new(Subscription.all.order(created_at: :asc), each_serializer: SubscriptionSerializer)} and return
        else
          render json: { message: "Admin not found", status: 400}
        end
      end

    end

  end
end
