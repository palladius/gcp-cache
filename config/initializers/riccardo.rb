
Dotenv.load('.envrc') or die "Follow instructions and create .envrc file.."
 

CODE_URL = ENV.fetch 'CODE_URL', 'https://cloud.google.com/'
APP_NAME = ENV.fetch 'APP_NAME', '{ Missing AppName. fix the .envrc ! }'
APP_DESCRIPTION = ENV.fetch 'APP_DESCRIPTION', '{ Missing APP_DESCRIPTION. fix the .envrc ! }'

PROJECT_ICON = ENV.fetch 'PROJECT_ICON', '🍕'
FOLDER_ICON = ENV.fetch 'FOLDER_ICON', '?'
ORG_ICON = ENV.fetch 'ORG_ICON', '?'
LABEL_ICON = ENV.fetch 'LABEL_ICON', '🏷️'
INVENTORY_ITEM_ICON = ENV.fetch 'INVENTORY_ITEM_ICON', '🧺️'

UninterestingInventoryTypes =  [
    "compute.googleapis.com/Firewall",
    "compute.googleapis.com/Network",
    "compute.googleapis.com/Route",
    "compute.googleapis.com/Subnetwork",
]
    
# config.filter_parameters += ["credit_card.code"]
Rails.application.config.filter_parameters -= ["gcp_key"]