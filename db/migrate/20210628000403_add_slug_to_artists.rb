class AddSlugToArtists < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :slug, :string
    add_index :artists, :slug, unique: true
  end
end
