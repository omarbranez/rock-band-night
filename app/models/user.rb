class User < ActiveRecord::Base
    has_many :user_songs
    has_many :songs, through: :user_songs
    validates_presence_of :username, on: :create
    validates_uniqueness_of :username, on: :create
    # validates_format_of :username, with: /(?=.*([a-z]|[A-Z]))/, on: :update
    # before_validation :generate_fake_email
    validates_uniqueness_of :email, on: :create
    after_create :remove_spaces_from_username
    has_secure_password


    def last_song_added
        Song.find(self.user_songs.last.song_id)
    end

    def user_is_admin
        current_user == User.find(1)
    end
    
    def remove_spaces_from_username
        if self.username.match(/\s/)
            self.update(username: self.username.gsub(/\s/, ""))
        end
    end

    private
    
    def self.create_by_omniauth(auth)
        self.find_or_create_by(email: auth[:info][:email]) do |user|
            if user.new_record?
                user.username = auth[:info][:name]
            end
            user.password = SecureRandom.hex
        end
    end

end