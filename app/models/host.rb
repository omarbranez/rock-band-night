class Host < ActiveRecord::Base
    has_many :guests
    has_many :songs, through: :user_songs
    has_one :history

end