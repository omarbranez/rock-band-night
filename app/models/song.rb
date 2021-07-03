class Song < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    belongs_to :artist
    belongs_to :genre
    has_many :user_songs
    has_many :users, through: :user_songs

    def full_title
        "#{self.article}" + " " + "#{self.name}"
    end

    def artist_name
        self.try(:artist).try(:name)
    end
end