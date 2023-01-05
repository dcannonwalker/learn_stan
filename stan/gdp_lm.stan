data {
  int<lower=0> N;
  int<lower=0> K;
  vector[N] y;
  matrix[N, K] X;
}

parameters {
  vector[K] beta;
  real<lower=0> sigma;
}

model {
  y ~ normal(X * beta, sigma);
}