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

    private
    
    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation)
    end
end