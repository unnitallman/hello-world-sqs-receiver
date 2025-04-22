SidekiqSqsProcessor.configure do |config|
  config.aws_access_key_id = ENV['SQS_AWS_ACCESS_KEY_ID']
  config.aws_secret_access_key = ENV['SQS_AWS_SECRET_ACCESS_KEY']
  config.aws_region = 'us-east-1'

  config.queue_urls = ["https://sqs.us-east-1.amazonaws.com/348674388966/fanout-receiver-2"] # Add your queue URLs here, e.g. ['https://sqs.us-east-1.amazonaws.com/123456789012/my-queue']
  
  config.visibility_timeout = 60    # 1 minutes
  config.max_number_of_messages = 10 # Max messages per receive call
  
  config.polling_enabled = true
  config.poll_on_startup = true
  
  # Sidekiq options
  config.worker_queue_name = 'default' # Default queue name for SQS worker jobs
  config.worker_retry_count = 2            # Number of retries for failed jobs
  
  # Custom error handling (optional)
  # Uncomment to add custom error reporting (e.g., to a monitoring service)
  # config.error_handler = ->(error, context) do
  #   # Report to your error monitoring service
  #   Raven.capture_exception(error, extra: context) if defined?(Raven)
  #   Rails.logger.error("SQS Error: #{error.message}\nContext: #{context.inspect}")
  # end
end
