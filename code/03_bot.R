library(rtweet)

setwd("~/projects/PradoBot/")

tryCatch({
  
  suppressMessages({
    suppressWarnings({
      
      source("code/bot_auth.R")
      
      df <- read.csv("data/data.csv", stringsAsFactors = F)
      
      df = df[sample(1:nrow(df), nrow(df), replace = F),]
      
      df <- df[df$tuiteadoya == F,]
      
      if(nrow(df) == 0) {
        df <- read.csv("data/data.csv", stringsAsFactors = F)
        df$tuiteadoya <- T
      }
      
      tweet <- df$tweet[1]
      path <- paste0( getwd(), "/", df$path[1])

      post_tweet(
        status = tweet,
        media = path,
        media_alt_text = paste0("'",df$titulo[1],"'", " de ", df$Autor[1]), token = auth
      )
      
      df$tuiteadoya[1] <- T
      
      write.csv(df, "data/data.csv", row.names = F)
    })
  })
}, 
error = function(e) {
  print(e$message)
})

