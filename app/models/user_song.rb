class UserSong < ActiveRecord::Base
    belongs_to :user
    belongs_to :song

    def average_rating
        self.average(:rating) != nil ? self.average(:rating).to_f : "This song does not have any ratings yet"
    end
end