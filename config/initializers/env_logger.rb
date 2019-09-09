Rails.application.config.before_initialize do
  puts("Environment: #{ENV.to_h}")
end