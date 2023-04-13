
SHELL := /bin/bash

show-data:
	bin/show-data.sh

run:
	#https://stackoverflow.com/questions/72448485/the-asset-application-js-is-not-present-in-the-asset-pipeline-in-rails-7
	rake assets:precompile || yarn build
	rails s

#rake db:fixtures:load FIXTURES=labels # this DESTROYS! dont call it!!!
migrate:
	rake db:migrate db:seed MAX_INDEX=100000

mini-migrate:
	rake db:migrate db:seed MAX_INDEX=10


db-drop-and-then-regenerate-YES-IM-SURE: delete-database-YES-IM-SURE migrate
delete-database-YES-IM-SURE:
	rake db:drop
run-migrations-once-hopefully:
	# repeat with --force if you make a mistake
	rails generate scaffold project project_id:string project_number:string organization_id:string parent_id:string billing_account_id:string description:text \
		lifecycle_state:string project_name:string gcp__creation_time:timestamp --force
	rails generate scaffold folder name:string folder_id:string is_org:boolean parent_id:string description:text domain:string  directory_customer_id:string lifecycle_state:string gcp_creation_time:datetime frog_type:string --force
	rails generate scaffold label gcp_k:string gcp_val:string labellable_id:integer labellable_type:string
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
	bin/gcloud-generate-info.sh

populate-asset-inventory-from-bq:
	bin/populate-projects-and-folders-from-bigquery.sh

#cleanup-empty-json-files:#
#	find db/fixtures/ -name \*.json -size 0 -print0 | xargs -0 rm

seed-from-riccardo-other-script:
	# this is available if you download this: 
	ORG_FOLDER_PROJECTS_GRAPH_FOLDER="~/git/org-folder-projects-graph/" rake db:seed

clean:
	bin/cleanup-empty-files.sh

install-debian-ubuntu:
	sudo apt-get install sqlite3 libsqlite3-dev 
	# If you have no yarn: https://stackoverflow.com/questions/46013544/yarn-install-command-error-no-such-file-or-directory-install
	#sudo apt remove cmdtest
	#sudo apt remove yarn
	#Install yarn globally using npm
	#sudo npm install -g yarn
	# for PostgreS
	sudo apt install postgresql postgresql-contrib libpq-dev

run-prod:
	bin/rails credentials:edit
	RAILS_ENV=production rails s -p 8080