class Artist < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged
    has_many :songs

    before_create :check_name_for_article

    def full_name
        if self.article != ""
            "#{self.article}" + " " + "#{self.name}"
        else
            self.name
        end
    end

    def check_name_for_article # will refactor as abstract class, since song has the same
        if self.name[0..2] == "The"
            self.article = "The"
        else
            if self.name[0..1] == "A "
                self.article = "A"
            end
        end
    end
end