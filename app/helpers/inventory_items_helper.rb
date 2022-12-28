module InventoryItemsHelper

    def render_inventory_item(inventory_item)
        link_to "#{INVENTORY_ITEM_ICON} #{inventory_item}", inventory_item
    end
end
