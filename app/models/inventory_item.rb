class InventoryItem < ApplicationRecord
    serialize :serialized_ancestors

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

    def to_s
        "#{simplified_type} :#{INVENTORY_ITEM_ICON} : #{simplified_name}"
    end
end
