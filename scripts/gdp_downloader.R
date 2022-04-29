#### CREATE DIRECTORIES

f <- "data/gdp"
dir.create(f, showWarnings = FALSE, recursive = TRUE)



#### GET FILES

## Monthly GDP growth

url <- paste0(
  "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.QGDP.TOT.PC_CHGPP.Q",
  "/OECD?contentType=csv&detail=code&separator=comma&csv-lang=en",
  "&startPeriod=2018-Q1&endPeriod=2021-Q3"
)
download.file(url, file.path(f, "gdp_g.csv"))


## GDP in 2017

url <- paste0(
  "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.GDP.TOT.MLN_USD.A",
  "/OECD?contentType=csv&detail=code&separator=comma&csv-lang=en",
  "&startPeriod=2017&endPeriod=2017"
)
download.file(url, file.path(f, "gdp_2017.csv"))


## Annual GDP

url <- paste0(
  "http://api.worldbank.org/v2/country/all/indicator/",
  "NY.GDP.MKTP.CD?source=2&downloadformat=csv&date=2018:2021"
)
download.file(url, file.path(f, "temp.zip"), mode = "wb")
unzip(
  file.path(f, "temp.zip"), 
  files = "API_NY.GDP.MKTP.CD_DS2_EN_csv_v2_4040385.csv",
  exdir = f
)
invisible(file.rename(
  file.path(f, "API_NY.GDP.MKTP.CD_DS2_EN_csv_v2_4040385.csv"), 
  file.path(f, "gdp_ann.csv")
))
unlink(file.path(f, "temp.zip"))
