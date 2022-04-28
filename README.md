# Master's Thesis Replication

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