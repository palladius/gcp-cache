#!/bin/bash

_fatal() {
    echo "ERROR $@"
    exit 41
}
source .envrc ||
    _fatal 'Not .envrc to slurp. Exiting.'



echo "Finding projects for org: $ORGANIZATION_ID"

gcloud projects list --filter=parent.id:"$ORGANIZATION_ID" --format json |
    tee db/fixtures/gcloud/projects-$(date +%Y%m%d-%H%M%S).json

# Note this is NOT exhaustive since it only shows the folder children of orgnode.
gcloud resource-manager folders list --organization="$ORGANIZATION_ID" --format=json |
    tee db/fixtures/gcloud/folders-of-$ORGANIZATION_ID-$(date +%Y%m%d-%H%M%S).json

gcloud organizations list --format json | tee db/fixtures/gcloud/organizations.json

# gcloud get
#inventory-per-project
# gcloud asset list \
#     --project=PROJECT_ID \
#     --asset-types=ASSET_TYPE_1,ASSET_TYPE_2,... \
#     --content-type=resource \
#     --snapshot-time="SNAPSHOT_TIME"
