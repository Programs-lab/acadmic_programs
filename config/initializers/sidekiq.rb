def sidekiq_cron
  schedule_file = "config/schedule.yml"
  if File.exist?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end


Sidekiq.configure_server do |config|
  config.redis = { :size => 7, url: ENV.fetch("REDISTOGO_URL", "redis://localhost:6379"), namespace: "Gastromed_sidekiq_#{Rails.env}" }
  sidekiq_cron
end

Sidekiq.configure_client do |config|
  config.redis = { :size => 1, url: ENV.fetch("REDISTOGO_URL", "redis://localhost:6379"), namespace: "Gastromed_sidekiq_#{Rails.env}" }
end
