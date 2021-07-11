class UserSong < ActiveRecord::Base
    belongs_to :user
    belongs_to :song
    validates_uniqueness_of :user_id, :scope => [:song_id] # avoid duplicates of song ownership
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

    def add_songs_from_game(source_params)
        songs = Song.where(source: source_params).pluck(:id)
        songs.each do |song|
            UserSong.create(user_id: current_user.id, song_id: song.id)
        end
    end
end