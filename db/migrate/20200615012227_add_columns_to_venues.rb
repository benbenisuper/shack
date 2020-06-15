class AddColumnsToVenues < ActiveRecord::Migration[6.0]
  def change
  	add_column :venues, :sku, :string
  end
end
