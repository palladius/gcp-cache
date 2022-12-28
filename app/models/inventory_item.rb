class InventoryItem < ApplicationRecord
    serialize :serialized_ancestors



    def ancestors
        serialized_ancestors rescue []
    end

    def simplified_type
        asset_type.split("/").last
    end

    def to_s
        "#{simplified_type} :#{INVENTORY_ITEM_ICON} : #{name}"
    end
end
