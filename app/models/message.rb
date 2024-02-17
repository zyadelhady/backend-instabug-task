class Message < ApplicationRecord
  validates :number, presence: true
  validates :content, presence: true

  belongs_to :chat


  include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :content, type: 'text'
      indexes :chat, type: 'nested' do
        indexes :application_id, type: 'text'
        indexes :number, type: 'integer'
      end
    end
  end
end
