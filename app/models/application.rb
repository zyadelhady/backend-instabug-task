class Application < ApplicationRecord
  validates :name, presence: true, exclusion: { in: [nil, ""] }
  validates :token, presence: true
  validates :chats_count, presence: true

  has_many :chats, dependent: :delete_all
end
