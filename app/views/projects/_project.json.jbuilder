json.extract! project, :id, :project_id, :project_number, :organization_id, :parent_id, :billing_account_id, :description, :created_at, :updated_at
json.url project_url(project, format: :json)
