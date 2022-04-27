#### IMPORT DATA

gvc.fp <- read.csv(
  "data/gvc/gvc_fp.csv", sep = "|", encoding = "UTF-8", header = FALSE
)
gvc.bp <- read.csv(
  "data/gvc/gvc_bp.csv", sep = "|", encoding = "UTF-8", header = FALSE
)



#### WRANGLE

### GVC FP
## Select
gvc.fp <- gvc.fp[, c(2, 3, 5, 6)]
colnames(gvc.fp) <- c("repcode", "parcode", "year", "gvc_fp")

## Filter
gvc.fp <- gvc.fp[gvc.fp$year == 2018,]
gvc.fp <- gvc.fp[gvc.fp$parcode == "WLD",]
gvc.fp <- gvc.fp[1:(nrow(gvc.fp)-16),]


### GVC BP
## Select
gvc.bp <- gvc.bp[, c(2, 3, 5, 6)]
colnames(gvc.bp) <- c("repcode", "parcode", "year", "gvc_bp")

## Filter
gvc.bp <- gvc.bp[gvc.bp$year == 2018,]
gvc.bp <- gvc.bp[gvc.bp$parcode == "WLD",]
gvc.bp <- gvc.bp[1:(nrow(gvc.bp)-16),]


### COMBINE
## Join
gvc <- left_join(gvc.fp, gvc.bp, by = "repcode")

## Mutate
gvc["gvc"] <- gvc$gvc_fp + gvc$gvc_bp
gvc["upstreamness"] <- log(1 + gvc$gvc_fp) - log(1 + gvc$gvc_bp)

## Select
gvc <- gvc[, c(1, 8, 9)]
colnames(gvc) <- c("countrycode", "gvc", "upstreamness")



#### CLEAN UP

rm(list = c(
  "gvc.bp", "gvc.fp"
))
