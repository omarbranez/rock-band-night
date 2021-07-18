module ApplicationHelper

    def user_is_admin?
        !!current_user == User.find(1)
    end

end