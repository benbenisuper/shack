class AddPriceToVenues < ActiveRecord::Migration[6.0]
  def change
  	add_monetize :venues, :price, currency: { present: false }
  end
end
