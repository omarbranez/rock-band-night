module ApplicationHelper

    def user_is_admin?
        !!current_user == User.find(1)
    end

    def get_album_art_url(song)
        RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
        track = RSpotify::Track.search("#{song.full_title} artist:#{song.artist.full_name}")
        album = RSpotify::Album.find("#{track.first.album.id}")
        album.images.second.values.second
    end

    def display_album_art(song)
        image_tag(get_album_art_url(song), class: "card-img-top")
    end

    def get_album_name(song)
        RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
        track = RSpotify::Track.search("#{song.full_title} artist:#{song.artist.full_name}")
        track.first.album.name
    end
end