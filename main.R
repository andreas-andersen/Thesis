################################################################################
#                                                                              #
#                       Replicating script for                                 #
#                        "PLACEHOLDER TITLE"                                   #
#                                                                              #
#   Author: Andreas Makoto Fukuda Andersen                                     #
#   Date: 28 April 2022                                                        #
#                                                                              #
################################################################################

# Make sure to review all the parameters below before executing the script

#### DEPENDENCIES

library(data.table)
library(lubridate)
library(readxl)
library(RStata)
library(tidyverse)



#### SCRIPT PARAMETERS

## Include wrangling
wrangle <- TRUE
# Set to TRUE if the script should download and wrangle data
# If set to FALSE the script will download an archived finished dataset
# Archived at 28 April 2022

## Downloading Comtrade data
comtradeDownloader <- FALSE
# Set to TRUE if the script should use the ComtradeDatabaseDownloader
# If set to FALSE the script will download an archived Comtrade dataset
# Archived at 27 April 2022

## Comtrade token
comtradeToken <- ""
# If comtradeDownloader is set to TRUE, input Comtrade API token

## Path to Stata executable (without the '.exe' suffix)
options("RStata.StataPath" = "\"C:\\Program Files\\Stata17\\StataSE-64\"")
# Alternatively, use the chooseStataBin() function to locate executable

## Stata version
options("RStata.StataVersion" = 17)



#### FILE DOWNLOAD

if (wrangle == TRUE) {
  
  source("comtrade_downloader.R")  # Comtrade
  source("si_downloader.R")        # OxCGRT Stringency Index
  source("gdp_downloader.R")       # OECD GDP
  source("cepii_downloader.R")     # CEPII Gravity
  source("gvc_downloader.R")       # TiVA GVC
  
}



#### WRANGLE

if (wrangle == TRUE) {
  
  source("comtrade_wrangler.R")    # Comtrade
  source("si_wrangler.R")          # OxCGRT Stringency Index
  source("gdp_wrangler.R")         # OECD GDP
  source("cepii_wrangler.R")       # CEPII Gravity
  source("gvc_wrangler.R")         # TiVA GVC
  
}



#### COMBINE

if (wrangle == TRUE) {
  
  source("combiner.R")
  
}



#### EXPORT/DOWNLOAD COMPLETED DATASET

if (wrangle == TRUE) {
  
  source("exporter.R")
  
} else {
  
  source("gravity_downloader.R")
  
}



#### RUN ANALYSIS

## Generate output folder
f <- "output"
dir.create(f, showWarnings = FALSE, recursive = TRUE)

stata("analysis.do", data.in = gravity)
