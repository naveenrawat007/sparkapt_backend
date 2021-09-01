class TwilioSmsService
  require 'twilio-ruby'

  def initialize(phone_no, message)
    @phone_number = "+1" + phone_no.remove("-", "(", ")").gsub(" ", "") if phone_no.present?
    @message = message
  end

  def send_message
    if Rails.env.production? && @phone_number.present?
      begin
        client = Twilio::REST::Client.new
        message = client.messages.create(
          to: @phone_number,
          from: Rails.application.secrets.twilio_phone_number,
          body: @message
        )
      rescue Twilio::REST::TwilioError => e
        puts "======twilio error======#{e.message}======"
      end
    end
  end

end
