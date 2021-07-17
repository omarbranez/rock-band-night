class Host < ActiveRecord::Base
    belongs_to :user
    has_many :guests
    has_one :history
    has_one :playlist
end