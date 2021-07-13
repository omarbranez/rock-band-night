class Song < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to :artist
    belongs_to :genre
    has_many :user_songs
    has_many :users, through: :user_songs

    validates_presence_of :name
    accepts_nested_attributes_for :artist
    accepts_nested_attributes_for :genre

    before_create :check_name_for_article

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

    def own_rating_exists?(user)
        !UserSong.where(song_id: self.id).pluck(:rating).nil?
        # !current_user.user_songs.where(song_id: self.id).rating.nil?
        # does this do anything anymore?
    end

    def primary_source
        case self.source
            when 1
                "Rock Band 1"
            when 2
                "Rock Band 2"
            when 3
                "Rock Band 3"
            when 4
                "Rock Band 4"
            when 21 
                "Rock Band Track Pack: Vol. 1"
            when 22 
                "Rock Band Track Pack: Vol. 2"
            when 23 
                "AC/DC Live: Rock Band Track Pack"
            when 24 
                "Rock Band Track Pack: Classic Rock"
            when 25 
                "Rock Band Country Track Pack"
            when 26 
                "Rock Band Metal Track Pack"
            when 27 
                "Rock Band Country Track Pack 2"
            when 51
                "LEGO: Rock Band"
            when 52
                "Green Day: Rock Band"
            when 53
                "Rock Band Blitz"    
            when 99
                "Rock Band Network"
            else
                "Downloadable Content"
        end
    end

    def artist_name=(name)
        name.check_name_for_article
        self.artist = Artist.find_or_create_by(name: name)

    end

    def check_name_for_article
        if self.name[0..2] == "The"
            self.article = "The"
            self.name = self.name.delete_prefix("The ")
        elsif self.name[0..1] == "A "
            self.article = "A"
            self.name = self.name.delete_prefix("A ")
        else
            self.article = ""
        end
    end

end