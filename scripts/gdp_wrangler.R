#### IMPORT DATA

gdp_g <- read.csv("data/gdp/gdp_g.csv", encoding = "UTF-8")
gdp_2017 <- read.csv("data/gdp/gdp_2017.csv", encoding = "UTF-8")
gdp_ann <- read.csv(
  "data/gdp/gdp_ann.csv", encoding = "UTF-8", skip = 4#
)



#### SUPPORT FUNCTIONS

generate_growthrates <- function(df, countrycode) {
  
  temp <- df[df$countrycode == countrycode,]
  temp <- lapply(
    temp$period, function(x) rep(temp[temp$period == x,]$growth ^ (1/3), 3)
  )
  temp <- data.frame(
    countrycode = rep(countrycode, 42), 
    year        = c(rep(2018, 12), rep(2019, 12), rep(2020, 12), rep(2021, 6)),
    month       = c(rep(1:12, 3), 1:6),
    growth      = unlist(temp)[2:43],  # Center on second month of quarter
    oecd        = rep(1, 42)
  )
  
  return(temp)
  
}

generate_annual <- function(df, countrycode) {
  
  temp <- df[df$countrycode == countrycode,]
  temp <- lapply(
    2018:2021, function(x) {
      if (x == 2021) {
        len <- 6 
        data.frame(
          countrycode = rep(countrycode, len),
          year        = rep(x, len),
          month       = 1:len,
          gdp_ann     = rep(NA, len)
        )
      } else {
        len <- 12
        data.frame(
          countrycode = rep(countrycode, len),
          year        = rep(x, len),
          month       = 1:len,
          gdp_ann     = rep(temp[temp$year == x,]$gdp_ann, len)
        )
      }

    }
  )
  
  return(bind_rows(temp))
  
}



#### WRANGLE DATA

### MONTHLY GROWTH RATES
## Select
gdp_g <- gdp_g[, c(1, 6, 7)]
colnames(gdp_g) <- c("countrycode", "period", "growth")

## Filter
gdp_g <- gdp_g[!(gdp_g$countrycode %in% c(
  "OECD", "OECDE", "G-7", "G-20", "EA19", "EU27_2020"
  )),]

## Mutate
gdp_g["growth"] <- (gdp_g$growth + 100) / 100
gdp_g <- lapply(
  unique(gdp_g$countrycode), function(x) generate_growthrates(gdp_g, x)
)
gdp_g <- bind_rows(gdp_g)

gdp_g <- gdp_g %>% 
  group_by(countrycode) %>% 
  mutate(cum_growth = cumprod(growth))


### 2017 GDP
## Select

gdp_2017 <- gdp_2017[, c(1, 7)]
colnames(gdp_2017) <- c("countrycode", "gdp_2017")


### ANNUAL GDP
## Select
gdp_ann <- gdp_ann[, c(2, 5:8)]
colnames(gdp_ann) <- c("countrycode", "Y_2018", "Y_2019", "Y_2020", "Y_2021")
gdp_ann <- pivot_longer(
  data             = gdp_ann, 
  cols             = Y_2018:Y_2021, 
  names_to         = "year",
  names_prefix     = "Y_",
  names_transform  = list(year = as.integer),
  values_to        = "gdp_ann"
)

## Mutate
gdp_ann <- lapply(
  unique(gdp_ann$countrycode), function(x) generate_annual(gdp_ann, x)
)
gdp_ann <- bind_rows(gdp_ann)


### GENERATE MONTHLY GDP
## Join
gdp <- left_join(gdp_g, gdp_2017, by = c("countrycode"))
gdp <- full_join(gdp, gdp_ann, by = c("countrycode", "year", "month"))

## Mutate
gdp["gdp"] <- gdp$cum_growth * gdp$gdp_2017
gdp[is.na(gdp$oecd), "oecd"] <- 0

## Select
gdp <- gdp[, c("countrycode", "year", "month", "gdp", "gdp_ann", "oecd")]



#### CLEAN UP

rm(list = c(
  "gdp_g", "gdp_2017", "gdp_ann", "generate_annual", "generate_growthrates"
))
