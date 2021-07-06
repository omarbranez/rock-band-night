class UserSongsController < ApplicationController
    def create
        user_song = UserSong.create(user_song_params)
        redirect_to user_path(song.user)
    end

    private
    
    def user_song_params
        params.require(:user_song).permit(:user_id, :song_id)
    end
end