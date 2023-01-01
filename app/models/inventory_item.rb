class InventoryItem < ApplicationRecord
    serialize :serialized_ancestors

    validates :name, uniqueness: { scope: [:asset_type] }
    validates_uniqueness_of :resource_discovery_name


    include AssetInventoryParser

    def ancestors
        serialized_ancestors rescue []
    end

    def simplified_type
        #asset_type.split("/").last
        asset_type.gsub('.googleapis.com','')
    end
    def simplified_name
        name.split("/").last
    end

    def organization_id
        ancestors.select{|x| x=~ /^organizations/ }[0].split('/').second rescue nil
    end
    def organization
        Folder.find_by_folder_id(organization_id) # rescue nil
    end

    def to_s(verbose=true)
        verbose ? 
            "#{simplified_type} :#{INVENTORY_ITEM_ICON} : #{simplified_name}" : 
            "#{simplified_name}" 
    end
    def self.class_emoji 
        self.emoji 
    end
    def self.emoji 
        '🧺️'
    end
    
end
