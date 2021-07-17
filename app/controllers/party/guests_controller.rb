class Party::GuestsController < ApplicationController

    def index
        @songs = current_user.songs
    end
    
    def new
        @song = Song.new
    end

    def create
        guest = Guest.create(guest_params)
        if current_user.id == guest.host_id
            flash[:success] = "#{Song.find(guest.selection)} added to queue!"
            redirect_to playlist_path(current_user) 
        else
            flash[:alert] = "You do not have permission to perform this action"
            redirect_to party_root_path
        end
    end

    def destroy
        guest = Guest.find_by(guest_params)
        if current_user.id == guest.host_id
            guest.delete
            redirect_to playlist_path(current_user)
        else
            flash[:alert] == "You do not have permission to perform this action"
            redirect_to party_root_path
        end
    end

    private

    def guest_params
        params.require(:guest).permit(:host_id, :name, :selection)
    end

end