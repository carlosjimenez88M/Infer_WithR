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


## Boostrapping ------------
# Metric that  riles  on a random samples with replacement.
# Allows assigning measueres of accuracy 
#   * bias
#   * variance 
#   * Confidence intervals
# This technique allows estimation of the sampling distribution of almost any statistic using random sampling methods

# Assume the data is representative
# Pulling oneself uo by ones bootstraps
# Calculate the bootstrap statistc mean, median, proportion , compute on the boostrap samples
 
# Example 

speal_med_ci<-iris%>%
  specify(response = Sepal.Length)%>% # Variable of interest
  generate(reps = 10000, type = "bootstrap")%>% # Generate boostrap samples
  calculate(stat = "median") # Calculate bootstrap statistics

# With this distribution I can create confidense intervale 

speal_med_ci%>%
  ggplot(aes(stat))+
  geom_histogram(bins = 10)



## Calculate bootstrap interval 

#standar error method

#$ sample statistc +- t_{df=n-1} * SE_{boot}$
# Where SE_{boot} is the standar deviation of the boostrap distibution

speal_med_ci%>%
  summarize(
    l=quantile(stat,0.025),
    u=quantile(stat,0.975)
  )



sepal_med_obs<-iris%>%
  summarize(sepal_median=median(Sepal.Length))%>%
  pull()

## Calculate the dregrees of freedom

degrees_of_fredom <- nrow(iris)-1

## Critical Values


t_star <-qt(0.975,df=degrees_of_fredom )



## 
# Calculate the CI using the std error method

speal_med_ci%>%
  summarize(boot_se=sd(stat))%>% ##  std error
  summarize(
    l=sepal_med_obs - t_star * boot_se,
    u = sepal_med_obs + t_star * boot_se,
  )



## Exercise
openintro::ncbirths->data

## Filter non.missing visits 

ncbirths_complete_visits<-data%>%
  filter(!is.na(visits))


## Generate 15000 bootstrap 

visit_mean_ci<-data%>%
  specify(response = visits)%>%
  generate(reps = 15000,type = "bootstrap")%>%
  calculate(stat = "mean")


## Calculate the 90% CI via percentile methd 


visit_mean_ci%>%
  summarize(
    low=quantile(stat,0.05),
    upper=quantile(stat,0.95)
  )

visit_sd_ci <- ncbirths_complete_visits %>%
  specify(response = visits) %>%
  generate(reps = 15000,type = "bootstrap") %>%
  calculate("sd")
## 90% CI
visit_sd_ci%>%
  summarize(
    l=quantile(stat,0.05),
    u=quantile(stat,0.95)
  )



## Re centering a bootstrap distrution for Hypothesis testing ------

# Null Hhypothesis is true (assumption)
# Bootstrap distribution are by design centeres at the observed sample statistic.
# When the hypothesis distribution is true we shift the bootstrap distribution
# to be centered at the null value.

# The p-value is then defined as the proportion of simulations that yeild a sample


 
## Excercise

n_replicates <- 15000

# Generate 15000 bootstrap samples centered at null
rent_med_ht <- manhattan %>%
  specify(response = rent) %>%
  # Use a point hypothesis with a median of 2500
  hypothesize(null = "point", med = 2500) %>% 
  generate(reps = n_replicates, type = "bootstrap") %>% 
  calculate(stat = "median")




rent_med_obs <- manhattan %>%
  # Calculate observed median rent
  summarize(median_rent = median(rent)) %>%
  # Pull out the value
  pull()

# Calculate the p-value as the proportion of bootstrap statistics greater than the observed statistic.

rent_med_ht %>%
  # Filter for bootstrap stat greater than or equal to observed stat
  filter(stat >= rent_med_obs) %>%
  # Calculate the p-value
  summarize(p_val = n() / n_replicates)


## Execice

n_replicates <- 1500

weight_mean_ht <- data %>%
  # Specify weight as the response
  specify(response = weight) %>%
  # Set the hypothesis that weights are 7 pounds
  hypothesize(null = "point",mu = 7)%>% 
  # Generate 1500 bootstrap replicates
  generate(reps = n_replicates, type = "bootstrap" ) %>% 
  # Calculate the mean
  calculate("mean")


weight_mean_ht


# Calculate observed mean
weight_mean_obs <- data %>%
  # Summarize to calculate the mean observed weight
  summarize(mean_weight = mean(weight)) %>% 
  # Pull out the value
  pull()


weight_mean_obs


# Calculate p-value
weight_mean_ht %>%
  # Filter on stat greater than or equal to weight_mean_obs
  filter(stat >= weight_mean_obs) %>%
  # p_val is twice the number of filtered rows divided by the total number of rows
  summarize(
    one_sided_p_val = n() / n_replicates,
    two_sided_p_val = one_sided_p_val *2
  )





