library(rtweet)

## store api keys
api_key <- Sys.getenv('PRADOBOT_API_KEY')
api_secret_key <- Sys.getenv('PRADOBOT_API_SECRET')
access_token <- Sys.getenv('PRADOBOT_CLIENT_ID')
access_token_secret <- Sys.getenv('PRADOBOT_SECRET')

auth <- rtweet_bot(api_key, api_secret_key, access_token, access_token_secret)
