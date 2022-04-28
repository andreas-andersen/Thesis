#### CREATE DIRECTORIES

f <- "data/cepii"
dir.create(f, showWarnings = FALSE, recursive = TRUE)



#### GET FILES

## Country specific geographical data

url <- "http://www.cepii.fr/distance/geo_cepii.xls"
download.file(url, file.path(f, "cepii_geo.xls"), mode = "wb")


## Dyadic distance data

url <- "http://www.cepii.fr/distance/dist_cepii.zip"
download.file(url, file.path(f, "temp.zip"))
unzip(
  file.path(f, "temp.zip"), 
  files = "dist_cepii.xls",
  exdir = f
)
invisible(file.rename(
  file.path(f, "dist_cepii.xls"), 
  file.path(f, "cepii_dist.xls")
))
unlink(file.path(f, "temp.zip"))


## Gravity data

url <- "http://www.cepii.fr/DATA_DOWNLOAD/gravity/data/Gravity_csv_V202102.zip"
download.file(url, file.path(f, "temp.zip"))
unzip(
  file.path(f, "temp.zip"), 
  files = "Gravity_V202102.csv",
  exdir = f
)
invisible(file.rename(
  file.path(f, "Gravity_V202102.csv"), 
  file.path(f, "cepii_grav.csv")
))
unlink(file.path(f, "temp.zip"))
