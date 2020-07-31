class CreateDays < ActiveRecord::Migration[6.0]
  def change
    create_table :days do |t|
    	t.references :calendar, null: false, foreign_key: true
      t.integer :month
      t.integer :year
      t.integer :wday
      t.monetize :hour_price
      t.monetize :day_price
      t.string :min_time
      t.string :max_time
      t.datetime :date
      t.integer :day
      t.integer :wnum

      t.timestamps
    end
  end
end
