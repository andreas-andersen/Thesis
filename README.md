# Master's Thesis Replication Code

Run everything through `main.R` and make sure to set the initial parameters
correctly. The script requires the download and storage of ca. 1.2 GB of data, 
so choose working directory accordingly.

### Prerequisites:

- `data.table`
- `lubridate`
- `readxl`
- `RStata`
- `tidyverse`
- Downloading latest data from the Comtrade database through the parameter 
`comtradeDownloader <- TRUE` requires the 
[`ComtradeDatabaseDownloader`](https://github.com/andreas-andersen/ComtradeDatabaseDownloader)
package and a premium site license subscription.

### Parameters:

`wrangle <- TRUE`  
Will tell the script to run through the downloading and wrangling steps. If set 
to `FALSE`, the script will download an archived, completed dataset. The file
was archived at 28 April 2022.

`comtradeDownloader <- TRUE`  
Will tell the script to use the `ComtradeDatabaseDownloader` package to
extract the latest available data from Comtrade. If set to `FALSE`, the script
will download an archived version extracted at 27 April 2022.

__WARNING!__  
Downloading a fresh dataset from Comtrade will require around 2 hours to 
complete. The connection might also fail, which requires you to re-run the 
script. The downloader does have a backup system which means you do not have 
to start re-downloading everything.

`comtradeToken <- ""`  
If the above parameter is set to `TRUE`, input a valid Comtrade API token here.
See the [`ComtradeDatabaseDownloader`](https://github.com/andreas-andersen/ComtradeDatabaseDownloader)
repository for further details.

`options("RStata.StataPath" = "\"C:\\Program Files\\Stata17\\StataSE-64\"")`
Used to set the path to the Stata executable installed on your system.
Optionally, you can use the `chooseStataBin()` function. See the 
[`RStata`](https://github.com/lbraglia/RStata) repository for further details.

`options("RStata.StataVersion" = 17)`  
Assign the version number of your Stata installation
