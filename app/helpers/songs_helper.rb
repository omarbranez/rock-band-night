module SongsHelper
    
    def render_game_button(source, source_id)
        button_to "#{source}", action: "add_game", controller: "user_songs", params: { source: source_id }
    end

    def game_already_in_collection?(source_id)
        current_user.songs.where(source: source_id).size  == Song.where(source: source_id).size
    end

    def edit_button_for_admin
        if current_user == User.find(1)
            link_to "Edit Song Details", edit_artist_song_path(@song.artist, @song)
        end
    end

    def new_button_for_admin
        if current_user == User.find(1)
            link_to "Create New Song", new_artist_song_path(@artist, @artist.songs.build)
        end
    end

    def destroy_button_for_admin
        if current_user == User.find(1)
            link_to "Delete Song", artist_song_path(@song.artist, @song), method: :delete
        end
    end

    def render_xbox_link
        if self.id > 2795
            link_to "Buy this song on Xbox Live Marketplace", "https://www.microsoft.com#{self.xbox_link}"
        else
            link_to "Buy this song on Xbox Live Marketplace", "rbdb/#{self.xbox_link}"
        end
    end

    def render_psn_link
        if self.id > 2795
            link_to "Buy this song on Playstation Store", "https://www.microsoft.com#{self.psn_link}"
        else
            link_to "Buy this song on Playstation Store", "rbdb/#{self.psn_link}"
        end
    end
    
    def display_own_rating
        if !@user_song.find_by(user_id: current_user.id, song_id: @song.id).rating.nil?
            content_tag(:p, "Your Rating: #{@user_song.find_by(user_id: current_user.id, song_id: @song.id).rating}")
        else
            content_tag(:p, "You have not rated this song yet.")
        end
    end

end