#### COMBINE

### OxCGRT Stringency Index
gravity <- left_join(
  comtrade, si, 
  by = c("repcode" = "countrycode", "year", "month")
)
gravity <- left_join(
  gravity, si, 
  by = c("parcode" = "countrycode", "year", "month"),
  suffix = c("_rep", "_par")
)
gravity[is.na(gravity)] <- 0


### OECD GDP
gravity <- left_join(
  gravity, gdp,
  by = c("repcode" = "countrycode", "year", "month"),
)
gravity <- left_join(
  gravity, gdp,
  by = c("parcode" = "countrycode", "year", "month"),
  suffix = c("_rep", "_par")
)
gravity["oecd"] <- gravity$oecd_rep * gravity$oecd_par  # Intra-OECD trade ind.
gravity <- gravity[, -which(names(gravity) %in% c("oecd_rep","oecd_par"))]


### CEPII Gravity
gravity <- left_join(
  gravity, cepii,
  by = c("repcode", "parcode", "year")
)


### TiVA GVC
gravity <- left_join(
  gravity, gvc,
  by = c("repcode" = "countrycode")
)
gravity <- left_join(
  gravity, gvc,
  by = c("parcode" = "countrycode"),
  suffix = c("_rep", "_par")
)



#### CLEAN UP
## Missing GDP values
gravity <- gravity[!(is.na(gravity$gdp_ann_rep) & gravity$year <= 2020),]
gravity <- gravity[!(is.na(gravity$gdp_ann_par) & gravity$year <= 2020),]

## Generate date variable
gravity["date"] <- make_date(gravity$year, gravity$month, 1)

## Convert class of 'flow' variable
gravity["flow"] <- as.character(gravity$flow)

## Sort values
gravity <- gravity[
  order(gravity$repcode, gravity$parcode, gravity$flow, gravity$period)
,]

## Select and reorder variables
gravity <- gravity[,c("date", "year", "month", "flow", "repcode", "reporter",
                      "parcode", "partner", "value", "si_rep", "si_par",
                      "gdp_rep", "gdp_ann_rep", "gdp_par", "gdp_ann_par",
                      "oecd", "contig", "coldepever", "wto_rep", "wto_par",
                      "rta", "landlocked_rep", "landlocked_par", 
                      "comlang_ethno", "distw", "gvc_rep", "upstreamness_rep", 
                      "gvc_par", "upstreamness_par")]
