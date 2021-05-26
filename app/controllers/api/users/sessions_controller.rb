class Api::Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    @user = User.find_by(email:params[:user][:email].downcase)
    if @user
      if @user.valid_password?(params[:user][:password])
        if @user.approved || @user.is_admin || @user.is_va
          token = JsonWebToken.encode(user_id: @user.id)
          @user.update_column('auth_token', token)
          render json: {message: "User Login Successfully.", user: UserSerializer.new(@user, root: false), status: 201} and return
        else
          render json: {message: "Please Wait for Admin Approval.", status: 400} and return
        end
      else
        render json: {message: "Wrong password. Could not authenticate!", error: "Wrong Password", status: 401} and return
      end
    else
      render json: {message: "User does not exist with this mail.", error: 'User does not exist.', status: 404 } and return
    end
  end
end
