#!/bin/bash

# create an Org viewer to 'sbirch' (italian for: take a look) the 
# code inspired by: https://github.com/JupiterOne/graph-google-cloud/blob/main/docs/development.md

direnv allow || 
    . .envrc || 
        exit 42

# direnv allow 

SVC_ACCT_NAME="org-config-sbircher-sa"
#PROJECT_ID=""

echo "+ PROJECT_ID=$PROJECT_ID"

set -e 

gcloud config set core/project "$PROJECT_ID"

# checks if exists - if no, it creates it
gcloud iam service-accounts describe  org-config-sbircher-sa@$PROJECT_ID.iam.gserviceaccount.com ||
#proceed_if_error_matches "Service account $SVC_ACCT_NAME already exists within project" \
    gcloud iam service-accounts create "$SVC_ACCT_NAME" \
        --description "Organization Configuration 👀 Sbircher"

for ROLE in iam.securityReviewer iam.organizationRoleViewer bigquery.metadataViewer ; do 
    # can repeat multiple times..
    gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member serviceAccount:"$SVC_ACCT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
        --role "roles/$ROLE" --condition='None'
done

if [ -f service-account-key.json ]; then 
    echo '🔑 No need to create a Key'
else 
    echo '🔑 Creating and downloading a key - SAVE IT SOMEHWERE SAFE!'
    set -x 
    gcloud iam service-accounts keys create service-account-key.json \
    --iam-account j1-gc-integration-dev-sa@PROJECT_ID.iam.gserviceaccount.com \
    --key-file-type "json"

fi
echo '👀 All good.'