#### CREATE DIRECTORIES

f <- "data/gvc"
dir.create(f, showWarnings = FALSE, recursive = TRUE)



#### GET FILES

## Backward participation

url <- paste0(
  "https://stats.oecd.org",
  "/FileView2.aspx?IDFile=6ea9d6ee-73ee-4113-ad5e-7867a2f0f17c"
)
download.file(url, file.path(f, "temp.zip"), method = "curl")
unzip(
  file.path(f, "temp.zip"), 
  files = "DEXFVApSH.csv",
  exdir = f
)
invisible(file.rename(
  file.path(f, "DEXFVApSH.csv"), 
  file.path(f, "gvc_bp.csv")
))
unlink(file.path(f, "temp.zip"))


## Forward participation

url <- paste0(
  "https://stats.oecd.org",
  "/FileView2.aspx?IDFile=808e3266-58f9-41a9-ab83-4e28f61c79b1"
)
download.file(url, file.path(f, "temp.zip"), method = "curl")
unzip(
  file.path(f, "temp.zip"), 
  files = "FEXDVApSH.csv",
  exdir = f
)
invisible(file.rename(
  file.path(f, "FEXDVApSH.csv"), 
  file.path(f, "gvc_fp.csv")
))
unlink(file.path(f, "temp.zip"))