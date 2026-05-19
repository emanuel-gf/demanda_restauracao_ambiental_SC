library(sp)
library(tidyverse)
library(sf)
library(dplyr)
library(lwgeom)
library(here)

## Disclaimer
## Os dados provenientes de como APP_1, APP_2 e APP_3 foram diretamente
## baixados do banco de dados do CAR.
## O dado nomeado como car_cadastro foi baixado diretamente do CAR.
## O dado nomeado como centroid, refere-se ao dado do car_cadastro 
## porem extraido o centroide referente ao poligono. - Feito no Arcgis. 


# Pre Process APP data
## The goal is  to filter all the APP data regarding its attribute $non_tema.
## The  geometry is deleted due to computational costs but it is being concatened back later on a join with CAR`s table. 
## Only the centroid of the CAR  table will become the geometry  for APP.
## App has several polygons with geometries issues in respect of Well-Known Text, thus, this choice was a way to tackle these inconsistencies. `


## Folder with Paths 
# ---------------------------
# PATHS
app_dir <- here("DATA", "SC/APP")
car_dir <- here("DATA", "SC/AREA_IMOVEL")
centroid_dir <- here("DATA", "Centroid_Area_Imovel")

# outputs
out_rds <- here("DATA/outputs", "rds")
out_shp <- here("DATA/outputs", "shp")

dir_create(out_rds)
dir_create(out_shp)

# old 
#base_dir <- "D:/Desktop/Dados-Geo-Espaciais/Dados-CAR/SC/APP"

# Pre Process APP data
list_app_path <- fs::path(
  app_dir,
  paste0("APPS_", 1:3, ".shp")
)

# create a list of names 
app_names <- c("app1", "app2", "app3")

# Pre process the data first and store in a list
filtered_list <- list()
for (i in seq_along(list_app_path)) {
  # Read data
  app_data <- st_read(list_app_path[i])

  # Drop geometry and add identifier
  app_data <- st_drop_geometry(app_data) %>%
    mutate(
      name_of_file = app_names[i],  # Use the simple name
      source_file = basename(list_app_path[i])  # Add full filename if needed
    )

  # Get unique labels and selected fields
  unique_non_tema <- app_data$nom_tema %>% unique() %>% sort()

  # filtering fields of APP A SER RESTAURADA
  selected_field <- c(5, 6, 7, 8, 9, 10, 11, 12, 29)
  selected_values <- unique_non_tema[selected_field]

  # Filter and store
  filtered_app <- app_data %>%
    filter(nom_tema %in% selected_values)

  filtered_list[[app_names[i]]] <- filtered_app

  # Clean up
  rm(app_data, filtered_app)
  gc()  # Force garbage collection to immediately free memory
}

# Combine results
filtered_output <- bind_rows(filtered_list, .id = "app_source")

## SAVE
##Save filtered_output
rds_path <- file.path(out_rds, "trat_completo.rds")
saveRDS(filtered_output, rds_path)

## 
## End of Pre Process APP data
## --------------------------



## ------------------------------
##  DATA CLEANING PROCESSING

## JOIN OPERATIONS
## Read it back 
filtered_output <- readRDS(rds_path)

## JOIN
## This part of the  code will join the CAR dataset with the filtered_output
# given by the Unique identificador CAR_code

# LOAD CAR + CENTROID
## Load Centroid CAR
## Load CAR cadastro
car_cadastro <- st_read(
  file.path(car_dir, "AREA_IMOVEL_1.shp"),
  quiet = TRUE
)

centroid <- st_read(
  file.path(centroid_dir, "centroid.shp"),
  quiet = TRUE
)

## Data Cleaning - Untrustworthy data
## The data from CAR has several inconsistencies regarding the des_condic field.
##  Analysis of duplicate before join
# Check for duplicate keys in each dataset
# Get all duplicates (including first occurrence)
duplicates <- centroid %>%
  filter(duplicated(cod_imovel) | duplicated(cod_imovel, fromLast = TRUE)) %>%
  arrange(cod_imovel)  # Sort for easier inspection

## Filter to avoid duplicity
unique_list_centroid_decisao <- centroid$des_condic %>% unique() %>% sort()
centroid_unique <- centroid %>%
  filter(!des_condic %in% unique_list_centroid_decisao[c(6,7,8)])

## Double  check of duplicated
duplicates_unique <- centroid_unique %>%
  filter(duplicated(cod_imovel) | duplicated(cod_imovel, fromLast = TRUE)) %>%
  arrange(cod_imovel)

## It needs to filter out all of the des_condic as Cancelado  por decisao
duplicates_filtered <- filtered_output$g %>% unique() %>% sort()

## Exclui as linhas que pertecem a algum grau de Cancelamento Perante Analise
filtered_output_unique <- filtered_output %>%
  filter(!des_condic %in% duplicates_filtered[c(5,6)])

## Join the centroid geometry with the APP based on the cod_imovel
joined_app_centroid <- filtered_output_unique %>%
  left_join(centroid_unique, by = "cod_imovel", suffix = c("_app", "_car")) %>%
  st_as_sf()


# save join 
st_write(
  joined_app_centroid,
  file.path(out_shp, "App_CAR_centroid.shp"),
  delete_dsn = TRUE
)

##--------------------------------------------------------------------------------------
## GROUPBY
## Group by property ID

## Group by cod_imovel and sum APP area
start.time <- Sys.time()
result_cod_imovel <- joined_app_centroid |>
  group_by(cod_imovel) |>
  summarise(total_area_app = sum(num_area_app, na.rm = TRUE),
    ind_status = first(ind_status_app),
    modulo_fiscal = first(mod_fiscal),
    area_total = first(num_area_car),
    municipio = first(municipio),
    cod_estado = first(cod_estado),
    dat_criaca = first(dat_criaca),
    geometry = first(geometry),
    #.groups = "drop"
)
end.time <- Sys.time()
time.taken <- round(end.time - start.time,2)
print(time.taken)


## Write a new shp file
st_write(
  result_cod_imovel,
  file.path(out_shp, "App_CAR_Groupby_Imovel.shp"),
  delete_dsn = TRUE
)

## Groupby - Tipo de APP a ser Restaurada
start.time <- Sys.time()
result_cod_tema <- joined_app_centroid |>
  group_by(cod_tema_app) |>
  summarise(total_area_app = sum(num_area_app, na.rm = TRUE)
)
end.time <- Sys.time()
time.taken <- round(end.time - start.time,2)
print(time.taken)

st_write(
  result_cod_tema,
  file.path(out_shp, "App_CAR_Groupby_cod_tema.shp"),
  delete_dsn = TRUE
)
