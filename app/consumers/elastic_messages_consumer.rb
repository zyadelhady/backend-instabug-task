class ElasticMessagesConsumer < Racecar::Consumer
  subscribes_to "elastic_messages"

  def process(message)

    msg_attributes = JSON.parse(message.value)
    p msg_attributes
    $elastic.index(index: 'messages', body: msg_attributes)
  rescue JSON::ParserError => e
    puts "Failed to parse JSON message: #{e.message}"
  end
end
