module Api
  class UsersController < MainController

    before_action :authorize_request, except: [:forgot_password, :contact_us]

    def show
      render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}), status:200}, status:200
    end

    def contact_us
      if params[:email].present?

      end
    end

    def forgot_password
      @user = User.find_by(email: params[:user][:email])
      if @user
        token = JsonWebToken.encode(user_id: @user.id)
        @user.update_column('auth_token', token)
        domain = Rails.application.secrets.website_domain
        UserWelcomeMailer.forget_password(@user.id, domain).deliver_now
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
            user.update(user_update_params)
            render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(user,root: false)}
          else
            render json: {message: "Email already exist.", status: 406} and return
          end
        else
          if @current_user.present?
            @current_user.update(user_update_params)
            render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(user,root: false)}
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
      params.require(:user).permit(:first_name, :last_name, :name, :email, :phone_no, :password)
    end

  end
end
