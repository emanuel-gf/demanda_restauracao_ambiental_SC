library(sp)
library(tidyverse)
library(sf)
library(dplyr)
library(lwgeom)
library(ggplot2)
library(geobr)

dados_brutos <- st_read(
  'D:/Desktop/bella_bella/APP/filtragem_tentativa/dados_filtrados.shp'
)

groupby_codimovel <- st_read(
  'D:/Desktop/bella_bella/APP/filtragem_tentativa/groupby_codimovel.shp'
)

municipio_sf <- geobr::read_municipality(
  code_muni = "SC",
  year = 2022
)

## Create a new column municipio
# Function to clean municipality names
clean_municipality_names <- function(names) {
  # Convert to ASCII to remove special characters
  cleaned <- iconv(names, to = "ASCII//TRANSLIT")
  # Remove any remaining special characters (apostrophes, etc.)
  cleaned <- gsub("[^[:alnum:] ]", "", cleaned)
  # Replace spaces with underscores
  cleaned <- gsub(" ", "_", cleaned)
  # Convert to lowercase (optional - remove if you want to preserve case)
  cleaned <- tolower(cleaned)
  return(cleaned)
}

## Create a new column
municipio_sf$municipio_sem_acento <- clean_municipality_names(municipio_sf$name_muni)
dados_brutos$municipio_sem_acento <- clean_municipality_names(dados_brutos$municip)
groupby_codimovel$municipio_sem_acento <- clean_municipality_names(groupby_codimovel$municip)

## ----------------------------------------
