class Label < ApplicationRecord
    #validates :gcp_key, uniqueness: true, presence: true
    validates :gcp_k, uniqueness: { scope: [:gcp_val] }
    
    belongs_to :labellable, polymorphic: true
    

    def labellable_shortname
        return 'nada' if labellable.nil?
        return labellable.to_s(false)
    end

    def to_s 
        "🏷️#{gcp_k} -> #{gcp_val} @[#{labellable_shortname}]"
    end

    def self.emoji
        "🏷️"
    end
end
