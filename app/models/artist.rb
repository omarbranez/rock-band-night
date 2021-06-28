class Artist < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged
    has_many :songs

    def full_name
        "#{self.article}" + " " + "#{self.name}"
    end


    # def to_param
    #     return nil unless persisted?
    #     [id, slug].join('-') # combine the id and the slug
    # end
end