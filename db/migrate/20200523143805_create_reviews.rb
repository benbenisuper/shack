class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.float :rating
      t.text :comment

      t.timestamps
    end
  end
end
