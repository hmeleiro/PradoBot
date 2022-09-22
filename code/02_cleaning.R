library(tidyverse)

df <- read_csv("data/data.csv")

df$fecha[df$id == "O000080"] <- "1570 - 1590"

df$tweet <- paste0(df$titulo, " - ", df$Autor, " (", df$fecha, ")", " ")
df$tweetsize <- if_else(nchar(df$tweet) <= 280-23, T, F)

table(df$tweetsize)

df$tweet <- paste(df$tweet, df$url_ficha)

write_csv(df, "data/data.csv")
