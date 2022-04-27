################################################################################
#                                                                              #
#                       Replicating script for                                 #
#                        "PLACEHOLDER TITLE"                                   #
#                                                                              #
#   Author: Andreas Makoto Fukuda Andersen                                     #
#   Date:                                                                      #
#                                                                              #
################################################################################

# Make sure to review the parameters before executing the script

#### SCRIPT PARAMETERS

## Include wrangling
wrangle <- TRUE
# Set to TRUE if the script should download and wrangle data
# If set to FALSE the script will download an archived finished dataset

## Downloading Comtrade data
comtradeDownloader <- FALSE
# Set to TRUE if the script should use the ComtradeDatabaseDownloader
# If set to FALSE the script will download an archived Comtrade dataset

## Comtrade token
comtradeToken <- "8K+Ux0yKc/xsg/fbofljZijFtTTVVK64UZDHgh+jXGlp5q27ZPNQFpqq8xJG8s8SEHr2Ui0rR06ZwyEcUbGdPCU2O3H3Vtn+i3qLTAXrA8otLpf9Af/MqsuB7oVoH+e9B9qAOi5HqfzfazeqjzGBB7B1AqkeHSckOisESJ7XESM="
# If above parameter is set to TRUE, input Comtrade API token

## Path to Stata directory
chooseStataBin()

## Stata version
options("RStata.StataVersion" = 17)



#### DEPENDENCIES

library(tidyverse)
library(readxl)
library(data.table)
library(RStata)
library(lubridate)



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

stata("analysis.do", data.in = gravity)
