module SongsHelper
    
    def render_game_button(source, source_id)
        button_to "#{source}", action: "add_game", controller: "user_songs", params: { source: source_id }
    end

    def game_already_in_collection?(source_id)
        current_user.songs.where(source: source_id).size  == Song.where(source: source_id).size
    end
end