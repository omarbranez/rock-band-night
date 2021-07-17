class Guest < ActiveRecord::Base
    belongs_to :host
    validates_presence_and_uniqueness_of :name
end