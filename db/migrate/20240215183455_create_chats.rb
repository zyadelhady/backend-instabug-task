class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer :number, null: false
      t.integer :messages_count, default: 0, null: false
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
