class Message < ApplicationRecord
  validates :number, presence: true
  validates :content, presence: true

  belongs_to :chat
end
