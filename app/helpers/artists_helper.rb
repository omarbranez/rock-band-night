module ArtistsHelper

    def new_button_for_admin
        if current_user == User.find(1)
            link_to "New Song for Artist", new_artist_song_path(@artist)
        end
    end
end