class SongsController < ApplicationController
    def index
        @songs = Song.all
    end

    def show
        @song = Song.friendly.find(params[:id])
    end
end