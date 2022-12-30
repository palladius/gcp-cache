
SHELL := /bin/bash

run:
	#https://stackoverflow.com/questions/72448485/the-asset-application-js-is-not-present-in-the-asset-pipeline-in-rails-7
	rake assets:precompile || yarn build
	rails s

migrate:
	rake db:migrate db:seed 
	rake db:fixtures:load FIXTURES=labels


db-drop-and-then-regenerate-YES-IM-SURE: delete-database-YES-IM-SURE migrate
delete-database-YES-IM-SURE:
	rake db:drop 
run-migrations-once-hopefully:
	# repeat with --force if you make a mistake
	rails generate scaffold project project_id:string project_number:string organization_id:string parent_id:string billing_account_id:string description:text \
		lifecycle_state:string project_name:string gcp__creation_time:timestamp --force
	rails generate scaffold folder name:string folder_id:string is_org:boolean parent_id:string description:text domain:string  directory_customer_id:string lifecycle_state:string gcp_creation_time:datetime frog_type:string --force
	rails generate scaffold label gcp_key:string gcp_value:string
	rails g scaffold inventory_item serialized_ancestors:text description:text asset_type:string name:string gcp_update_time:timestamp resource_location:string resource_discovery_name:string resource_parent:string project:string
	git restore app/helpers app/models/
	git restore app/views/inventory_items/index.html.erb
	echo Now take a quick look at VIEWS..

db-show:
	echo Project.count | rails c
	echo Project.first.to_s | rails c
	echo Folder.count | rails c

watch-db:
	watch make db-show

gcloud-generate-info:
	./gcloud-generate-info.sh

populate-asset-inventory-from-bq:
	./populate-projects-and-folders-from-bigquery.sh

cleanup-empty-json-files:
	find db/fixtures/ -name \*.json -size 0 -print0 | xargs -0 rm