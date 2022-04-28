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

wbFilename <- "9aa4aa86-0390-4542-9a86-d35408e5c066"
url <- paste0(
  "https://databank.worldbank.org/AjaxDownload",
  "/FileDownloadHandler.ashx?filename=", wbFilename, ".zip",
  "&filetype=CSV&language=en",
  "&displayfile=Data_Extract_From_World_Development_Indicators.zip"
)
download.file(url, file.path(f, "temp.zip"))
unzip(
  file.path(f, "temp.zip"), 
  files = paste0(wbFilename, "_Data.csv"),
  exdir = f
)
invisible(file.rename(
  file.path(f, paste0(wbFilename, "_Data.csv")), 
  file.path(f, "gdp_ann.csv")
))
unlink(file.path(f, "temp.zip"))
