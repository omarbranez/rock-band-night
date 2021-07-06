class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    helper_method :current_user, :logged_in?, :owns_resource?, :redirect_if_not_logged_in, :message_if_not_admin, :message_if_not_logged_in, :authorized?

    private

    def current_user
        User.find_by(id: session[:user_id])
    end
    
    def logged_in?
        !!current_user
    end

    def owns_resource?(resource)
        resource.user == current_user
    end

    def message_if_not_admin
        if !current_user.admin
            flash[:notice] = "You do not have permission to perform this action"
        end
    end

    def redirect_if_not_logged_in
        if !logged_in?
            redirect_to root_path
        end
    end

    def message_if_not_logged_in
        if !logged_in?
            flash[:notice] = "You need to be logged in to perform this action"
        end
    end

    def authorized?
        redirect_to login_path unless logged_in?
    end
end