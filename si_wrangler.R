#### IMPORT DATA

si <- read.csv("data/si/si.csv", encoding = "UTF-8")



#### WRANGLE DATA

## Select

si <- si[, c(2, 4:550)]
si <- pivot_longer(
  data      = si, 
  cols      = X01Jan2020:X30Jun2021, 
  names_to  = "date", 
  values_to = "si"
)
colnames(si) <- c("countrycode", "date", "si")


## Create date variables

si[, "date"] <- as.Date(si$date, "X%d%b%Y")
si[, "year"] <- year(si$date)
si[, "month"] <- month(si$date)


## Summarise to group means

si <- si %>% 
  group_by(countrycode, year, month) %>% 
  summarise(si = mean(si))
