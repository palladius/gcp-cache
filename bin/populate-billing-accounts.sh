#!/bin/bash

ACCOUNT=$(gcloud config get account)

set -e

mkdir -p db/fixtures/gcloud/baids.d/
gcloud alpha billing accounts list --format json | tee "db/fixtures/gcloud/baids.d/baids-for--$ACCOUNT.json"
