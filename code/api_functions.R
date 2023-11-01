api_key <- Sys.getenv("PRADOBOT_KEY")
api_secret_key <- Sys.getenv("PRADOBOT_SECRET")
api_access_token <- Sys.getenv("PRADOBOT_ACCESS_TOKEN")
api_access_secret <- Sys.getenv("PRADOBOT_ACCESS_SECRET")

post_tweet <- function(tweet, media = NULL) {
  require(httr)
  require(dplyr)
  baseurl = "https://api.twitter.com"
  endpoint <- "/2/tweets"
  app <- oauth_app("pradobot", key = api_key, secret = api_secret_key)
  
  url <- httr::modify_url(baseurl, path = endpoint)
  info <- httr::oauth_signature(url, method = "POST", app = app, 
                                token = api_access_token, token_secret = api_access_secret)
  header_oauth <- httr::oauth_header(info)
  
  body <- list(
    "text" = tweet,
    "media" = list("media_ids" = list(media$media_id_string))
  )
  resp <- httr::POST(url, header_oauth, body = body, encode = "json")
  resp %>% 
    httr::content(as = "parsed")
  
}

upload_media <- function(file) {
  require(httr)
  require(dplyr)
  baseurl <- "https://upload.twitter.com"
  endpoint <- "/1.1/media/upload.json?media_category=tweet_image"
  
  app <- oauth_app("pradobot", key = api_key, secret = api_secret_key)
  
  url <- modify_url(baseurl, path = endpoint)
  info <- oauth_signature(
    url, method = "POST", app = app, 
    token = api_access_token,
    token_secret = api_access_secret
  )
  header_oauth <- oauth_header(info)
  
  body <- list(
    media = upload_file(file),
    media_category = "tweet_image"
  )
  resp <- POST(url, header_oauth, body = body, encode = "multipart")
  
  content(resp, as = "parsed")
  
}

add_metadata <- function(media_id, alt_text) {
  require(httr)
  require(dplyr)
  baseurl <- "https://upload.twitter.com"
  endpoint <- "/1.1/media/metadata/create.json"
  
  app <- oauth_app("pradobot", key = api_key, secret = api_secret_key)
  
  url <- modify_url(baseurl, path = endpoint)
  info <- oauth_signature(
    url, method = "POST", app = app, 
    token = api_access_token,
    token_secret = api_access_secret
  )
  header_oauth <- oauth_header(info)
  
  body <- list(
    media_id = media_id,
    alt_text = list("text" = alt_text)
  )
  
  POST(url, header_oauth, body = body, encode = "json")
}
  





  
