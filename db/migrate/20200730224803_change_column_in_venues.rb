class ChangeColumnInVenues < ActiveRecord::Migration[6.0]
  def change
  	change_column :venues, :zone, :string
  end
end
