module Api
  class UsersController < MainController

    before_action :authorize_request, except: [:forgot_password, :contact_us]

    def show
      render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}), status:200}, status:200
    end

    def contact_us
      if params[:query][:email].present?
        inquiry = Contactinquiry.create(contact_us_params)
        begin
          UserWelcomeMailer.contact_inquiry(inquiry.id).deliver_now
        rescue Exception => e
          render json: {message: "Error Occurred while sending mail !!", status: 401} and return
        end
        render json: { message: "We got your query and we are working on it. Thanks", status: 200}, status: 200
      else
        render json: { message: "Please fill all details!", status: 400}, status: 200
      end
    end

    def forgot_password
      @user = User.find_by(email: params[:user][:email])
      if @user
        token = JsonWebToken.encode(user_id: @user.id)
        @user.update_column('auth_token', token)
        domain = Rails.application.secrets.website_domain
        begin
          UserWelcomeMailer.forget_password(@user.id, domain).deliver_now
        rescue Exception => e
          render json: {message: "Error Occurred while sending mail !!", status: 401} and return
        end
        # Sidekiq::Client.enqueue_to_in("default", Time.now, ForgetPasswordWorker, @user.id, domain)
        render json: { message: "A Link to reset password is sent to your email.", status: 200}, status: 200
      else
        render json: { message: "No Account Infomation found with this account.", error: "Account not found", status: 404}, status: 200
      end
    end

    def reset_password
      if @current_user.present?
        @current_user.update(password: params[:user][:new_password])
        render json: { message: "Password Update Sucessfully", status: 200,  user: UserSerializer.new(@current_user,root: false)}
      else
        render json: { message: "User not found", status: 400}
      end
    end

    def update_profile
      if params[:user][:email].blank? == false
        user = User.find_by(email: params[:user][:email])
        if user.present?
          if user.id == @current_user.id
            if user.update(user_update_params)
              user.update(password: params[:user][:new_password]) if params[:user][:new_password] != ''
              name = user.first_name + " " + user.last_name
              user.update_column('name', name)
              render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(user,root: false)}
            else
              render json: { message: "User not Update Sucessfully", status: 400} and return
            end
          else
            render json: {message: "Email already exist.", status: 406} and return
          end
        else
          if @current_user.present?
            if @current_user.update(user_update_params)
              @current_user.update(password: params[:user][:new_password]) if params[:user][:new_password] != ''
              render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(user,root: false)}
            else
              render json: { message: "User not Update Sucessfully", status: 400} and return
            end
          else
            render json: {message: "User Not Found.", status: 406} and return
          end
        end
      else
        render json: {message: "Email can't be blank.", status: 406} and return
      end
    end

    private
    def user_update_params
      params.require(:user).permit(:first_name, :last_name, :name, :email, :phone_no)
    end

    def contact_us_params
      params.require(:query).permit(:email, :phone, :inquiry_reason, :message)
    end

  end
end
