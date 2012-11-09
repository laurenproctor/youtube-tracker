task :import_delay => :environment do
  Delayed::Job.enqueue ImportJob.new, 2, Time.now.beginning_of_day + 1.day + 30.minutes
end

