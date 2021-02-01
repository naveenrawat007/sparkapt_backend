class Api::Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    @user = User.find_by(email:params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password])
        token = JsonWebToken.encode(user_id: @user.id)
        @user.update_column('auth_token', token)
        render json: {message: "User Login Successfully.", user: UserSerializer.new(@user, root: false), status: 201}, status: 200
      else
        render json: {message: "Wrong password. Could not authenticate!", error: "Wrong Password", status: 401}, status: 200
      end
    else
      render json: {message: "User does not exist with this mail.", error: 'User does not exist.', status: 404 }, status: 200
    end
  end
end
