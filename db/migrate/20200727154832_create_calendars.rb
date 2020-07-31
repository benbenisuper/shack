class CreateCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :calendars do |t|
    	t.references :venue, null: false, foreign_key: true
		t.monetize :hour_price
		t.monetize :day_price
		t.string :min_time
		t.string :max_time
		t.string :day_discount

		t.timestamps
    end
  end
end
