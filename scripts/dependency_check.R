#### PACKAGE CHECKS

package.names <- rownames(installed.packages())

if (!("data.table" %in% package.names)) {
  stop("Package 'data.table' is missing.")
}
if (!("lubridate" %in% package.names)) {
  stop("Package 'lubridate' is missing.")
}
if (!("readxl" %in% package.names)) {
  stop("Package 'readxl' is missing.")
}
if (!("RStata" %in% package.names)) {
  stop("Package 'RStata' is missing.")
}
if (!("tidyverse" %in% package.names)) {
  stop("Package 'tidyverse' is missing.") 
} else if (packageVersion("tidyverse") < "1.3.1") {
  stop("Package 'tidyverse' is outdated. Please update to latest version")
}

message("All 'R' dependencies OK")


#### CLEAN UP

rm(package.names)
