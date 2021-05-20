namespace :send_follow_up do
  desc "send reminder message to agents on follow up date"
  task send_reminder_text: :environment do
    clients = Client.all
    clients.each do |client|
      if client.next_follow_up.present? && client.try(:user).phone_no.present?
        if Date.today == client.next_follow_up.to_date
          TwilioSmsService.new(client.try(:user).phone_no, client&.first_name, client.try(:user).first_name).send_message
        end
      end
    end
  end

end
