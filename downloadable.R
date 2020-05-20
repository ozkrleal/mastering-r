download.file('http://bit.ly/CEU-R-ecommerce', 'ecommerce.zip', mode = 'wb')
unzip('ecommerce.zip')

## docker11!!! + mran


### db connections
### reporting ino excel and google spreadsheets

library(RSQLite)
library(dbr)
options('dbr.db_config_path' = 'database.yml')
options('dbr.output_format' = 'data.table')

sales <- db_query('SELECT * FROM sales', 'ecommerce')
str(sales)

db_refresh(sales)

sales[, sample(InvoiceDate, 25)]
sales[, InvoiceDate := as.POSIXct(InvoiceDate, format = '%m/%d/%Y %H:%M')]

str(sales)

library(lubridate)
#mdy_hms("11/14/2011 12:57")

##TODO compute the number of rows per month
sales[, .N, by = .(month = as.character(InvoiceDate, format = '%Y $m'))]

sales[, .N, by = month(InvoiceDate)]
sales[, .N, by = year(InvoiceDate)]
sales[, .N, by = paste(year(InvoiceDate), month(InvoiceDate))]
sales[, .N, by = zoo::as.yearmon(InvoiceDate)]

Sys.getlocale()
Sys.getenv()

sales[, .N, by = floor_date(InvoiceDate, 'month')]

##TODO invoice summary: invoice number, customer, country, date, value
invoices <- sales[ , .(date = min(as.Date(InvoiceDate)),
                      value = sum(Quantity * UnitPrice)),
                  by = .(invoice = InvoiceNo, customer = CustomerID, country = Country)]

#rm(invoice)
str(invoices)

db_insert(invoices, 'invoices', 'ecommerce')

invoices <- db_query('SELECT * FROM invoices', 'ecommerce')
str(invoices)

invoices[, date := as.Date(date, origin = '1970-01-01')]
str(invoices)

## report "IN EXCEL" on daily revenue
revenue <- invoices[, .(revenue = sum(value)), by = date]
str(revenue)

library(openxlsx)
wb <- createWorkbook()
sheet <- 'Revenue'
addWorksheet(wb, sheet)
writeData(wb, sheet, revenue)
#openXL(wb)

freezePane(wb, sheet, firstRow = T)

poundstyle <- createStyle(numFmt = '£0,000.00')
addStyle(wb, sheet, poundstyle, 
         cols = 2, rows = 1:nrow(revenue),
         gridExpand = T, stack = T)

?conditionalFormatting

filename <- 'report.xlsx'
saveWorkbook(wb, filename, overwrite = T)

#you can do stufff on the cloud!
library(googledrive)
#interact with already useful sheets
library(googlesheets4)
