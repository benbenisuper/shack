class AddPublishedToVenues < ActiveRecord::Migration[6.0]
  def change
    add_column :venues, :published, :boolean, default: false
  end
end
