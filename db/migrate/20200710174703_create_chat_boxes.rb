class CreateChatBoxes < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_boxes do |t|
      t.string :name
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
