class User < ActiveRecord::Base
    has_many :user_songs
    has_many :songs, through: :user_songs
    validates_presence_of :username
    validates_uniqueness_of :username
    has_secure_password
    # validates :password_confirmation, presence: true
    # user will have artists as well, for the sake of the booklet
    # ADMIN can add songs and update information
    # HOSTS can suggest information
    # will split users into HOSTS and GUESTS
    # HOST can read, update, destroy (after song is played)
    # GUEST can read, create (no skipping other people's songs!) 
    # def self.find_or_create_from_windows(user_info)
    #   find_or_create_by(email: user_info[:email] do |user|)
    # 

    def last_song_added
        Song.find(self.user_songs.last.song_id).full_title
    end
end