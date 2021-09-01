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

    def multiple_report
      domain = Rails.application.secrets.website_domain
      if params[:report].present?
        unique_code = create_unique_code()
        report = Report.create(message: params[:report][:message], name: params[:name])

        report.update(report_code: unique_code, property_ids: params[:property_ids], agent_email: @current_user&.email)

        if params[:clients].present? && params[:clients].kind_of?(Array)
          params[:clients].each do |id|
            client = Client.find_by(id: id.to_i)

            UserWelcomeMailer.property_report(report&.report_code, client&.email, domain, @current_user&.email).deliver_now

          end
        end
        render json: {message: "Property Report Detail send Sucessfully !!", status: 200}
      end
    end

    def send_property_report
      domain = Rails.application.secrets.website_domain
      unique_code = create_unique_code()
      if params[:report].present?

        if params[:clientType] == "new"
          client = Client.find_by(phone: params[:email])
          report = Report.create(message: @current_user&.signature, title: params[:report][:title] ,name: params[:first_name], agent_email: @current_user&.email, report_code: unique_code, property_ids: params[:property_ids], is_show: true)
          if params[:saveAsClient] == true
            if client.present?
              client.update(name: params[:first_name] + params[:last_name], first_name: params[:first_name], last_name: params[:last_name], city_id: params[:city_id], status: "Active")
            else
              client = @current_user.clients.create(name: params[:first_name] + params[:last_name], first_name: params[:first_name], last_name: params[:last_name], phone: params[:email], city_id: params[:city_id], status: "Active", move_in_date: Date.today)
            end
            ClientReport.create(client_id: client.id, report_id: report.id)
          end

          report_link = "#{domain}/properties-report?report_code=#{report&.report_code}"
          message = "Hello, Find a link to get your Property Details, #{report_link}, Thanks, SparkAPT Team"
          begin
            # UserWelcomeMailer.property_report(report&.report_code, params[:email],domain, @current_user&.email).deliver_now
            TwilioSmsService.new(params[:email], message).send_message
          rescue Exception => e
            render json: {message: "Error Occurred while sending text message !!", status: 401} and return
          end

        else
          report = Report.create(message: @current_user&.signature, title: params[:report][:title], name: "", agent_email: @current_user&.email, report_code: unique_code, property_ids: params[:property_ids], is_show: true)

          report_link = "#{domain}/properties-report?report_code=#{report&.report_code}"
          message = "Hello, Find a link to get your Property Details, #{report_link}, Thanks, SparkAPT Team"

          if params[:multipleClient].present? && params[:multipleClient].kind_of?(Array)
            params[:multipleClient].each do |client_hash|
              client = @current_user.clients.find_by(id: client_hash["value"].to_i)
              ClientReport.create(client_id: client.id, report_id: report.id)
              begin
                # UserWelcomeMailer.property_report(report&.report_code, client&.email, domain, @current_user&.email).deliver_now
                TwilioSmsService.new(client&.phone, message).send_message
              rescue Exception => e
                render json: {message: "Error Occurred while sending text message !!", status: 401} and return
              end
            end

          end
        end
        render json: {message: "Property Report Detail send to your phone Sucessfully !!", status: 200}
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
      data = JSON.parse(params[:user])
      if data["email"].blank? == false
        user = User.find_by(email: data["email"])
        if user.present?
          if user.id == @current_user.id
            if user.update(first_name: data["first_name"], last_name: data["last_name"], email: data["email"], signature: data["signature"], phone_no: data["phone_no"])
              name = user.first_name + " " + user.last_name
              user.update_column('name', name)
              if params[:logo].present?
                user.logo = params[:logo]
                user.save
              end
              render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(user,root: false)}
            else
              render json: { message: "User not Update Sucessfully", status: 400} and return
            end
          else
            render json: {message: "Email already exist.", status: 406} and return
          end
        else
          if @current_user.present?
            if @current_user.update(first_name: data["first_name"], last_name: data["last_name"], email: data["email"], signature: data["signature"], phone_no: data["phone_no"])
              name = @current_user.first_name + " " + @current_user.last_name
              @current_user.update_column('name', name)
              if params[:logo].present?
                user.logo = params[:logo]
                user.save
              end
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
