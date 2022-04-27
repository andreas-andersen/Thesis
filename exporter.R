#### CREATE DIRECTORIES

f <- "data/gravity"
dir.create(f, showWarnings = FALSE, recursive = TRUE)



#### EXPORT

fwrite(gravity, file.path(f, "gravity.csv"), showProgress = FALSE)