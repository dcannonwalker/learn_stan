library(rstan)
load('data/gdp.rds')
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

# simple regression on year for USA only
usa <- gdp[gdp[, 'Country.Code'] == 'USA', ]
plot(usa$Year, usa$GDP)

usa_data <- list(
    N = nrow(usa),
    x = usa$Year,
    y = usa$GDP
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
plot(gdp$Year, gdp$GDP)

X <- model.matrix(~factor(gdp$Country.Code) + gdp$Year)

gdp_data <- list(
    N = nrow(gdp),
    K = ncol(X),
    y = gdp$GDP,
    X = X
)

fit_gdp <- stan(
    file = 'stan/gdp_lm.stan',
    data = gdp_data,
    chains = 4,
    warmup = 10000,
    iter = 20000,
    cores = 4
)




# Bayesian missing data handling 

