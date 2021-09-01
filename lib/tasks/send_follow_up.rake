namespace :send_follow_up do
  desc "send reminder message to agents on follow up date"
  task send_reminder_text: :environment do
    clients = Client.all
    clients.each do |client|
      if client.next_follow_up.present? && client.try(:user).phone_no.present?
        if Date.today == client.next_follow_up.to_date
          message = "Hi #{client.try(:user).first_name}, this is a reminder to take follow up of your client '#{client&.first_name}'. Thanks"
          TwilioSmsService.new(client.try(:user).phone_no, message).send_message
        end
      end
    end
  end

end
