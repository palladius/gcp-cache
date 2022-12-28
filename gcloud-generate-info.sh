#!/bin/bash

_fatal() {
    echo "ERROR $@"
    exit 41
}
source .envrc ||
    _fatal 'Not .envrc to slurp. Exiting.'



echo "Finding projects for org: $ORGANIZATION_ID"
gcloud projects list --filter=parent.id:"$ORGANIZATION_ID" --format json | tee db/fixtures/gcloud/projects.json

gcloud organizations list --format json | tee db/fixtures/gcloud/organizations.json
