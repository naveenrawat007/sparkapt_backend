module Api
  class UsersController < MainController

    before_action :authorize_request, except: [:forgot_password, :contact_us, :get_cities]

    def show
      render json: {user: UserSerializer.new(@current_user, root: false, serializer_options: {token: @current_user.auth_token}), status:200}, status:200
    end

    def get_cities
      default_city = City.find_by(name: 'Austin')
      render json: { message: "Cities List.", status: 200, default: {label: default_city&.name, value: default_city&.id} ,cities: ActiveModelSerializers::SerializableResource.new(City.all.order(name: :asc), each_serializer: CitySerializer )} and return
    end

    def send_property_report
      domain = Rails.application.secrets.website_domain
      if params[:report].present?

        if params[:saveAsClient] == true
          old_client = Client.find_by(email: params[:report][:email])
          if old_client.present?
            old_client.update(name: params[:first_name] + params[:last_name], first_name: params[:first_name], last_name: params[:last_name], city_id: params[:city_id], status: "Active")
          else
            client = @current_user.clients.create(name: params[:first_name] + params[:last_name], first_name: params[:first_name], last_name: params[:last_name], email: params[:report][:email], city_id: params[:city_id], status: "Active", move_in_date: Date.today)
          end

        end

        report = Report.create(message: params[:report][:message], name: params[:first_name])
        unique_code = create_unique_code()
        report.update(report_code: unique_code, property_ids: params[:property_ids])
        UserWelcomeMailer.property_report(report&.report_code, params[:report][:email],domain).deliver_now
        render json: {message: "Property Report Detail send to your email Sucessfully !!", status: 200}
      else
        render json: {message: "Please fill all details.", status: 401}
      end
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

    def update_password
      if @current_user.present?
        if @current_user.valid_password?(params[:user][:old_password])
          @current_user.update(password: params[:user][:new_password])
          render json: { message: "Password Update Sucessfully", status: 200}
        else
          render json: { message: "Invalid Password", status: 400} and return
        end
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
              name = @current_user.first_name + " " + @current_user.last_name
              @current_user.update_column('name', name)
              render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(@current_user,root: false)}
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

    def report_params
      params.require(:report).permit(:name, :message)
    end

    def create_unique_code()
      code = SecureRandom.urlsafe_base64(nil, false)
      if Report.find_by(report_code: code).present?
        create_unique_code()
      else
        return code
      end
    end

  end
end
