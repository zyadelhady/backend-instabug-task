class Chat < ApplicationRecord
  validates :number, presence: true
  validates :messages_count, presence: true

  belongs_to :application
  has_many :messages, dependent: :delete_all

  def redis_key
    "chat:#{self.id}:application:#{self.application_id}:messagesCount"
  end
end
