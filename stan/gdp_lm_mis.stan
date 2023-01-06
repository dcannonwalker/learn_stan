data {
  int<lower=0> N_obs;
  int<lower=0> N_mis;
  int<lower=0> K;
  vector[N_obs] y_obs;
  matrix[N_obs, K] X_obs;
  matrix[N_mis, K] X_mis;
}

parameters {
  vector[K] beta;
  real<lower=0> sigma;
  vector[N_mis] y_mis;
}

model {
  y_obs ~ normal(X_obs * beta, sigma);
  y_mis ~ normal(X_mis * beta, sigma);
} 

