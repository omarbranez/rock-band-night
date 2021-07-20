class ChangePartyEnabledColumnForUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :party_enabled, from: nil, to: false
  end
end
