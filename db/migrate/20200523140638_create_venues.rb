class CreateVenues < ActiveRecord::Migration[6.0]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :location
      t.references :user, null: false, foreign_key: true
      t.string :category
      t.text :description
      t.integer :capacity
      t.string :activity
      t.float :price
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
