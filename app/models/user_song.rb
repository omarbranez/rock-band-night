class UserSong < ActiveRecord::Base
    belongs_to :user
    belongs_to :song
    validates_inclusion_of :rating, :in => 1..5, allow_nil: true

    def average_rating
        if somebody_owns_song && song_has_ratings
            UserSong.where(song_id: self.song_id).average(:rating).to_f
        else
            "There are no ratings for this song yet."
        end
    end

    def count_ratings
        if somebody_owns_song
            UserSong.where(song_id: self.song_id).count(:rating)
        end
    end

    def somebody_owns_song
        UserSong.where(song_id: self.song_id).exists?
    end

    def song_has_ratings
        !UserSong.where(song_id: self.song_id).average(:rating).nil?
    end
end