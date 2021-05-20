class TwilioSmsService
  require 'twilio-ruby'

  def initialize(phone_no, client_name, agent_name)
    @phone_number = "+1" + phone_no.remove("-", "(", ")").gsub(" ", "")
    @message = "Hi #{agent_name}, this is a reminder to take follow up of your client '#{client_name}'. Thanks"
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
