class UsersController < ApplicationController
    # skip_before_action :current_user, only: [:new, :create]
    # skip_before_action :redirect_if_not_logged_in, only: [:new, :create] # wont require the user to be logged in in order to...log in

    def new
        if logged_in?
            redirect_to root_path
        else
            @user = User.new
        end
    end
    
    def create
        @user = User.new(user_params)
        if @user.valid?
            @user.save
            session[:user_id] = @user.id
            redirect_to user_path(@user)
        else
            render 'new'
        end
    end

    def show
        @user = User.find_by(id: params[:id])
    end
    
    def toggle_party
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
    
    def destroy
        @user = User.find(params[:id])
        if current_user == @user
            @user.destroy
            session.clear
            redirect_to root_path
        else
            flash[:notice] = "That's not nice!"
        end
    end

    private

    def username
        @user = User.find_by(id: params[:id])
    end
    
    def create_username
        user = User.find_by(email: params[:user][:email])
        user.username = params[:user][:username]
        user.save        
        redirect_to user_path(user.username)        
    end


    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end
end