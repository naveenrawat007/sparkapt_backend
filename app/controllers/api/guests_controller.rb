module Api
  class GuestsController < MainController
    before_action :authorize_request

    def index
      guests = @current_user.guests.order(created_at: :asc)
      render json: { status: 200, guests: ActiveModelSerializers::SerializableResource.new(guests, each_serializer: GuestSerializer)}
    end

    def create
      if params[:guest].present?
        guest = @current_user.guests.new(guest_params)
        # guest.communities = params[:community]
        guest.move_in = params[:move_in]
        if guest.save
          if params[:selCommunities].kind_of?(Array) && params[:selCommunities].count > 0
            communities_name = params[:selCommunities]&.map { |porp| porp&.values}&.flatten&.uniq
            if communities_name.present?
              properties = Property.where(name: communities_name)
              if properties.present?
                properties.each do |property|
                  begin
                    GuestCardMailer.send_guest_card(guest&.id, @current_user&.id, property&.email).deliver_now
                  rescue Exception => e
                    render json: {message: "Error Occurred while sending mail !!", status: 401} and return
                  end
                end
              end
            end
          end
          render json: { message: "Guest Card Send Successfully.", status: 200} and return
        else
          render json: { message: "Guest Card not saved. Please try again", status: 400} and return
        end
      else
        render json: { message: "Please send valid parameters..", status: 400} and return
      end
    end

    def communities_name
      communities_array = []
      city = City.find_by(id: params[:id])
      if city
        city.properties.each do |community|
          community_hash = { value: community&.name, label: community&.name}
          communities_array.push(community_hash)
        end
        render json: {status: 200, communities: communities_array} and return
      else
        render json: {status: 400, message: "City not found"}
      end
    end

    def resend_pdf_mail
      if params[:id].present?
        guest = Guest.find_by(id: params[:id])
        if guest.present?
          begin
            GuestCardMailer.send_guest_card(guest&.id, @current_user&.id).deliver_now
          rescue Exception => e
            render json: {message: "Error Occurred while sending mail !!", status: 400} and return
          end
          render json: { message: "Guest Card Send Successfully.", status: 200} and return
        else
          render json: { message: "Guest not found.", status: 400} and return
        end
      else
        render json: { message: "Guest not found.", status: 400}
      end
    end

    def download_guest_pdf
      if params[:id].present?
        @user = @current_user
        @guest = Guest.find_by(id: params[:id])
        if @guest.present?
          begin
            pdf_html = ActionController::Base.new.render_to_string(template: 'guest_cards/my_pdf', layout: 'guest_card_send.html.erb', locals: { guest: @guest, user: @user})
            pdf = WickedPdf.new.pdf_from_string(pdf_html)
            send_data pdf, filename: 'file.pdf'
          rescue Exception => e
            render json: {message: "Something went wrong. Please try again!!"}, status: :not_found
          end
        else
          render json: { message: "Guest not found.", status: 400}, status: :not_found
        end
      else
        render json: { message: "Guest not found.", status: 400}, status: :not_found
      end
    end

    private

    def guest_params
      params.require(:guest).permit(:first_name, :last_name, :email, :phone, :budget, :pet_number, :pet_type, :pet_name, :preferences)
    end

  end
end
