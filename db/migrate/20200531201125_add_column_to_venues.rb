class AddColumnToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :perks, :string
  end
end
