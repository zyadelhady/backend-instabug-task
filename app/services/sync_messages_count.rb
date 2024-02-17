class SyncMessagesCount
  def self.sync_now()
    # we should use pagination if the table is too big
    chats = Chat.all()

    chats.each do |chat|
      current_val = REDIS.get(chat.redis_key)

      if current_val.present?
        chat.update(messages_count: current_val.to_i)
      end
    end
  end
end
