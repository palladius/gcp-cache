class Project < ApplicationRecord

    validates :project_id,     uniqueness: true, presence: true
    validates :project_number, uniqueness: true

    # alias :baid, :billing_accoung_id
    def baid 
        @billing_accoung_id || 'XXXXXX-XXXXXX-XXXXXX'
    end

    def setParent(parent_folder)
        raise "Unknown Parent! #{parent_folder.class}" unless  parent_folder.is_a?(Folder)
        self.parent_id = parent_folder.folder_id 
        self.organization_id = parent_folder.folder_id # where recurively finding for parent. Wait for acts_as_tree to find it :) 
        self.description = "[debug] Setting parent to #{parent_folder}" 
        puts "* Is this valid? #{self.valid?}"
        self.save!
        # TODO: also set Organization_id
        #self.organization_id = parent_folder.id where recurively finding for parent. Wait for acts_as_tree to find it :) 
    end

    def to_s(verbose=true)
        return self.project_id unless verbose
        "#{project_id} (#{project_number}) # #{baid}"
    end


    def self.class_emoji 
        PROJECT_ICON
    end
end
