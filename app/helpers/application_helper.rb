module ApplicationHelper

    def user_is_admin?
        !!current_user == User.find(1)
    end

    def get_album_art_url(song)
        RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
        track = RSpotify::Track.search("#{song.full_title} artist:#{song.artist.full_name}")
        if !track.empty?
            album = RSpotify::Album.find("#{track.first.album.id}")
            album.images.second.values.second
        end
    end

    def display_album_art(song)
        if !get_album_art_url(song).nil?
            image_tag(get_album_art_url(song), class: "card-img-top")
        else
            "No Album Artwork Found"
        end
    end

    def get_album_name(song)
        RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
        track = RSpotify::Track.search("#{song.full_title} artist:#{song.artist.full_name}")
        if !track.empty?
            track.first.album.name
        else
            "Album Information Not Found"
        end
    end
end