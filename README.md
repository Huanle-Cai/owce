owce: Overlap Weighting for Continuous Exposures

An R package implementing the OWCE method for causal inference with continuous exposure.

Installation

You can install the development version from GitHub:

install.packages("devtools")
devtools::install_github("Huanle-Cai/owce")


Usage Example

library(owce)

set.seed(123)
data <- data.frame(
  X1 = rnorm(200),
  X2 = rnorm(200)
)
data$E<-data$X1+data$X2+rnorm(200)

result <- owce_weight(data)
head(result)


Function Details

owce_weight(data)
- Fits a generalized propensity score (GPS) using linear regression
- Supports single or multiple covariates
- Returns a data frame with:
  mu: predicted GPS mean
  ex: conditional density of exposure
  ipw_weight: inverse probability weight
  overlap_weight: final OWCE overlap weight
