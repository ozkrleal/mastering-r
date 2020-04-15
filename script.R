library(binancer)
library(logger)
library(checkmate)
library(jsonlite)
log_threshold(TRACE)

prices <- binance_ticker_all_prices()
prices[from == 'BTC' & to == 'USDT', price]

binance_coins_prices()[symbol == 'BTC', usd]

get_bitcoin_price <- function() {
  tryCatch(
    binance_coins_prices()[symbol == 'BTC', usd],
    error = function(e) get_bitcoin_price())
}

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

btcusdt <- get_bitcoin_price()
log_info('The value of 1 Bitcoin in USD: {btcusdt}')
#log_eval(btcusdt)
assert_number(btcusdt, lower = 1000)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('The value of 1 USD in HUF: {usdhuf}')
assert_number(usdhuf, lower = 250, upper = 500)


BITCOINS * btcusdt * usdhuf
log_eval(BITCOINS*btcusd*usdhuf)

