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

X <- model.matrix(~factor(gdp$Country.Code) + gdp$Year)

gdp_data <- list(
    N = nrow(gdp),
    K = ncol(X),
    y = gdp$Value,
    X = X
)

timer1 <- function() {
    start_time <- Sys.time()
    fit <- stan(
        file = 'stan/gdp_lm.stan',
        data = gdp_data,
        chains = 4,
        warmup = 1000,
        iter = 2000,
        cores = 4
    )
    stop_time <- Sys.time()
    
    list(time_elapsed = stop_time - start_time,
         fit = fit)
}

fit_gdp <- timer1()




# Bayesian missing data handling 

