
Dotenv.load('.envrc') or die "Follow instructions and create .envrc file.."
 

CODE_URL = ENV.fetch 'CODE_URL', 'https://cloud.google.com/'
APP_NAME = ENV.fetch 'APP_NAME', '{ Missing AppName. fix the .envrc ! }'
APP_DESCRIPTION = ENV.fetch 'APP_DESCRIPTION', '{ Missing APP_DESCRIPTION. fix the .envrc ! }'

