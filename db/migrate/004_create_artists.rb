class CreateArtists < ActiveRecord::Migration[6.0]
    def change
        create_table :artists do |t|
            t.string :article
            t.string :name
        end
    end
end