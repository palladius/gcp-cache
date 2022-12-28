class Label < ApplicationRecord
    #validates :gcp_key, uniqueness: true, presence: true
    validates :gcp_key, uniqueness: { scope: [:gcp_value] }

end
