
SHELL := /bin/bash

run:
	rails s

migrate:
	rake db:migrate db:seed

run-migrations-once-hopefully:
	# repeat with --force if you make a mistake
	rails generate scaffold project project_id:string project_number:string organization_id:string parent_id:string billing_account_id:string description:text
	rails generate scaffold folder name:string folder_id:string is_org:boolean parent_id:string description:text

db-show:
	echo Project.count | rails c
	echo Project.first.to_s | rails c
	echo Folder.count | rails c

watch-db:
	watch make db-show
