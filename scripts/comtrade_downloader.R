#### DEPENDENCIES

## Check if required packages are available

if (comtradeDownloader == TRUE) {
  
  if (!("ComtradeDatabaseDownloader" %in% rownames(installed.packages()))) {
    if (!("devtools" %in% rownames(installed.packages()))) {
      install.packages("devtools")
    }
    library(devtools)
    install_github("andreas-andersen/ComtradeDatabaseDownloader")
  }
  
  library(ComtradeDatabaseDownloader)
  
}



#### CREATE DIRECTORIES

f <- "data/comtrade"
dir.create(f, showWarnings = FALSE, recursive = TRUE)



#### GET FILES

if (comtradeDownloader == TRUE) {  # With ComtradeDatabaseDownloader
  
  get_comtrade(
    freq       = "monthly",
    startyear  = 2018,
    startmonth = 1,
    endyear    = 2021,
    endmonth   = 6,
    token      = comtradeToken,
    savedir    = f,
    int64      = FALSE
  )
  invisible(file.rename(
    file.path(f, "gravity.csv"), 
    file.path(f, "comtrade.csv")
  ))
  
} else {                           # From archive

  url <- paste0(
    "https://drive.google.com/uc?id=1aU9dxNtkai43ZH5CyNbLntukVgTMHv8L",
    "&export=download"
  )
  download.file(url, file.path(f, "temp.zip"), mode = "wb")
  unzip(
    file.path(f, "temp.zip"), 
    files = "comtrade.csv",
    exdir = f
  )
  unlink(file.path(f, "temp.zip"))
  
}
