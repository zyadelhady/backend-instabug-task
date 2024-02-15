class Application < ApplicationRecord
  validates :name, presence: true
  validates :token, presence: true
  validates :chats_count, presence: true

  has_many :chats
end
