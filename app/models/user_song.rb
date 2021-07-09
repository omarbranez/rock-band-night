class UserSong < ActiveRecord::Base
    belongs_to :user
    belongs_to :song


    def average_rating
        if somebody_owns_song && song_has_ratings
            UserSong.where(song_id: self.song_id).average(:rating).to_f
        else
            "This song does not have any ratings yet."
        end
    end

    def count_ratings
        if UserSong.where(song_id: self.song_id).exists?
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