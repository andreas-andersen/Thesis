#### IMPORT DATA

cepii.geo <- read_excel("data/cepii/cepii_geo.xls", na = ".")
cepii.dist <- read_excel("data/cepii/cepii_dist.xls", na = ".")
cepii.grav <- fread(
  "data/cepii/cepii_grav.csv", encoding = "UTF-8", showProgress = FALSE,
  data.table = FALSE
)



#### WRANGLE DATA

### GEO DATA
## Select
cepii.geo <- cepii.geo[, c(2, 8)]
colnames(cepii.geo) <- c("countrycode", "landlocked")

## Filter
cepii.geo <- distinct(cepii.geo)

## Mutate
cepii.geo["countrycode"] <- str_replace(cepii.geo$countrycode, "ROM", "ROU")


### DIST DATA
## Select
cepii.dist <- cepii.dist[, c(1, 2, 5, 13)]
colnames(cepii.dist) <- c("repcode", "parcode", "comlang_ethno", "distw")

## Mutate
cepii.dist["repcode"] <- str_replace_all(cepii.dist$repcode, "ROM", "ROU")
cepii.dist["parcode"] <- str_replace_all(cepii.dist$parcode, "ROM", "ROU")
cepii.dist["distw"] <- as.numeric(cepii.dist$distw)


### GRAVITY DATA
## Select
cepii.grav <- cepii.grav[, c(1:3, 10, 30, 59, 60, 63)]
colnames(cepii.grav) <- c("year", "repcode", "parcode", "contig", "coldepever",
                          "wto_rep", "wto_par", "rta")

## Filter
cepii.grav <- cepii.grav[cepii.grav$year %in% 2018:2019,]

## Mutate
cepii.grav.2020 <- cepii.grav.2021 <- cepii.grav[cepii.grav$year == 2019,]
cepii.grav.2020["year"] <- 2020
cepii.grav.2021["year"] <- 2021
cepii.grav <- bind_rows(list(cepii.grav, cepii.grav.2020, cepii.grav.2021))


### COMBINE
## Join
cepii <- left_join(
  cepii.grav, cepii.geo, by = c("repcode" = "countrycode")
)
cepii <- left_join(
  cepii, cepii.geo, by = c("parcode" = "countrycode"), 
  suffix = c("_rep", "_par")
)
cepii <- left_join(cepii, cepii.dist, by = c("repcode", "parcode"))



#### CLEAN UP

rm(list = c(
  "cepii.geo", "cepii.dist", "cepii.grav", "cepii.grav.2020", "cepii.grav.2021"
))
