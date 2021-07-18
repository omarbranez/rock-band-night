class SessionController < ApplicationController

    def new
        @user = User.new
    end

    def create
        # binding.pry
        user = User.find_by(username: params[:username])
        if user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to user_path(current_user)
        else
            redirect_to signin_path
        end
    end

    def logout
        session.clear
        redirect_to root
    end
end