class SessionsController < ApplicationController

    def new
        @user = User.new
    end

    def create
        if params[:provider]
            # binding.pry
            user = User.create_by_omniauth(auth)
            session[:user_id] = user.id
            # if user.username == user.email # probably not needed, now that it happens after create
            #     flash[:notice] = "#{user.email} successfully logged in"
            #     redirect_to username_path(current_user)
            # else
                flash[:notice] = "#{user.username} successfully logged in"
                redirect_to user_path(current_user.username)
            # end
        else
            user = User.find_by(username: params[:username])
            if user.authenticate(params[:password])
                session[:user_id] = user.id
                flash[:notice] = "#{user.username} successfully logged in"
                redirect_to user_path(current_user.username)
            else
                redirect_to signin_path
            end
        end
    end

    def destroy
        session.clear
        flash[:notice] = "You have been logged out"
        redirect_to root_path
    end

    private 

    def auth
        request.env['omniauth.auth']
    end

    
end