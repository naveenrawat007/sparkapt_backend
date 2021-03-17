class Api::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @old_user = User.find_by(email: params[:user][:email])
    if !@old_user
      @user = User.new(configure_sign_up_params)
      if @user.save
        token = JsonWebToken.encode(user_id: @user.id)
        @user.update_attributes(auth_token: token, is_trial: true, trial_start: Time.now.utc, trial_end: Time.now.utc + 3.days, city_id: params[:city_id].to_i, approved: false)
        begin
          UserWelcomeMailer.welcome(@user.id).deliver_now
          UserWelcomeMailer.account_approve(@user.id).deliver_now
        rescue Exception => e
          render json: {message: "Error Occurred while sending mail !!", status: 401}
        end
        render json: {message: "User Created Successfully.", user: UserSerializer.new(@user, root: false), status: 201} and return
      else
        render json: { message: "Can not add user.", error: "User save error", status: 400} and return
      end
    else
      render json: { message: "User already exist with this email.", error: "User exists", status: 409} and return
    end
  end

  private
  def configure_sign_up_params
    params.require(:user).permit(:first_name, :last_name, :name, :email, :password, :phone_no, :license_no)
  end
end
