class Artist < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged
    has_many :songs

    validates_presence_of :name

    def full_name
        if self.article != ""
            "#{self.article}" + " " + "#{self.name}"
        else
            self.name
        end
    end

    # def check_name_for_article
    #     if self.name[0..2] == "The"
    #         self.article = "The"
    #         self.name = self.name.delete_prefix("The ")
    #     elsif self.name[0..1] == "A "
    #         self.article = "A"
    #         self.name = self.name.delete_prefix("A ")
    #     else
    #         self.article = ""
    #     end
    # end
end