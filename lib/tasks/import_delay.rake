task :import_delay => :environment do
  Delayed::Job.enqueue ImportJob.new
end

