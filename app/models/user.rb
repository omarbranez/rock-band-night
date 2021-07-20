class User < ActiveRecord::Base
    has_many :user_songs
    has_many :songs, through: :user_songs
    validates_presence_of :username
    validates_uniqueness_of :username
    # validates :email, :unique => true
    has_secure_password


    def last_song_added
        Song.find(self.user_songs.last.song_id)
    end

    def user_is_admin
        current_user == User.find(1)
    end
    
    private
    
    def self.create_by_omniauth(auth)
        self.find_or_create_by(username: auth[:info][:name]) do |user|
            user.email = auth[:info][:email]
            user.password = SecureRandom.hex
        end
    end

end