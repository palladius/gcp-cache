#!/bin/bash

_fatal() {
    echo "ERROR $@"
    exit 41
}

source .envrc ||
    _fatal 'Not .envrc to slurp. Exiting.'

# https://stackoverflow.com/questions/3224878/what-is-the-purpose-of-the-colon-gnu-bash-builtin
# : >afile
 #--order-by='createTime'

# I'll lazily assign to samely named var the .envrc version unless $1 exists
# then $1 will be prioritary
PROJECT_NUMBER=${1:-$PROJECT_NUMBER}


echo "⌛ This script exports ALL asset inventory resources for a single project, in our case: '$PROJECT_NUMBER'. If it works, it'll take a while.."

time gcloud asset search-all-resources \
  --scope="projects/$PROJECT_NUMBER" \
  --format json > db/fixtures/gcloud/inventory-for-$PROJECT_NUMBER-project-at-$(date +%Y%m%d-%H%M%S).json

echo '👍 OK Finished this ENORMOUS calculus. Took some time.'
