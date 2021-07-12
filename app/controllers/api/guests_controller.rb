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
        guest.communities = params[:community]
        guest.move_in = params[:move_in]
        if guest.save
          begin
            GuestCardMailer.send_guest_card(guest&.id, @current_user&.id).deliver_now
          rescue Exception => e
            render json: {message: "Error Occurred while sending mail !!", status: 401} and return
          end
          render json: { message: "Guest Card Send Successfully.", status: 200} and return
        else
          render json: { message: "Guest Card not saved. Please try again", status: 400} and return
        end
      else
        render json: { message: "Please send valid parameters..", status: 400}
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
          file = WickedPdf.new.pdf_from_string(render_to_string(pdf: "Guest_Card_#{@guest.id}.pdf", template: 'guest_card/guest_card_pdf.pdf.erb', layout: 'guest_card_send.html.erb'))
          # render json: { pdf: file, status: 200, message: "Guest Pdf"} and return
        else
          render json: { message: "Guest not found.", status: 400} and return
        end
      else
        render json: { message: "Guest not found.", status: 400}
      end
    end

    private

    def guest_params
      params.require(:guest).permit(:first_name, :last_name, :email, :phone, :budget, :pet_number, :pet_type, :pet_name, :preferences)
    end

  end
end
