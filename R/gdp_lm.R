library(rstan)
load('data/gdp.rds')
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# simple regression on year for USA only
usa <- gdp[gdp[, 'Country.Code'] == 'USA', ]
plot(usa$Year, usa$Value)

usa_data <- list(
    N = nrow(usa),
    x = usa$Year,
    y = usa$Value
)

fit_usa <- stan(
    file = 'stan/usa.stan',
    data = usa_data,
    chains = 4,
    warmup = 1000,
    iter = 2000,
    cores = 1
)

# multiple regression on year and country
plot(gdp$Year, gdp$Value)

# Bayesian missing data handling 