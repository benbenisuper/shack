class AddZoneToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :zone, :integer
  end
end
