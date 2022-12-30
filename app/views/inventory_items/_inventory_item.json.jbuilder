json.extract! inventory_item, :id, :serialized_ancestors, :description, :asset_type, :name, :gcp_update_time, :resource_location, :resource_discovery_name, :resource_parent, :project, :created_at, :updated_at
json.url inventory_item_url(inventory_item, format: :json)
