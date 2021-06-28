class SessionsController < ApplicationController

    def new
        @user = User.new
        render 'login'
    end

    def create
        @user = User.find_or_create_by(username: params[:username])
        redirect_to 'songs/index'        
    end

    def logout
        session.clear
        redirect_to '/'
    end
end