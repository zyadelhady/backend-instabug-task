class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :number
      t.references :chat, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
