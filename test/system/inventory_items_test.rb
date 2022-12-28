require "application_system_test_case"

class InventoryItemsTest < ApplicationSystemTestCase
  setup do
    @inventory_item = inventory_items(:one)
  end

  test "visiting the index" do
    visit inventory_items_url
    assert_selector "h1", text: "Inventory items"
  end

  test "should create inventory item" do
    visit inventory_items_url
    click_on "New inventory item"

    fill_in "Asset type", with: @inventory_item.asset_type
    fill_in "Description", with: @inventory_item.description
    fill_in "Gcp update time", with: @inventory_item.gcp_update_time
    fill_in "Name", with: @inventory_item.name
    fill_in "Resource discovery name", with: @inventory_item.resource_discovery_name
    fill_in "Resource location", with: @inventory_item.resource_location
    fill_in "Resource parent", with: @inventory_item.resource_parent
    fill_in "Serialized ancestors", with: @inventory_item.serialized_ancestors
    click_on "Create Inventory item"

    assert_text "Inventory item was successfully created"
    click_on "Back"
  end

  test "should update Inventory item" do
    visit inventory_item_url(@inventory_item)
    click_on "Edit this inventory item", match: :first

    fill_in "Asset type", with: @inventory_item.asset_type
    fill_in "Description", with: @inventory_item.description
    fill_in "Gcp update time", with: @inventory_item.gcp_update_time
    fill_in "Name", with: @inventory_item.name
    fill_in "Resource discovery name", with: @inventory_item.resource_discovery_name
    fill_in "Resource location", with: @inventory_item.resource_location
    fill_in "Resource parent", with: @inventory_item.resource_parent
    fill_in "Serialized ancestors", with: @inventory_item.serialized_ancestors
    click_on "Update Inventory item"

    assert_text "Inventory item was successfully updated"
    click_on "Back"
  end

  test "should destroy Inventory item" do
    visit inventory_item_url(@inventory_item)
    click_on "Destroy this inventory item", match: :first

    assert_text "Inventory item was successfully destroyed"
  end
end
