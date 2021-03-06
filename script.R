library(binancer)
library(logger)
library(checkmate)
library(jsonlite)
library(scales)
log_threshold(TRACE)

#prices <- binance_ticker_all_prices()
#prices[from == 'BTC' & to == 'USDT', price]

binance_coins_prices()[symbol == 'BTC', usd]

get_bitcoin_price <- function(retried = 0) {
  tryCatch(
    binance_coins_prices()[symbol == 'BTC', usd],
    error = function(e) {
      ## exponential backoff retries
      Sys.sleep(1 + retried ^ 2)
      get_bitcoin_price(retried = retried + 1)
      })
}

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

forint <- function(x) {
  dollar(x, prefix = '', suffix = 'Ft')
}

btcusdt <- get_bitcoin_price()
log_info('The value of 1 Bitcoin in USD: {dollar(btcusdt)}')
#log_eval(btcusdt)
assert_number(btcusdt, lower = 1000)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info("The value of 1 USD in HUF: {}")
assert_number(usdhuf, lower = 250, upper = 500)


BITCOINS * btcusdt * usdhuf
log_eval(forint(BITCOINS*btcusdt*usdhuf))

#debugonce is useful
# ::: three colons toaccess private fnctions within a library