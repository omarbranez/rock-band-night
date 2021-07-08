class UserSongsController < ApplicationController
    def create
        user_song = UserSong.create(user_song_params)
        binding.pry
        redirect_to user_path(user_song.user)
    end

    def destroy
        user_song = UserSong.find_by(song_id: params[:user_song][:song_id])
        # binding.pry
        user_song.delete
        redirect_to songs_path
    end
    private
    
    def user_song_params
        params.require(:user_song).permit(:user_id, :song_id)
    end
end