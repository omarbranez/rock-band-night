class UserSongsController < ApplicationController
    def create
        user_song = UserSong.create(user_song_params)
        # binding.pry
        redirect_to user_path(user_song.user)
    end

    def destroy
        user_song = UserSong.find_by(user_song_params)
        if current_user.id == user_song.user_id
        # binding.pry
            user_song.delete
            redirect_to songs_path, flash: { message: "Deleted #{Song.find(user_song.song_id).full_title} from collection"}
        else
            redirect_to songs_path, flash: { message: "You cannot delete another user's songs" }
        end
    end
    private
    
    def user_song_params
        params.require(:user_song).permit(:user_id, :song_id)
    end
end