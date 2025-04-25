# SQS Message Processor

This application processes messages from an AWS SQS queue using Sidekiq and the `sidekiq_sqs_processor` gem.

## Prerequisites

- Ruby (version specified in `.ruby-version`)
- AWS SQS queue
- Required environment variables (see below)

## Environment Variables

The following environment variables are required to run the SQS processor:

```bash
SQS_AWS_ACCESS_KEY_ID=your_access_key_id
SQS_AWS_SECRET_ACCESS_KEY=your_secret_access_key
SQS_QUEUE_URL=your_queue_url
```

## Starting the SQS Poller

To start the SQS message processor, you need to start Sidekiq with the required environment variables:

```bash
bundle exec sidekiq
```

The processor will automatically start polling the configured SQS queue when Sidekiq starts.

## Configuration

The SQS processor is configured in `config/initializers/sidekiq_sqs_processor.rb` with the following settings:

- AWS Region: us-east-1
- Visibility Timeout: 60 seconds
- Max Messages per Receive: 10
- Worker Queue Name: 'default'
- Worker Retry Count: 2

## Message Processing

The `SqsProcessorWorker` class (`app/workers/sqs_processor_worker.rb`) handles different types of messages:

1. **User Sync Messages** (`type: 'user_sync'`)
   - Creates or updates a user based on the provided GUID
   - Updates user data if the user already exists

2. **Order Placed Messages** (`type: 'order_placed'`)
   - Currently logs the order placement event
   - Can be extended to handle order processing logic

3. **Generic Messages**
   - Logs the keys present in the message data
   - Can be extended to handle other message types

## Message Format

Messages should be in the following JSON format:

```json
{
  "type": "message_type",
  "data": {
    // Message-specific data
  }
}
```

## Error Handling

The processor includes basic error handling and logging. Failed jobs will be retried up to 2 times before being considered failed (by Sidekiq). If a DLQ is configured for your SQS queue, failed jobs will automatically move to the DLQ retries by SQS.

## Monitoring

You can monitor the Sidekiq processes and jobs through the Sidekiq web interface (if configured) or through your AWS CloudWatch metrics for the SQS queue.
