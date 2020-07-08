class CreateVenueSpecs < ActiveRecord::Migration[6.0]
  def change
    create_table :venue_specs do |t|
      t.references :venue, null: false, foreign_key: true
      t.float :total_area
      t.integer :spaces
      t.integer :bathrooms
      t.integer :garage_spaces

      t.timestamps
    end
  end
end
