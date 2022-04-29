################################################################################
#                                                                              #
#                       Replicating script for                                 #
#                        "PLACEHOLDER TITLE"                                   #
#                                                                              #
#   Author: Andreas Makoto Fukuda Andersen                                     #
#   Date: 29 April 2022                                                        #
#                                                                              #
################################################################################

# Make sure to review all the parameters below before executing the script

#### DEPENDENCIES

source("scripts/dependency_check.R")

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
  
  source("scripts/comtrade_downloader.R")  # Comtrade
  source("scripts/si_downloader.R")        # OxCGRT Stringency Index
  source("scripts/gdp_downloader.R")       # GDP
  source("scripts/cepii_downloader.R")     # CEPII Gravity
  source("scripts/gvc_downloader.R")       # TiVA GVC
  
}



#### WRANGLE

if (wrangle == TRUE) {
  
  source("scripts/comtrade_wrangler.R")    # Comtrade
  source("scripts/si_wrangler.R")          # OxCGRT Stringency Index
  source("scripts/gdp_wrangler.R")         # GDP
  source("scripts/cepii_wrangler.R")       # CEPII Gravity
  source("scripts/gvc_wrangler.R")         # TiVA GVC
  
}



#### COMBINE

if (wrangle == TRUE) {
  
  source("scripts/combiner.R")
  
}



#### EXPORT/DOWNLOAD COMPLETED DATASET

if (wrangle == TRUE) {
  
  source("scripts/exporter.R")
  
} else {
  
  source("scripts/gravity_downloader.R")
  
}



#### RUN ANALYSIS

## Generate output folder
f <- "output"
dir.create(f, showWarnings = FALSE, recursive = TRUE)

stata("scripts/analysis.do", data.in = gravity)
