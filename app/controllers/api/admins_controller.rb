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

    def admin_name
      render json: { status: 200, admin_name: @current_user&.name}
    end

    def approve_user
      message = ""
      if params[:user_id]
        user = User.find_by(id: params[:user_id].to_i)
        if user
          if params[:status] == "approved"
            user.update_attributes(approved: true, status: "Approved", is_trial: true, trial_start: DateTime.now.utc, trial_end: DateTime.now.utc + 30.days)
            UserWelcomeMailer.welcome(user.id).deliver_now
            message = "User Account Successfully Approved."
          else
            user.update_attributes(approved: false, status: "Declined")
            message = "User Account request is Declined."
          end
          render json: { message: message, status: 200, users: ActiveModelSerializers::SerializableResource.new(User.all.where(is_admin: false).order(created_at: :asc), each_serializer: UserSerializer)} and return
        end
      else
        render json: { message: "User not Found", status: 400}
      end
    end

    def login_as_user
      user = User.find(params[:user_id].to_i)
      token = JsonWebToken.encode(user_id: params[:user_id].to_i)
      render json: { message: "Login Successfully", status: 200, user_token: token, user_name: user&.name}
    end

    def users_list
      if @current_user
        render json: { message: "User List.", status: 200, users: ActiveModelSerializers::SerializableResource.new(User.all.where(is_admin: false).order(created_at: :asc), each_serializer: UserSerializer)} and return
      else
        render json: { message: "Admin not found", status: 400}
      end
    end

    def search_user
      if @current_user
        users = User.all.where.not(is_admin: true).where("lower(first_name) LIKE :search OR lower(last_name) LIKE :search OR lower(email) LIKE :search OR lower(phone_no) LIKE :search OR lower(name) LIKE :search", search: "%#{params[:search_str].downcase}%").order(created_at: :asc)
        render json: { message: "Users List.", status: 200, users: ActiveModelSerializers::SerializableResource.new(users, each_serializer: UserSerializer)} and return
      else
        render json: { message: "User not found", status: 400}
      end
    end

    def plans_list
      render json: { message: "SparkAPT Plans.", status: 200, plans: ActiveModelSerializers::SerializableResource.new(Plan.all.order(created_at: :asc), each_serializer: PlanSerializer)} and return
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
