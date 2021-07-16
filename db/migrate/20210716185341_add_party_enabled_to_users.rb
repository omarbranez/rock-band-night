class AddPartyEnabledToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :party_enabled, :boolean
  end
end
