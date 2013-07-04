require "resque/tasks"
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'

  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
  Resque.after_fork = Proc.new  { Rails.logger.auto_flushing = true }
  Resque.schedule = YAML.load_file("#{Rails.root}/config/schedule.yml") 
end
