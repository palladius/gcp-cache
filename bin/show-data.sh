#!/bin/bash

echo '👀 Showing data in your local folder..'

find db/fixtures/ -name '*.json' | while read JSON_FILE ; do
    echo -e "$(jq length "$JSON_FILE") \t $JSON_FILE"
done

echo
echo '👀 Lets now ask Rails DB:'

# for ENTITY in Project Folder ; do
#     echo -en "# ${ENTITY}s: " ; echo "$ENTITY.count" | rails c 2>/dev/null
# done

# 🏠 Home 🍕 Projects 📂 Folders 🗂️ Orgs 🏷️️ Labels 🧺️ Inventory Items 📈 Inventory Stats

echo '"🍕 #{Project.count} Projects 📂 #{Folder.count_folders} Folders 🗂️  #{Folder.count_orgs} Orgs #{BillingAccount.emoji} #{BillingAccount.count} BAIDs"' | rails c 2>/dev/null

echo '👀 DONE'
