task :import_delay => :environment do
  Delayed::Job.enqueue ImportJob.new, 5, Time.now.beginning_of_day + 1.day
end

