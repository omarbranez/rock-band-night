class User < ActiveRecord::Base
    has_many :user_songs
    has_many :songs, through: :user_songs
    # validates_presence_of :username
    # validates_uniquness_of :username
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
        Song.find(self.user_songs.last.song_id)
    end

    def user_is_admin
        current_user == User.find(1)
    end

    def create_username
        @user = current_user
        
    end

    def self.create_by_omniauth(auth)
        self.find_or_create_by(username: auth[:info][:email]) do |user|
            user.email = auth[:info][:email]
            user.password = SecureRandom.hex
        end
    end

    private

end