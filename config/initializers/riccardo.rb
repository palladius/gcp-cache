
Dotenv.load('.envrc') or die "Follow instructions and create .envrc file.."
 

CODE_URL = ENV.fetch 'CODE_URL', 'https://cloud.google.com/'