class PlaylistsController < ApplicationController

    def show
        @playlist = Playlist.find_by(playlsit_params)
    end

    def update
        playlist = Playlist.update(playlist_params)
        # playlist methods depending on host or guest actions
        redirect_to playlist_path
    end

    private

    def playlist_params
        params.require(:playlist).permit(:host_id, :guest_id, :position)
    end
end