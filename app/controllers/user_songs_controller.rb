class UserSongsController < ApplicationController
    # include ActiveModel::Validations    
    # validates_presence_of :user_id
    # validates_presence_of :song_id
    # validates :rating, inclusion: { in: 1..5, message: "Rating must be between 1 and 5" }
    before_action :message_if_not_logged_in 
    
    def create
        user_song = UserSong.create(user_song_params)
        flash[:notice] = "Successfully added #{last_song_added} to collection!"
        if session[:return_to] 
            redirect_to session.delete(:return_to)
        else
            redirect_to songs_path
        end
    end

    def destroy
        user_song = UserSong.find_by(user_song_params)
        if current_user.id == user_song.user_id
            user_song.destroy
            redirect_to songs_path, flash: { message: "Deleted #{Song.find(user_song.song_id).full_title} from collection"}
        else
            redirect_to songs_path, flash: { message: "You cannot delete another user's songs" }
        end
    end

    def rate_song
        user_song = UserSong.find_by(user_song_params)
        user_song.update(rating_params)
        redirect_to artist_song_path(Song.find(user_song.song_id).artist, Song.find(user_song.song_id)), flash: { message: "Rating Successfully Updated!" }
    end

    def add_game
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