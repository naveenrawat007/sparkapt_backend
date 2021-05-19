class TwilioSmsService
  require 'twilio-ruby'

  def initialize()
    @phone_number = "+919634420545"
    @message = "hello naveen"
  end

  def send_message
    if Rails.env.production?
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
