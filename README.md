
# Inference With R


This repository contains some practices and develops (under code) for working with statistical inference. For this I working with `infer` packages where the principal goal is to performance statistical inference using tidyverse (philosophy) under structure expressive statistical grammar and some rules on applications.


![](https://raw.githubusercontent.com/tidymodels/infer/master/figs/ht-diagram.png)

## Infer Package

`infer` [Package](https://cran.r-project.org/web/packages/infer/index.html) is a robust compendium of developments in computational statistics that which allows to develop understanding under the focus of hypothesis testing.


## Installation

To install the current stable version of `infer` from CRAN:

``` r
install.packages("infer")
```

To install the developmental version of `infer`, make sure to install
`remotes` first. The `pkgdown` website for this developmental version is
at <https://infer.netlify.com>.

``` r
install.packages("remotes")
remotes::install_github("tidymodels/infer")
```

To install the cutting edge version of `infer` (do so at your own risk),
make sure to install `remotes` first.

``` r
install.packages("remotes")
remotes::install_github("tidymodels/infer", ref = "develop")
```

To see the things we are working on with the package as
vignettes/Articles, check out the developmental `pkgdown` site at
<https://infer-dev.netlify.com>.


### Introduction

From : <https://github.com/tidymodels/infer/blob/master/vignettes/infer.Rmd>

`infer` implements an expressive grammar to perform statistical inference that coheres with the `tidyverse` design framework. Rather than providing methods for specific statistical tests, this package consolidates the principles that are shared among common hypothesis tests into a set of 4 main verbs (functions), supplemented with many utilities to visualize and extract value from their outputs.

> Regardless of which hypothesis test we're using, we're still asking the same kind of question: is the effect/difference in our observed data real, or due to chance? 

To answer this question, we start by assuming that the observed data came from some world where "nothing is going on" (i.e. the observed effect was simply due to random chance), and call this assumption our *null hypothesis*. (In reality, we might not believe in the null hypothesis at all---the null hypothesis is in opposition to the *alternate hypothesis*, which supposes that the effect present in the observed data is actually due to the fact that "something is going on.") We then calculate a *test statistic* from our data that describes the observed effect. We can use this test statistic to calculate a *p-value*, giving the probability that our observed data could come about if the null hypothesis was true. If this probability is below some pre-defined *significance level* $\alpha$, then we can reject our null hypothesis.

The workflow of this package is designed around this idea. Starting out with some dataset,

+ `specify()` allows you to specify the variable, or relationship between variables, that you're interested in.
+ `hypothesize()` allows you to declare the null hypothesis.
+ `generate()` allows you to generate data reflecting the null hypothesis.
+ `calculate()` allows you to calculate a distribution of statistics from the generated data to form the null distribution.

Throughout this vignette, we make use of `gss`, a dataset supplied by `infer` containing a sample of 3000 observations sampled from the *General Social Survey*. 











### Contributing

-----

We welcome others helping us make this package as user friendly and
efficient as possible. Please review our
[contributing](https://github.com/tidymodels/infer/blob/develop/CONDUCT.md)
and [conduct](CONDUCT.md) guidelines. Of particular interest is helping
us to write `testthat` tests and in building vignettes that show how to
(and how NOT to) use the package. By participating in this project you
agree to abide by its terms.
