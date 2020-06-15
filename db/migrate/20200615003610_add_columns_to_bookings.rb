class AddColumnsToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :venue_sku, :string
    add_column :bookings, :checkout_session_id, :string
  end
end
