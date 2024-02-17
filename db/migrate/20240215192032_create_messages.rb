class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :content, null: false
      t.integer :number, null: false
      t.references :chat, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
      add_index :messages, :number
  end
end
