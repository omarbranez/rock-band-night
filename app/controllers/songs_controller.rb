class SongsController < ApplicationController
    def index
        @songs = Song.all
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
        params.require(:song).permit(:artist_id)
    end
end