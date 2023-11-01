setwd("/home/hmeleiro/PradoBot/") 
tryCatch({
  
  suppressMessages({
    suppressWarnings({
      source("code/api_functions.R")
      
      df <- read.csv("data/data.csv", stringsAsFactors = F)
      df <- df[sample(1:nrow(df), nrow(df), replace = F),]
      df <- df[df$tuiteadoya == F,]
      
      tweet <- df$tweet[1]
      path <- paste0( getwd(), "/", df$path[1])
      print(path)
     
      alt_text <- paste0("'",df$titulo[1],"'", " de ", df$Autor[1])
      
      media <- upload_media(path)
      add_metadata(media$media_id_string, alt_text)
      
      post_tweet(tweet, media)

      df$tuiteadoya[1] <- T
      
      write.csv(df, "data/data.csv", row.names = F)
    })
  })
}, 
error = function(e) {
  print(e$message)
})

