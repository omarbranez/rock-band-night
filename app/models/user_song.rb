class UserSong < ActiveRecord::Base
    belongs_to :user
    belongs_to :song
    validates_uniqueness_of :user_id, :scope => [:song_id] 
    validates_inclusion_of :rating, :in => 1..5, allow_nil: true
    scope :owned, -> { where(user_id: current_user.id) }

    
    def self.average_rating
        if somebody_owns_song && has_ratings?
            self.average(:rating).to_f
        else
            "There are no ratings for this song yet."
        end
    end

    def self.count_ratings
        if somebody_owns_song
            self.count(:rating)
        end
    end

    def self.somebody_owns_song
        self.exists?
    end

    def self.has_ratings?
        !self.average(:rating).nil?
    end

    
end