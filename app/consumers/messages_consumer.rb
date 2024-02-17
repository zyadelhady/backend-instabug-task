class MessagesConsumer < Racecar::Consumer
  subscribes_to "messages"

  def process(message)
    msg_attributes = JSON.parse(message.value)


    msg = Message.new(msg_attributes.except('application_token','chat_number'))

    if msg.save
      elastic_msg = {
          content: msg_attributes['content'],
          application_token: msg_attributes['application_token'],
          chat_number: msg_attributes['chat_number'],
          created_at: msg['created_at'],
          number: msg_attributes['number']
      }
      produce(elastic_msg.to_json, topic: "elastic_messages")
      puts "Message record saved: #{msg.inspect}"
    else
      puts "Failed to save Message record: #{msg.errors.full_messages}"
    end
  rescue JSON::ParserError => e
    puts "Failed to parse JSON message: #{e.message}"
  end
end
