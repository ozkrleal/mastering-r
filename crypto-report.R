library(binancer)
library(logger)
log_threshold(TRACE)
library(mr)
library(httr)
library(data.table)
library(ggplot2)
library(dbr)
#devtools::install_github('daroczig/logger')
#devtools::install_github('daroczig/dbr')

BITCOINS  <- 0.42
ETHEREUMS <- 1.2 # NOTE

options('dbr.db_config_path' = 'database.yml')
db_query('select * from coins', 'freemysql')

coinsusdt <- rbindlist(lapply(c('BTCUSDT', 'ETHUSDT'), 
                              binance_klines, interval = '1d', limit = 30))
balance <- coinsusdt[, .(date = as.Date(close_time), usd = close, symbol)]

balance[, amount := switch(
  symbol,
  'BTCUSDT' = BITCOINS,
  'ETHUSDT' = ETHEREUMS,
  stop('I have no idea which you mean')
), by = symbol]
usdhuf <- content(GET(
  'https://api.exchangeratesapi.io/history',
  query = list(
    start_at = Sys.Date() - 30,
    end_at   = Sys.Date(),
    base     = 'USD',
    symbols  = 'HUF'
  )))$rates
usdhuf <- data.table(date = as.Date(names(usdhuf)), 
                     usdhuf = unlist(usdhuf))[order(date)]
setkey(balance, date)
setkey(usdhuf, date)
balance <- usdhuf[balance, roll = TRUE]
balance[, value := amount * usd * usdhuf]
str(balance)
ggplot(balance, aes(date, value, fill = symbol)) + 
  geom_col() +
  xlab('') + ylab('') +
  scale_y_continuous(labels = forint) +
  theme_bw() +
  ggtitle('My crypto fortune')
