#!/bin/bash

_fatal() {
    echo "ERROR $@"
    exit 41
}
source .envrc ||
    _fatal 'Not .envrc to slurp. Exiting.'


#echo "ASSET_INVENTORY_TABLES: $ASSET_INVENTORY_TABLES"

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

LIMIT 10000
END_OF_BQ_TEXT

# I tried CSV but it doesnt work :/ too many nested things i would have to 
# one for all, ancestors which for most resources returns TWO objects.
cat .tmp |bq query  --use_legacy_sql=false --format json | tee ./db/fixtures/bq-exports/assets-export.$(date +%Y%m%d-%H%M%S).json
 