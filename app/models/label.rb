class Label < ApplicationRecord
    #validates :gcp_key, uniqueness: true, presence: true
    validates :gcp_k, uniqueness: { scope: [:gcp_val] }


    def to_s 
        "[ICON] #{gcp_k} -> #{gcp_val}"
    end
end
