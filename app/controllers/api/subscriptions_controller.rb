module Api
  class SubscriptionsController < MainController
    before_action :authorize_request

    def index
      if @current_user
        render json: { message: "Subscription List.", status: 200, subscriptions: ActiveModelSerializers::SerializableResource.new(@current_user.subscriptions.order(created_at: :asc), each_serializer: SubscriptionSerializer)} and return
      else
        render json: { message: "User not found", status: 400}
      end
    end

  end
end
