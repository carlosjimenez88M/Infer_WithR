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


# t-interval for paired data


# As the sample size increases, the margin of error of the interval increases as well.




## Testing a mean with a t-test ---------
openintro::textbooks->textbooks
#Suppose instead of the mean, we want to estimate the median difference in prices of the same textbook at the UCLA bookstore and on Amazon. 
#You can't do this using a t-test, as the Central Limit Theorem only talks about means, not medians. You'll use an infer pipeline to estimate the median.

hsb2<-hsb2%>%
  mutate(diff=math - science)


n_replicates <- 15000

# Generate 15000 bootstrap medians centered at null
scorediff_med_ht <- hsb2 %>%
  specify(response = diff) %>%
  hypothesize(med = 0, null = "point") %>%
  generate(reps = n_replicates,type = "bootstrap") %>% 
  calculate("median")
   
scorediff_med_ht


#The probability of getting a random sample of 200 high school students where the median difference between their math and science test scores is at least 1, if in fact there is no difference between the median math and science scores.

## Does a treatment using embryonic stem cells help improve heart function following a heart attack more so than traditional therapy?

openintro::stem.cell->stem.cell


## Calculate changes 

stem.cell%>%
  mutate(change= after - before )

## Create Hypothesis 

# H0: \mu_{esc} = \mu_{control} There is no difference between average change in treatment and control groups
# HA: \mu_{esc} > \mu_{control} There is difference between average change in treatment and control groups


## Conduct the hypotesis test


#Write the values of change on 18 index cards.
#(1) Shuffle the cards and randomly split them into two equal sized decks: treatment and control.
#(2) Calculate and record the test statistic: difference in average change between treatment and control.
# Repeat (1) and (2) many times to generate the sampling distribution.
# east as extreme as the observed difference in sample means.
# Calculate P-value


# From previous step
stem.cell <- stem.cell %>%
  mutate(change = after - before)

# Calculate observed difference in means
diff_mean <- stem.cell %>%
  # Group by treatment group
  group_by(trmt) %>%
  # Calculate mean change for each group
  summarize(mean_change = mean(change)) %>% 
  # Pull out the value
  pull() %>%
  # Calculate difference
  diff()

# See the result
diff_mean



n_replicates <- 1000

# Generate 1000 differences in means via randomization
n_replicates <- 1000

# Generate 1000 differences in means via randomization
diff_mean_ht <- stem.cell %>%
  # y ~ x
  specify(change ~ trmt) %>% 
  # Null = no difference between means
  hypothesize(null = "independence") %>%  
  # Shuffle labels 1000 times
  generate(reps = 1000, type = "permute") %>% 
  # Calculate test statistic
  calculate(stat = "diff in means", order = c("esc", "ctrl")) 




diff_mean_ht %>%
  # Filter for simulated test statistics greater than observed
  filter(stat >= diff_mean) %>%
  # Calculate p-value
  summarize(p_val = n() / n_replicates)


# The data provide convincing evidence of a difference


## Exercice

ncbirths_complete_habit <- openintro::ncbirths %>%
  filter(!is.na(habit))

# Calculate observed difference in means
diff_mean_obs <- ncbirths_complete_habit %>%
  # Group by habit group
  group_by(habit) %>%
  # Calculate mean weight for each group
  summarize(mean_weight = mean(weight)) %>%
  # Pull out the value
  pull() %>%
  # Calculate the difference
  diff() 



n_replicates <- 1000

# Generate 1000 differences in means via randomization
diff_mean_ht <- ncbirths_complete_habit %>% 
  # Specify weight vs. habit
  specify(weight ~habit) %>% 
  # Null = no difference between means
  hypothesize(null = "independence") %>% 
  # Shuffle labels 1000 times
  generate(reps = n_replicates, type = "permute") %>%
  # Calculate test statistic, nonsmoker then smoker
  calculate(stat = "diff in means",order =c( "nonsmoker","smoker"))



# Calculate p-value
diff_mean_ht %>%
  # Identify simulated test statistics at least as extreme as observed
  filter(stat <= diff_mean_obs) %>%
  # Calculate p-value
  summarize(
    one_sided_p_val = n() / n_replicates,
    two_sided_p_val = 2 * one_sided_p_val
  )



## Bootstrap CI for difference in two means ---------------

# 1. Take a bootstrap sample of each sample - a random sample taken with replacement from each of the original samples, of the same size as each of the original samples.
# 2.Calculate the bootstrap statistic - a statistic such as difference in means, medians, proportion, etc. computed based on the bootstrap samples.

# 3.Repeat steps (1) and (2) many times to create a bootstrap distribution - a distribution of bootstrap statistics.

# 4. Calculate the interval using the percentile or the standard error method.








