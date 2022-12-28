
SHELL := /bin/bash

run:
	#https://stackoverflow.com/questions/72448485/the-asset-application-js-is-not-present-in-the-asset-pipeline-in-rails-7
	rake assets:precompile || yarn build
	rails s

migrate:
	rake db:migrate db:seed

db-drop-and-then-regenerate-YES-IM-SURE: delete-database-YES-IM-SURE migrate
delete-database-YES-IM-SURE:
	rake db:drop 
run-migrations-once-hopefully:
	# repeat with --force if you make a mistake
	rails generate scaffold project project_id:string project_number:string organization_id:string parent_id:string billing_account_id:string description:text \
		lifecycle_state:string project_name:string gcp__creation_time:timestamp # --force
	#git restore app/helpers/projects_helper.rb
 	#git restore app/models/
	rails generate scaffold folder name:string folder_id:string is_org:boolean parent_id:string description:text domain:string  directory_customer_id:string lifecycle_state:string gcp_creation_time:datetime

db-show:
	echo Project.count | rails c
	echo Project.first.to_s | rails c
	echo Folder.count | rails c

watch-db:
	watch make db-show

gcloud-generate-info:
	gcloud organizations list --format json | tee db/fixtures/gcloud/organizations.json