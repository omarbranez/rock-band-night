class Song < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to :artist
    belongs_to :genre
    has_many :user_songs
    has_many :users, through: :user_songs

    validates_presence_of :name
    validates_presence_of :artist_id
    validates :year, numericality: { greater_than: 1954, less_than_or_equal_to: Proc.new {|record| Date.current.year } }
    validates :vocal_parts, presence: true, inclusion: { in: 0..3, message: "Number of Vocal Parts must be between 0 and 3" }

    accepts_nested_attributes_for :artist
    accepts_nested_attributes_for :genre

    before_create :check_name_for_article, :set_song_source_and_availability, :get_xbox_link, :get_psn_link, :get_spotify_id
    scope :owned, ->(user) { left_outer_joins(:users).where(user_songs: { user_id: user.id } ) }
    scope :unowned, ->(user) { where.not(id: owned(user)) }
    # scope :search ->(search) { where("lower(artists.name) LIKE :search OR lower(songs.name) LIKE :search", search: "%#{search.downcase}%").distinct   


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

    def has_ratings?
        !UserSong.where(song_id: self.id).average(:rating).nil?
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

    def set_song_source_and_availability
        self.source = 100
        self.availability = 4
    end
    
    def get_xbox_link
        m = Mechanize.new
        m.user_agent_alias = 'Mac Safari'
        page = m.get("https://www.google.com")
        google_form = page.form('f') 
        google_form.q = "microsoft.com/en-us/ \"#{self.name}\" \"#{song.artist.name}\" -rocksmith -\"dance central\""
        page = m.submit(google_form)
        pp = page.links_with :href => /microsoft.com\/en-us\/p/
        if pp.first.href
            self.xbox_link = pp.first.href[32..-1].gsub(/\&sa(.*)/, "")
        else
            self.xbox_link = "Scrape Error"
        end
    end

    def get_psn_link
        m = Mechanize.new
        m.user_agent_alias = 'Mac Safari'
        page = m.get("https://www.google.com")
        google_form = page.form('f') 
        google_form.q = "store.playstation.com/en-us \"#{self.name}\" \"#{self.artist.name}\" -rocksmith"
        page = m.submit(google_form)
        pp = page.links_with :href => /store.playstation.com\/en-us\/product/
        if pp.first.href
            self.psn_link = pp.first.href[36..-1].gsub(/\&sa(.*)/, "").gsub(/\%3(.*)/, "")
        else
            self.psn_link = "Scrape Error"
        end
    end

    # def render_xbox_link
    #     if self.id > 2795
    #     page = Mechanize.new.get("https://www.google.com")
    #     google_form = page.form('f') 
    #     google_form.q = "#{self.xbox_link}"
    #     page = Mechanize.new.submit(google_form)
    #     page.links[15].href[7..63]
    # end

    # def render_psn_link
    #     page = Mechanize.new.get("https://www.google.com")
    #     google_form = page.form('f') 
    #     google_form.q = "#{self.psn_link}"
    #     page = Mechanize.new.submit(google_form)
    #     page.links[15].href[7..86]
    # end # moved to song helpers

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

    def self.search(search)  
        where("lower(artists.name) LIKE :search OR lower(songs.name) LIKE :search", search: "%#{search.downcase}%").distinct   
     end
end