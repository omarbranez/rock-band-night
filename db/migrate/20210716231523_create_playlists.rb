class CreatePlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.integer :host_id
      t.integer :guest_id
      t.integer :position

      t.timestamps
    end
  end
end
