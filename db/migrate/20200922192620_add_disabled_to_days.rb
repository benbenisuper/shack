class AddDisabledToDays < ActiveRecord::Migration[6.0]
  def change
    add_column :days, :disabled, :boolean, default: false
  end
end
