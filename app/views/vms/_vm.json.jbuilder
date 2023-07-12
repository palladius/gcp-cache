json.extract! vm, :id, :name, :description, :internal_notes, :machine_type, :internal_ip, :external_ip, :self_link, :zone, :disk1_size_gb, :disk1_name, :status, :is_preemptible, :project_id, :created_at, :updated_at
json.url vm_url(vm, format: :json)
