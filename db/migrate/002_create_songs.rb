class CreateSongs < ActiveRecord::Migration[6.0]
    def change
        create_table :songs do |t|
            t.string :article
            t.string :name
            t.integer :artist_id, index: true, foreign_key: true
            t.integer :genre_id, index: true, foreign_key: true
            t.integer :year
            t.integer :gender
            t.integer :vocal_parts
            t.integer :vocal_percussion
            t.integer :band_tier
            t.integer :bass_tier
            t.integer :drums_tier
            t.integer :guitar_tier
            t.integer :vocals_tier
            t.boolean :cover
            t.integer :duration
            t.integer :bpm
            t.integer :availability
            t.integer :source
            t.string :spotify_id
            t.integer :psn_link
            t.integer :xbox_link
            t.integer :amazon_link
            t.integer :itunes_link
            t.integer :google_link
        end
    end
end