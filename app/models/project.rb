class Project < ApplicationRecord


    # alias :baid, :billing_accoung_id
    def baid 
        @billing_accoung_id || 'XXXXXX-XXXXXX-XXXXXX'
    end

    def to_s(verbose=true)
        return self.project_id unless verbose
        "#{project_id} (#{project_number}) # #{baid}"
    end
end
