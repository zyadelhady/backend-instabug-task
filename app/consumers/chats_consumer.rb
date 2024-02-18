class ChatsConsumer < Racecar::Consumer
  subscribes_to "chats"

  def process(message)
    chat_attributes = JSON.parse(message.value)

    chat = Chat.new(chat_attributes)

    chat.save!
  rescue JSON::ParserError => e
    puts "Failed to parse JSON message: #{e.message}"
  end
end
