library(dplyr)
url <- 'https://storage.googleapis.com/kagglesdsdata/datasets/2740284/4735453/GDP%20DATA.csv?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20230105%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20230105T190045Z&X-Goog-Expires=259200&X-Goog-SignedHeaders=host&X-Goog-Signature=43014317ebaf414ae8856579596cb07d41cad55868ba4e77e3787c3ca78e56c1315b8a896327dd7bac2ea0079b4d93c471fed317deaf3eeba2a67337c08df93cca07d5deaddfceb79855fe27f984992a4a28b8417dfd26712d835565005d229a453e7703bae24c14745f626a034a66643eeab5ea407b1add9b8ee4518587f018c28dd38e149d76303e5ef09929df6813f76d80b4958fb0a61e3481e38808d0e6b155f37b79d4d0f8c00b42fb0d88840546157f269cbc499db6fb8a3e100fbadffe834113b431b1a75f7f1bfbbacda6b5de430204b90bf456fc86323a9fb741765cec5715f245e8d4d3b4b7f924acc469ef7fade6862acfb29feec2d3bc1e48f8'
gdp <- read.csv(url, header = TRUE, skip = 2, na.strings = '')
codes <- c("AUS", 'USA', 'CHN', 'GBR', 'JPN', 'FRA', 'CAN', 'DEU')
gdp <- gdp %>% 
    select(Country.Code, starts_with('X')) %>% 
    filter(Country.Code %in% codes) %>%
    tidyr::pivot_longer(cols = starts_with('X'), 
                        names_to = 'Year', values_to = 'GDP',
                        names_prefix = 'X') %>%
    mutate(Year = as.numeric(Year),
           GDP = as.numeric(gsub(",", "", GDP)))


save(gdp, file = 'data/gdp.rds')
