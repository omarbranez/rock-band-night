class UsersController < ApplicationController
    # skip_before_action :current_user, only: [:new, :create]
    # skip_before_action :redirect_if_not_logged_in, only: [:new, :create] # wont require the user to be logged in in order to...log in

    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.valid?
            @user.save
            session[:id] = @user.id
            redirect_to user_path(@user)
        end
    end

    def show
        @user = User.find_by(id: params[:id])
    end

    def username
        @user = User.find_by(id: params[:id])
    end
    
    def create_username
        user = User.find_by(email: params[:user][:email])
        user.username = params[:user][:username]
        user.save        
        redirect_to user_path(user.username)        
    end

    # def add_song
    #     song = Song.friendly.find(params[:id])
    #     current_user.user_songs.create(song_id: song.id)
    #     redirect_to songs_path
    # end

    def toggle_party
        # change party_enabled to default false

        current_user.toggle(:party_enabled).save
        if current_user.party_enabled == true 
            flash[:notice] = "You have entered Party Mode" 
            redirect_to party_root_path
        else
            if current_user.party_enabled == false
            flash[:notice] = "You have exited Party Mode"
            redirect_to root_path
            end
        end
    end

    private
    
    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end
end