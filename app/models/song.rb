class Song < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to :artist
    belongs_to :genre
    has_many :user_songs
    has_many :users, through: :user_songs

    validates_presence_of :name
    validates_presence_of :artist_id
    validates :year, presence: true,  inclusion: { in: 1955..Date.today.year, message: "Year must be between 1955 and the current year" }
    validates :vocal_parts, presence: true, inclusion: { in: 0..3, message: "Number of Vocal Parts must be between 0 and 3" }

    accepts_nested_attributes_for :artist
    accepts_nested_attributes_for :genre

    before_create :check_name_for_article, :set_song_source_and_availability, :get_xbox_link, :get_psn_link, :get_spotify_id
    # before_update :get_xbox_link, :get_psn_link #:get_spotify_id

    def full_title
        if self.article != ""
            "#{self.article}" + " " + "#{self.name}"
        else
            self.name
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
    
    # private 

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

    def set_song_source_and_availability
        self.source = 100
        self.availability = 4
    end
    
    def get_xbox_link
        m = Mechanize.new
        m.user_agent_alias = 'Mac Safari'
        page = m.get("https://www.google.com")
        google_form = page.form('f') 
        google_form.q = "xbox live en-us #{song.name} #{song.artist.name} -rocksmith -dance"
        page = m.submit(google_form)
        pp = page.links_with :href => /microsoft.com\/en-us\/p/
        song.xbox_link = pp.first.href[32..-1].gsub(/\&sa(.*)/, "")
        song.save
    end

    def get_psn_link
        page = Mechanize.new.get("https://www.google.com")
        google_form = page.form('f') 
        google_form.q = "psn #{self.artist.name} #{self.name}"
        page = Mechanize.new.submit(google_form)
        self.psn_link = page.links[15].href[51..86]
        # should i just copy the whole link, now that it's a string? # yup
    end

    def render_xbox_link
        page = Mechanize.new.get("https://www.google.com")
        google_form = page.form('f') 
        google_form.q = "#{self.xbox_link}"
        page = Mechanize.new.submit(google_form)
        page.links[15].href[7..63]
    end

    def render_psn_link
        page = Mechanize.new.get("https://www.google.com")
        google_form = page.form('f') 
        google_form.q = "#{self.psn_link}"
        page = Mechanize.new.submit(google_form)
        page.links[15].href[7..86]
    end

    def get_spotify_id
        RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
        tracks = RSpotify::Track.search("#{self.full_title}")
        binding.pry
        if tracks.first.artists.first.name == self.artist.full_name
            self.spotify_id = tracks.first.id
        elsif tracks.second.artists.first.name == self.artist.full_name
            self.spotify_id = tracks.second.id
        elsif tracks.third.artists.first.name == self.artist.full_name
            self.spotify_id = tracks.third.id
        else
            self.spotify_id = "Find It Yourself"
        end
    end
end