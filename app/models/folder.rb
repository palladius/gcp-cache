class Folder < ApplicationRecord
    # https://guides.rubyonrails.org/active_record_validations.html
    validates :folder_id, uniqueness: true, presence: true
    validates :name,  presence: true

    def emoji 
        is_org ? '️🗂️' : '📂'
    end
    def to_s
        self.emoji + " " + self.name
    end

    # def self.emoji 
    #     # 📂 Folders
    #     # 🗂️ Orgs
    #     '📂'       
    # end
end
