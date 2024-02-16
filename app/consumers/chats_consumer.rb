class ChatsConsumer < Racecar::Consumer
  subscribes_to "chats"

  def process(message)
    chat_attributes = JSON.parse(message.value)

    chat = Chat.new(chat_attributes)

    if chat.save
      puts "Chat record saved: #{chat.inspect}"
    else
      puts "Failed to save chat record: #{chat.errors.full_messages}"
    end
  rescue JSON::ParserError => e
    puts "Failed to parse JSON message: #{e.message}"
  end
end
