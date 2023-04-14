#!/bin/bash


_fatal() {
    echo "ERROR $@"
    exit 41
}
. .envrc ||
    _fatal 'Not .envrc to slurp. Exiting.'

# remove seconds so i dont have A LOT of them..
TODAY_DATE=$(date +%Y%m%d-%H%M)
MAX_ROWS='15000'

set -e

direnv allow .

echo "🔭 Here we assume you've already added your Asset Inventory resources to BQ and you configured .envrc to point to the right tables: $ASSET_INVENTORY_TABLES."
echo "🔭 ASSET_INVENTORY_TABLES: $ASSET_INVENTORY_TABLES"

cat <<END_OF_BQ_TEXT >.tmp
-------------- -------------- -------------- -------------- --------------
-- Select all CRM projects, folders, and orgs form Riccardo account on BigQuery :)
-------------- -------------- -------------- -------------- --------------
SELECT
   name,
  asset_type,
  ancestors,
  update_time,
  resource
--  asset_type,
--  COUNT(*) as carlessian_asset_cardinality
FROM \`${ASSET_INVENTORY_TABLES}*\`
WHERE asset_type like 'cloudresourcemanager.googleapis.com/%'
-- GROUP BY 1

LIMIT 100000
END_OF_BQ_TEXT

# I tried CSV but it doesnt work :/ too many nested things i would have to
# one for all, ancestors which for most resources returns TWO objects.
# not using timestamp and just YYYYMMDD as its likely not to change much so easier on the rake db:seed part. $(date +%Y%m%d-%H%M%S).json
cat .tmp |bq query  --use_legacy_sql=false --format json --max_rows "$MAX_ROWS" > ./db/fixtures/bq-exports/assets-export.$TODAY_DATE.json

echo "👍 BQ JSON written: $?"

echo -en "👍 JSON length:"
    jq length ./db/fixtures/bq-exports/assets-export.$TODAY_DATE.json


