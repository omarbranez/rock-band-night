module ArtistsHelper

    def new_button_for_admin
        if user_is_admin
            link_to "New Song for Artist", new_artist_song_path(@artist, @artist.songs.build)
        end
    end
end