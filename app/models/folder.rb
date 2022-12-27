class Folder < ApplicationRecord
    extend ActsAsTree::TreeView
    acts_as_tree order: "name"

    # https://guides.rubyonrails.org/active_record_validations.html
    validates :folder_id, uniqueness: true, presence: true
    validates :name,  presence: true

    # not self.emoji 
    def emoji
        is_org ? ORG_ICON : FOLDER_ICON
    end

    def to_s
        self.emoji + " " + self.name
    end

    def self.class_emoji 
        FOLDER_ICON
    end
end
