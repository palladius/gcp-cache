json.extract! service, :id, :name, :gcp_tag, :priority, :expected_status, :devconsole_url, :inventory_item_id, :description, :internal_notes, :created_at, :updated_at
json.url service_url(service, format: :json)
