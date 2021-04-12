require 'rufus/scheduler'
require 'rake'


Rake::Task.clear
Rails.application.load_tasks
scheduler = Rufus::Scheduler.new

scheduler.cron '0 0 * * *' do
  Rake::Task['validate_subscription:check_subscription_status'].execute
end
