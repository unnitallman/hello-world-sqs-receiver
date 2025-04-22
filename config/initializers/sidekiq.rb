# Configure Sidekiq with Redis
# This file is loaded alphabetically before sidekiq_sqs_processor.rb

require 'sidekiq'

# Define an application identifier for logs
# Note: In Sidekiq 7+, 'redis-namespace' gem is no longer supported
# We'll use simple Redis configuration without namespacing
app_name = ENV['SIDEKIQ_APP_NAME'] || 'hello_world_receiver'

# Configure Sidekiq with minimal Redis settings
# Only use supported options for Redis client
redis_conn_params = { 
  url: ENV['REDIS_URL'] || 'redis://localhost:6379/0'
}

# Configure Sidekiq server (workers)
Sidekiq.configure_server do |config|
  # Set Redis connection
  config.redis = redis_conn_params
  
  # Keep the default queue name that matches sidekiq_sqs_processor.rb
  config.queues = ['default']
end

# Configure Sidekiq client (enqueuing)
Sidekiq.configure_client do |config|
  # Set Redis connection 
  config.redis = redis_conn_params
end

# Log that Sidekiq has been configured
Rails.logger.info "Sidekiq configured for application: #{app_name}"
Rails.logger.info "Sidekiq using Redis connection: #{redis_conn_params[:url]}"

