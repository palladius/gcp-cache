class CreateInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_items do |t|
      t.text :serialized_ancestors
      t.text :description
      t.string :asset_type
      t.string :name
      t.timestamp :gcp_update_time
      t.string :resource_location
      t.string :resource_discovery_name
      t.string :resource_parent
      t.string :project

      t.timestamps
    end
  end
end
