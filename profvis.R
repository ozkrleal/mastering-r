library(profvis)
library(data.table)
library(dplyr)
dt <- data.table(diamonds)

profvis({
  dt[, sum(carat), by = color][order(color)]
  group_by(dt, color) %>% summarise(V1 = sum(carat))
})

library(microbenchmark)
microbenchmark(
  aggregate(dt$carat, by = list(dt$color), FUN = sum),
  dt[, sum(carat), by = color][order(color)],
  group_by(dt, color) %>% summarise(V1 = sum(carat)),
  times = 100
)

## dtplyr