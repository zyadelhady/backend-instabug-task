class Chat < ApplicationRecord
  validates :number, presence: true
  validates :messages_count, presence: true

  belongs_to :application
  has_many :messages
end
