class Api::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @old_user = User.find_by(email: params[:user][:email])
    if !@old_user
      @user = User.new(configure_sign_up_params)
      if @user.save
        token = JsonWebToken.encode(user_id: @user.id)
        @user.update_column('auth_token', token)
        render json: {user: UserSerializer.new(@user, root: false, serializer_options: {token: token}), status: 201}, status: 200
      else
        render json: { message: "Can not add user.", error: "User save error", status: 400}, status: 200
      end
    else
      render json: { message: "User already exist with this email.", error: "User exists", status: 409}, status: 200
    end
  end

  private
  def configure_sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone_no)
  end
end
