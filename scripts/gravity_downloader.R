#### CREATE DIRECTORIES

f <- "data/gravity"
dir.create(f, showWarnings = FALSE, recursive = TRUE)



#### GET FILES

url <- paste0(
  "https://drive.google.com/uc?id=1aVQ9YHYQ1zW8eXPs96k7a4CVheNgoNQG",
  "&export=download"
)
download.file(url, file.path(f, "temp.zip"), mode = "wb")
unzip(
  file.path(f, "temp.zip"), 
  files = "gravity.csv",
  exdir = f
)
unlink(file.path(f, "temp.zip"))



#### IMPORT

gravity <- fread(
  "data/gravity/gravity.csv", encoding = "UTF-8", showProgress = FALSE,
  data.table = FALSE
)
