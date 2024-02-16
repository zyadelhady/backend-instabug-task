class SyncChatsCount
  def self.sync_now()
    applications = Application.all()


    applications.each do |application|
      current_val = REDIS.get(application.redis_key)

      if current_val.present?
        application.update(chats_count: current_val.to_i)
      end
    end
  end
end
