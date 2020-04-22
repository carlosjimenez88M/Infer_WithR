# =======================================
# =        Boostrap and estimate        =
# =           Daniel Jiménez            =
# =         Senior Data Scientist       =
# =             2020-04-21              =
# =======================================


## Libraries  ---------------
library(tidyverse);
library(moderndive);
library(infer);
theme_set(theme_classic())

## t- distribution -----------
# One method for inference on numerical data is simulations 
# When the parameter of interest is the mean or a difference two means and certain 
# Is possoble used the method bases on the central limit theorem for conducting inference


# The t- distribution is used when the sample mean population, sd and sigma is unknown
# t- distribution is bell shaped but has thiucker tails the normal.
# In t distribution  the observations more likely to fall beyond 2 sd from the mean 
# t distribution allways centered at cero
# has one parameter : degrees of freedom - deerminates thickness of tails 
# When incrememnt degrees of freedom then t-dist is most similar to normal distribution





# P(T < 3) for df = 10
(x <- pt(3, df = 10))

# P(T > 3) for df = 10
(y <- 1 - x)

# P(T > 3) for df = 100
(z <- 1 - pt(3, df = 100))

# Comparison
y == z
y > z
y < z



# 95th percentile for df = 10
(x <- qt(0.95, df = 10))

# Upper bound of middle 95th percent for df = 10
(y <- qt(0.975, df = 10))

# Upper bound of middle 95th percent for df = 100
(z <- qt(0.975, df = 100))

# Comparison
y == z
y > z
y < z



## Estimating a mean with a t-interval ---------

# Central limit Theorem
#$\hat{x} ~ N(mean=\mu,SE=\frac{\lambda}{\sqrt(n)})$
# Where :
# Standard error = sd of the sampling distribution.
# But \lambda is unknow, the standad error is estimated by the standard
# deviation of the sample dividided by sqrt root of the sample 
# $SE=\frac{s}{\sqrt(n)}$
# And additional uncertainty introduced by sample standar deviation
# $t_{df=n-1}$ for inference mean 

## Conditions 
# 1. Independent observations : Random Sampling with replacement <10%
# 2. Sample size / skew :The more skewed the original population distribution
# the larger a sample seze need 



t.test(gss$hours,conf.level = 0.95)

# Here says : 95%  confident that average number of hours per month American 
# Hours works extra hours beyod theris usual schedule is 40

openintro::acs12->acs12

## Filter employed 
acs12_emp <- acs12 %>%
  filter(employment=="employed")

## CI 95%

t.test(acs12_emp$time_to_work,conf.level = 0.95)



## Other t test
t.test(acs12_emp$hrs_work,conf.level = 0.95)
# For this analysis, it would have made more sense to use a subset excluding part time workers.
