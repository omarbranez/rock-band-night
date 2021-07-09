class Song < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to :artist
    belongs_to :genre
    has_many :user_songs
    has_many :users, through: :user_songs

    def full_title
        if self.article != ""
            "#{self.article}" + " " + "#{self.name}"
        else
            "#{self.name}"
        end
    end

    def artist_name
        self.try(:artist).try(:name)
    end

    def length_in_minutes
        Time.at(self.duration / 1000).strftime("%M:%S")
    end
    
    def harmony_parts?
        if self.vocal_parts > 1
            "Yes, this song has #{self.vocal_parts} vocal parts"
        elsif self.vocal_parts == 1
            "Solo Only"
        else
            "This song does not have vocals"
        end
    end

    def is_song_cover?
        if self.cover == true
            "As made famous by "
        end
    end

    # def average_rating
    #     if !UserSong.where(song_id: self.id).count(:rating).nil?
    #         UserSong.where(song_id: self.id).average(:rating).to_f
    #     else
    #         "This song does not have any ratings yet."
    #     end
    # end

    def own_rating_exists?(user)
        !UserSong.where(song_id: self.id).pluck(:rating).nil?
        # !current_user.user_songs.where(song_id: self.id).rating.nil?
    end
end