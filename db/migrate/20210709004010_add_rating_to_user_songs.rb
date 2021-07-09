class AddRatingToUserSongs < ActiveRecord::Migration[6.1]
  def change
    add_column :user_songs, :rating, :integer
  end
end
