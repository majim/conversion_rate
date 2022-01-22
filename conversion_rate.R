rmarkdown::render("conversion_rate.R")

#' ---
#' title: "Currency conversion from historical data"
#' author: "Angeles Jimenez"
#' date: "22 01 2022"
#' ---
#'priceR includes access to a currency conversion API. Convert local currencies to EURO using historical conversion rates. In this example, I convert a dataframe from different currencies into Euro based on historical EURO conversion rate in 2019

library(priceR)
library(tidyverse)


#Data frame
df <- data.frame(
    currency = c("NZD", "NZD", "NZD", "NZD", "NZD", "EUR", "SEK", "EUR"),
    price = c(580.9, 539.75, 567.8, 802, 486, 365, 5088, 111)
)

#Function to pull conversions
avg_ex <- function(x){
    historical_exchange_rates(x, to = "EUR",start_date = "2019-01-01", end_date = "2019-12-31") %>%
        `colnames<-`(c('date','conv')) %>% summarise(mean(conv)) %>% as.numeric
}

#Apply across all needed
conversions = sapply(unique(df$currency),avg_ex) %>% data.frame() %>% rownames_to_column() %>%
    `colnames<-`(c('currency','conv'))

#Join and convert
df <- df %>% left_join(conversions,by='currency') %>%
    mutate(price_euro = price*conv)

#+ fig.width=5, fig.height=5
print(df)


