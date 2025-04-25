
class SqsProcessorWorker < SidekiqSqsProcessor::BaseWorker
  def process_message(message)
    message_body = JSON.parse(message["Message"])

    case message_body['type']
    when 'user_sync'
      process_user_created(message_body['data'])
    when 'order_placed'
      process_order_placed(message_body['data'])
    else
      process_generic_hash(message_body)
    end
  end
  
  private
  
  def process_user_created(user_data)
    guid = user_data['guid']
    user = User.find_by(guid: guid)
    if user.nil?
      user = User.create(user_data)
    else
      user.update(user_data)
    end
  end
  
  def process_order_placed(order_data)
    logger.info("Processing order placed event")
  end
  
  def process_generic_hash(data)
    logger.info("Processing generic hash data with keys: #{data.keys.join(', ')}")
  end
end

