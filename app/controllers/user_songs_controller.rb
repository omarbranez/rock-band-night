class UserSongsController < ApplicationController
    def create
        user_song = UserSong.create(user_song_params)
        # redirect_to user_path(user_song.user)
        flash[:notice] = "Successfully added #{last_song_added} to collection!"
        redirect_to session.delete(:return_to)
    end

    def destroy
        user_song = UserSong.find_by(user_song_params)
        if current_user.id == user_song.user_id
            user_song.delete
            redirect_to songs_path, flash: { message: "Deleted #{Song.find(user_song.song_id).full_title} from collection"}
        else
            redirect_to songs_path, flash: { message: "You cannot delete another user's songs" }
        end
    end

    def rate_song
        user_song = UserSong.find_by(user_song_params)
        user_song.update(rating_params)
        redirect_to song_path(Song.find(user_song.song_id)), flash: { message: "Rating Successfully Updated!" }
    end

    def add_game
        # songs = Song.where(source: params[:source]).pluck(:id)
        # songs.each do |song|
        #     UserSong.create(user_id: current_user.id, song_id: song)
        # end
        add_songs_from_game(params[:source])
        redirect_to user_path(current_user)
    end
    
    private
    
    def user_song_params
        params.require(:user_song).permit(:user_id, :song_id)
    end
    
    def rating_params
        params.require(:user_song).permit(:user_id, :song_id, :rating)
    end

    def add_songs_from_game(source_params)
        songs = Song.where(source: source_params).pluck(:id)
        songs.each do |song|
            UserSong.create(user_id: current_user.id, song_id: song)
        end
    end

    def last_song_added
        Song.find(current_user.user_songs.last.song_id).full_title
    end
    
end