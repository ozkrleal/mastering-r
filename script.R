library(binancer)
library(logger)
library(checkmate)

prices <- binance_ticker_all_prices()
prices[from == 'BTC' & to == 'USDT', price]

binance_coins_prices()[symbol == 'BTC', usd]

# library(fixerapi)
# fixerapi::fixer_latest(base = "USD", symbols = "HUF")
# today_symbols <- fixer_latest(base = "EUR", 
#                               symbols = c("JPY", "GBP", "USD", "CAD", "CHF"))Behavioral Finance
# 
# print(today_symbols)

library(jsonlite)

get_bitcoin_price <- function() {
  tryCatch(
    binance_coins_prices()[symbol == 'BTC', usd],
    error = function(e) get_bitcoin_price())
}

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

btcusdt <- get_bitcoin_price()
log_info('The value of 1 Bitcoin in USD: {btcusdt}')
assert_number(btcusdt, lower = 1000)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('The value of 1 USD in HUF: {usdhuf}')
assert_number(usdhuf, lower = 250, upper = 500)


BITCOINS * btcusdt * usdhuf
log_info(BITCOINS*btcusd*usdhuf) # TODO formatting

#checkmate r - check arguments of a function
