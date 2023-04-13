#!/bin/bash

echo 'Running generic commands which provide meat to my fire: lst of projects orgs and so on..'

gcloud projects list --format json | tee  db/fixtures/gcloud/gcloud-projects-list-$(data).json

echo "👍 Done: $?"
