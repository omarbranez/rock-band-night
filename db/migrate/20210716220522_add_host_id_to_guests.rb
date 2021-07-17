class AddHostIdToGuests < ActiveRecord::Migration[6.1]
  def change
    add_column :guests, :host_id, :integer
  end
end
