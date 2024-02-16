class MessagesConsumer < Racecar::Consumer
  subscribes_to "messages"

  def process(message)
    msg_attributes = JSON.parse(message.value)

    msg = Message.new(msg_attributes)

    if msg.save
      puts "Message record saved: #{msg.inspect}"
    else
      puts "Failed to save Message record: #{msg.errors.full_messages}"
    end
  rescue JSON::ParserError => e
    puts "Failed to parse JSON message: #{e.message}"
  end
end
