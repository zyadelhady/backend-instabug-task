class MessagesConsumer < Racecar::Consumer
  subscribes_to "messages"

  def process(message)

    msg_attributes = JSON.parse(message.value)
    msg_body = msg_attributes.except('application_token','chat_number')

    p msg_body

    if msg_body['id']
      Message.update(msg_body['id'], { content: msg_body['content'] })
    else
      new_message = Message.create!(msg_body)
      msg_attributes['id'] = new_message['id']
    end
    produce(msg_attributes.to_json, topic: "elastic_messages")
  rescue JSON::ParserError => e
    puts "Failed to parse JSON message: #{e.message}"
  end
end
