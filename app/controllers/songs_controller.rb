class SongsController < ApplicationController
    def index
        @songs = Song.all
        if current_user
            # binding.pry
            @user_song = current_user.user_songs.build(user_id: current_user.id)
            # if someone is logged in, initialize a new song for that user
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