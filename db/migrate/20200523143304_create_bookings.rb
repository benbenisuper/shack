class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.references :venue, null: false, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
