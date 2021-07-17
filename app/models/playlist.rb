class Playlist < ActiveRecord::Base
    belongs_to :host
    has_many :songs, through: :user_songs
end