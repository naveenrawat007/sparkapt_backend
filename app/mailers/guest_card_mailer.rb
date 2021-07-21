class GuestCardMailer < ApplicationMailer

  def send_guest_card(id, user_id, email)
    @guest = Guest.find_by(id: id)
    @user = User.find_by(id: user_id)

    attachments["Guest_Card_#{@guest.id}.pdf"]  = WickedPdf.new.pdf_from_string(
                 render_to_string(pdf: "Guest_Card_#{@guest.id}.pdf", template: 'guest_card/guest_card_pdf.pdf.erb', layout: 'guest_card_send.html.erb')
               )
    mail(to: email ,subject: "Guest Card… 😊")
	end


end
