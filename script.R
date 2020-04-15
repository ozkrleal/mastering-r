library(binancer)
prices <- binance_ticker_all_prices()
prices[from == 'BTC' & to == 'USDT', price]

binance_coins_prices()[symbol == 'BTC', usd]

# library(fixerapi)
# fixerapi::fixer_latest(base = "USD", symbols = "HUF")
# today_symbols <- fixer_latest(base = "EUR", 
#                               symbols = c("JPY", "GBP", "USD", "CAD", "CHF"))
# 
# print(today_symbols)

library(jsonlite)


binance_coins_prices()[symbol == 'BTC', usd] * fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF * 0.42

