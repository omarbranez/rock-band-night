class SongsController < ApplicationController
    def index
        @songs = Song.all
        if current_user
            @user_songs = UserSong.where(user_id: current_user.id)
        end
    end

    def show
        @song = Song.friendly.find(params[:id])
    end

    def edit
        @song = Song.friendly.find(params[:id])
        @artists = Artist.all
    end

    def update
        @song = Song.friendly.find(params[:id])
        @song.update(song_params)
        redirect_to @song
    end

    private

    def song_params
        params.require(:song).permit(:artist_id) # this is temporary so i can fix the mismatched artists
    end
end