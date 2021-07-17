class Playlist < ActiveRecord::Base
    belongs_to :host
    belongs_to :guest
    has_many, 
    has_many :songs, through: :user_songs
    validates_presence_of :host_id
    validates_presence_of :guest_id
    validates_presence_of :position

    def 
end