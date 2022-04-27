#### CREATE DIRECTORIES

f <- "data/si"
dir.create(f, showWarnings = FALSE, recursive = TRUE)



#### GET FILES

url <- paste0(
  "https://github.com/OxCGRT/covid-policy-tracker/blob/master/data/timeseries",
  "/stringency_index.csv?raw=true"
)
download.file(url, file.path(f, "si.csv"))
