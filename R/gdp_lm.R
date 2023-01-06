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
gdp_nomiss <- tidyr::drop_na(gdp)
plot(gdp_nomiss$Year, gdp_nomiss$GDP)

X <- model.matrix(~factor(gdp_nomiss$Country.Code) + gdp_nomiss$Year)

gdp_data <- list(
    N = nrow(gdp_nomiss),
    K = ncol(X),
    y = gdp_nomiss$GDP,
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
# 'DEU' is missing some GDP values near 1960
X <- model.matrix(~factor(gdp$Country.Code) * gdp$Year)
which_mis <- which(is.na(gdp$GDP))

gdp_mis_data <- list(
    N_obs = sum(!is.na(gdp$GDP)),
    N_mis = sum(is.na(gdp$GDP)),
    K = ncol(X),
    y_obs = gdp$GDP[-which_mis],
    X_obs = X[-which_mis, ],
    X_mis = X[which_mis, ]
)

fit_gdp_mis <- stan(
    file = 'stan/gdp_lm_mis.stan',
    data = gdp_mis_data,
    chains = 4,
    warmup = 1000,
    iter = 2000,
    cores = 8
)

summary(fit_gdp_mis)
