class ChangeDataTypeForXboxpsn < ActiveRecord::Migration[6.1]
  def change
    change_column :songs, :xbox_link, :string
    change_column :songs, :psn_link, :string
  end
end
