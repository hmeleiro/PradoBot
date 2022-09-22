library(tidyverse)
library(RSelenium)
library(magrittr)
library(httr)
library(rvest)
library(dplyr)

url <- "https://www.museodelprado.es/coleccion/obras-de-arte?ecidoc:p55_has_current_location_exposed=expuesto@es"

remDrv <- RSelenium::rsDriver(verbose = T, browser = "firefox", port = 4574L)
rDr <- remDrv$client

rDr$navigate(url)

source <- rDr$getPageSource()[[1]]
NumResults <- source %>% read_html() %>% html_node("#panNumResultados strong") %>% html_text() %>% as.numeric()

body <- rDr$findElement("css", "body")

body$sendKeysToElement(list(key = "end"))
Sys.sleep(60*5)

source <- rDr$getPageSource()[[1]]

obras <- source %>% read_html() %>% html_nodes("#panResultados dt a") %>% html_attr(name = "href")
titulos <- source %>% read_html() %>% html_nodes("#panResultados dt a") %>% html_text()

l <- length(unique(obras))

if (l < NumResults) {
  Sys.sleep(60*5)

  source <- rDr$getPageSource()[[1]]

  obras <- source %>% read_html() %>% html_nodes("#panResultados dt a") %>% html_attr(name = "href")
  titulos <- source %>% read_html() %>% html_nodes("#panResultados dt a") %>% html_text()

  df <- tibble(titulo = titulos, url = obras)
  df <- df[!duplicated(df$url),]

} else {

  df <- tibble(titulo = titulos, url = obras)
  df <- df[!duplicated(df$url),]
}

write_csv(df, "data/listado.csv")

rDr$quit()
remDrv$server$stop()


df <- read_csv("data/listado.csv")

line <- tibble("id", "Autor", "titulo", "fecha", "Técnica", "soporte","dimension", "procedencia", "url_ficha" ,"url", "path")
write_csv(line, "data/data.csv", append = F, col_names = F)

# Inicio del bucle de las obras

for (i in 111:nrow(df)) {
  
  pg <- read_html(df$url[i])
  
  
  field <- pg %>% html_nodes(".ficha-tecnica dt") %>% html_text() %>% str_remove_all("\n") %>% str_trim() %>% str_squish()
  value <- pg %>% html_nodes(".ficha-tecnica dd") %>% html_text() %>% str_remove_all("\n") %>% str_trim() %>% str_squish()
  
  ficha <- tibble(field, value) %>% pivot_wider(names_from = "field", values_from = "value")
  
  try(ficha$Serie <- NULL)
  
  
  all_meta_attrs <- unique(unlist(lapply(lapply(pg %>% html_nodes("meta"), html_attrs), names)))
  
  dat <- data.frame(lapply(all_meta_attrs, function(x) {
    pg %>% html_nodes("meta") %>% html_attr(x)
  }))
  
  
  colnames(dat) <- all_meta_attrs
  
  img <- as.character(dat$content[dat$name == "og:image"])
  path <- paste0("data/images/", 
                 str_replace_all(ficha$`Número de catálogo`, "/", "-"), 
                 ".jpg")
  
  
  
  ficha$url_ficha <- df$url[i]
  ficha$url <- img
  ficha$path <- path
  
  write_csv(ficha, "data/data.csv", col_names = F, append = T)
  
  
  download.file(img, path, mode = 'wb')
  
  print(i)
  
}