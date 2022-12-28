#!/bin/bash

_fatal() {
    echo "ERROR $@"
    exit 41
}
source .envrc ||
    _fatal 'Not .envrc to slurp. Exiting.'


 #--order-by='createTime'
 
echo "This script exports ALL asset inventory resources for a single project, in our case: '$PROJECT_NUMBER'"
gcloud asset search-all-resources \
  --scope="projects/$PROJECT_NUMBER" \
  --format json | 
    tee db/fixtures/gcloud/inventory-per-project-$(date +%Y%m%d-%H%M%S).json
