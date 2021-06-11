class User < ActiveRecord::Base
    has_many :user_songs
    has_many :songs, through: :user_songs
    # user will have artists as well, for the sake of the booklet
    # will split users into HOSTS and GUESTS
    # HOST can read, update, destroy (after song is played)
    # GUEST can read, create (no skipping other people's songs!) 
end