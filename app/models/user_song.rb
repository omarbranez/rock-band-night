class UserSong < ActiveRecord::Base
    belongs_to :user
    belongs_to :song
    validates_uniqueness_of :user_id, :scope => [:song_id] # avoid duplicates of song ownership
    validates_inclusion_of :rating, :in => 1..5, allow_nil: true


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

    def add_songs_from_game(source_params)
        songs = Song.where(source: source_params).pluck(:id)
        songs.each do |song|
            UserSong.create(user_id: current_user.id, song_id: song.id)
        end
    end
end