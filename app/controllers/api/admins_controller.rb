module Api
  class AdminsController < MainController
    before_action :authorize_admin_request, except: :plans_list

    def subscription_list
      if @current_user
        render json: { message: "Subscription List.", status: 200, subscriptions: ActiveModelSerializers::SerializableResource.new(Subscription.all.where(status: params[:status]).order(created_at: :asc), each_serializer: SubscriptionSerializer)} and return
      else
        render json: { message: "Admin not found", status: 400}
      end
    end

    def users_list
      if @current_user
        render json: { message: "User List.", status: 200, users: ActiveModelSerializers::SerializableResource.new(User.all.where(is_admin: false).order(created_at: :asc), each_serializer: UserSerializer)} and return
      else
        render json: { message: "Admin not found", status: 400}
      end
    end

    def plans_list
      render json: { message: "SmartApt Plans.", status: 200, plans: ActiveModelSerializers::SerializableResource.new(Plan.all.order(created_at: :asc), each_serializer: PlanSerializer)} and return
    end

    def contact_inquiry_list
      if @current_user
        render json: { message: "Contact Inquiry List.", status: 200, inquiry_list: ActiveModelSerializers::SerializableResource.new(Contactinquiry.all.order(created_at: :asc), each_serializer: ContactinquirySerializer)} and return
      else
        render json: { message: "Admin not found", status: 400}
      end
    end

  end
end
