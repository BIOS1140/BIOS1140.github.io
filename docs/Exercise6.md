# Multilocus Evolution {#ch06}





In this tutorial, we are going to first go through some tips on how to compare groups in R, and learn the basics of using analysis of variance or ANOVA. We will learn how ANOVA is used to determine whether the means of groups are significantly different from one another. We will then see an example of sophisticated use of ANOVA in evolutionary genetics by performing a QTL analysis using the package `qtl`. To do this, we will use data from an F2 cross experiment on the common bed bug *Cimex lectularius* conducted by Fountain et al. Finally we will return to ANOVA in order to demonstrate that such an approach underlies our QTL analysis. There are some quite advanced R analyses here but we have taken the time to break things down and explain them in detail.

### What to expect {.unnumbered}

In this tutorial we will:

-   learn some R-tricks for investigating differences between groups
-   learn to test for differences between groups with ANOVA
-   perform a QTL analysis on pesticide resistance in bedbugs
-   verify our QTL analysis with ANOVA

The evolutionary biology-part of the tutorial makes heavy use of the `qtl` package. You will see a lot of functions you have never seen before, and that are specific to working with a particular kind of data. You don't need to understand exactly how these functions work, but you should have a general understanding of what they do. Sometimes additional information is provided in the footnotes. Remember that you can always access function help pages with `?`.

### Getting started {.unnumbered}

The first thing we need to do is set up the R environment. Today we'll be using the `tidyverse` package once again but we will also use another package called `qtl`. First we will need to install this new package. (Remember that you only need to do this once, so you can comment out or delete the line below after installing).


```r
install.packages("qtl")
```

Once it is installed, we will clear the R environment with `rm(list = ls())` [^exercise6-1] and then load the two packages.

[^exercise6-1]: Note that clearing the R environment when you start a script is good practice to make sure you don't have any conflicts with previously loaded data.


```r
# clear the R environment
rm(list = ls())
library(tidyverse)
library(qtl)
```

## Tools for investigating differences between groups

Comparing traits between different groups is an important part of evolutionary biology (and biology as a whole). For example, you often want to compare traits in different species, or different genotypes or sexes within a species. This section will teach you some R and statistics tools to do this.

### Exploring group differences

For this section, we will use the `iris` data set, which is built in with your R installation. The data are already in R, so you can look at it by running:


```r
iris
```

Take a look at the `iris` dataset. The data frame contains four measurements (`Sepal.Length`, `Sepal.Width`, `Petal.Length` and `Petal.Width`) and also a fifth column, `Species` which lets us know the species for each observation. For our investigation, we will use species as a grouping (as it's the only group present in the data).

#### Investigating with dplyr

A great tool for working with groups is (perhaps unsurprisingly) the `group_by()` function in `dplyr` that you learned about in the [second week](#w02) of this course. We can for example count the number of observations of each species with `group_by()` and `tally()`:


```r
iris %>%
  group_by(Species) %>%
  tally()
#> # A tibble: 3 × 2
#>   Species        n
#>   <fct>      <int>
#> 1 setosa        50
#> 2 versicolor    50
#> 3 virginica     50
```

We can see that we have 50 observations of each species. As you may remember, `group_by()` can also be used together with `summarise()` to produce grouped summaries. Say we want to find the mean petal length of each group, we can run:


```r
iris %>%
  group_by(Species) %>%
  summarise(mean_petal_length = mean(Petal.Length))
#> # A tibble: 3 × 2
#>   Species    mean_petal_length
#>   <fct>                  <dbl>
#> 1 setosa                  1.46
#> 2 versicolor              4.26
#> 3 virginica               5.55
```

There appears to be a difference in petal length between species. To investigate further, we can also calculate multiple values in a single `summarise()`, e.g., median and standard deviation.


```r
iris %>%
  group_by(Species) %>%
  summarise(mean_petal_length = mean(Petal.Length),
            median_petal_length = median(Petal.Length),
            sd_petal_length = sd(Petal.Length))
#> # A tibble: 3 × 4
#>   Species    mean_petal_length median_petal_length sd_petal_length
#>   <fct>                  <dbl>               <dbl>           <dbl>
#> 1 setosa                  1.46                1.5            0.174
#> 2 versicolor              4.26                4.35           0.470
#> 3 virginica               5.55                5.55           0.552
```

Remember that the argument names to `summarise()` could be anything, and end up as the column names of your new data frame.

#### Visualising differences

Looking at numbers like we did above is well and good, but good visualisations can often tell you more than summary statistics. A good way of visualising group differences is with a boxplot. This can be plotted in ggplot by adding `geom_boxplot()`:


```r
ggplot(iris, aes(Species, Petal.Length)) +
  geom_boxplot()
```

<img src="Exercise6_files/figure-html/unnamed-chunk-8-1.png" width="672" />

A boxplot can be a bit difficult to read if you've never seen one before, but here are the key features:

-   The thick line in the middle of the box is the median
-   The boundaries of the box are the 1st and 3rd quartile, i.e., half of your data is contained within the box[^exercise6-2]
-   The lines outside the box are the range of non-outlier data, and the points are outliers

[^exercise6-2]: Remember that in `ggplot2`, we can add more layers of geometry if we want to add information to our visualisation. Below, I've added points to the boxplot to show that half of the points are indeed located within the boundaries of the box.

    
    ```r
    ggplot(iris, aes(Species, Petal.Length)) +
      geom_boxplot() +
      geom_jitter() # geom_jitter to prevent points from overlapping
    ```
    
    <img src="Exercise6_files/figure-html/unnamed-chunk-9-1.png" width="672" />

A boxplot is good at showing the distribution in the data. From this plot, we can see that the species obviously differ in this trait. But how large differences do we need to make confident conclusions? This is where statistic testing comes in[^exercise6-3].

[^exercise6-3]: Like in Section 2.2 in week 3, where we tested for deviations from the Hardy-Weinberg expectation with a Chi-squared test.

### Analysis of variance (ANOVA)

#### What is ANOVA?

Analysis of variance or ANOVA is the name given to a family of statistical tests which we can use to test the differences among means from a sample. If you are familiar with a **t-test**, it is similar in the sense that it allows you to compare means; however unlike a t-test, ANOVA allows a comparison among multiple groups rather than just two. ANOVA and its related tests are also often referred to as **linear models** in R.

ANOVA and linear models are actually a very important group of tests and we employ them regularly in evolutionary biology. Indeed, ANOVA is essentially the basis of the QTL analysis which we will perform during the latter part of the tutorial. ANOVA also has another link to evolutionary biology - it was developed by [R.A Fisher](https://en.wikipedia.org/wiki/Ronald_Fisher) who was part of the [modern synthesis](https://en.wikipedia.org/wiki/Modern_synthesis_(20th_century)) of population genetics and evolutionary theory.

#### Using ANOVA to test for differences between groups

We can see from our boxplot that there appears to be some difference in petal length between species. Using ANOVA, we can formally test this. ANOVA is essentially a way to test whether the **means** of different groups are equal. Another way of putting it is that we're testing if the variation **between groups** is larger than variation **within groups**.

To conduct an ANOVA in R, we will use the function `aov()` to create an object we will call `model`:


```r
model <- aov(Petal.Length ~ Species, data = iris)
```

Above, we used a formula as our first argument `Petal.Length ~ Species`[^exercise6-4]. This is essentially like saying, "How does petal length vary with species"? This part of our argument to `aov` specifies what we are actually testing. We also added `data = iris` to specify that we are using the `iris` data for this calculation.

[^exercise6-4]: The character `~` is called "tilde", in case you want to google how to produce it on your keyboard. In general, the tilde can be read as "modeled by", in this case "petal length modeled by species".

Next we can examine the output of our model, to get an understanding of what it shows. To do this, we need to use a special function, `summary()`:


```r
summary(model)
```

By using `summary`, we return an ANOVA table. The first row of the table is for `Species`. The two last values in this row are an **F** statistic and a **p-value**. We will return to what the F statistic actually means in a short while.

Let's focus instead on the *p*-value. This is essentially a way of determining whether the results we see could be explained by chance. It is a test of **significance** --- we did something similar with the Chi-squared test back in Chapter 3. In the biological sciences, we have an arbitrary cutoff for a *p*-value, set at 0.05. If our *p*-value is lower than this, then we can say that our dependent variable is significantly different among the groups.

Here we can see that our *p*-value is small---less than 2 x 10^-16^---which tells us that petal length is **signficiantly different** between species. The asterisks after the *p* value are also there to tell us this - `***` simply means that our *p*-value is close to zero.

#### ANOVA and the proportion of variance explained

So far, we have learned about ANOVA in it's simplest form - i.e. to test for differences among means. But this is not the only way we can think about it and the clue is in the name - it analyses **variance**. What do we mean by this? To illustrate it, let's have a look at the **total** distribution of `Petal.Length` from the `iris` data. We can do this using a histogram (with `geom_histogram()`[^exercise6-5]).

[^exercise6-5]: Note how `geom_histogram()` only uses a single aesthetic (x). `ggplot` makes the y-axis for you, by counting the number of observations in each bin.


```r
ggplot(iris, aes(Petal.Length)) + geom_histogram()
```

<img src="Exercise6_files/figure-html/unnamed-chunk-12-1.png" width="672" />

So, this time we are visualising petal length for all species grouped as one. Imagine for a moment you **didn't know** that we have three species in our dataset. It is pretty obvious from this plot that there is a lot variation in petal length - there appear to be at least two and maybe three peaks in the data.

What might explain why there is so much variation? Well of course, we know there are actually three species included in these measurements. So, if we split our dataset into different species, can that **explain the variance we observe**? This is another way to think of ANOVA - as way of measuring the variance explained by how we split up the dataset.

So this brings us back to the **F** statistic. It is essentially a ratio of the variance explained by our grouping to the variance that occurs within each of them. One way to think of this is that the higher the value of *F*, the more likely our grouping explains a significant proportion of the variance in our data.

What if we want to actually measure how much variance our grouping (species here) actually explains. Luckily, this is very straightforward. We can look at a slightly different output from the `model` object we created earlier by using the function `summary.lm()`.


```r
summary.lm(model)
```

There is a lot of information here! However, you should focus on the last two lines of the output. On the very last line, you will see the *F* statistic and *p*-value from when we called `summary(model)`. Above that are two values of another statistic called the **R-squared** or *R*^2^.

Our *R*^2^ is 0.94 which essentially means that by grouping our data by species, we explain 94% of the variance in petal length. So clearly, species has a very important role in explaining the morphological differences in our data. One biological explanation for this is that genetic basis for petal length might be different between the species. We will see in the next section how we can apply a more advanced version of ANOVA to actually determine the genetic basis of a trait.

## Performing a QTL analysis in bedbugs

### Bedbugs, pesticide resistance and study design

We are going to use the `qtl` package in R to perform a basic QTL analysis on pesticide resistance on an **F2 intercross** in bedbugs, *Cimex lectularius*. A QTL analysis is a method for identifying the genes that underlie a specific phenotypic trait. For information on the principles behind a QTL analysis, have a look at section 6.3.4 in the textbook. Note that all the data we use here come from [Fountain et al (2016)](http://www.g3journal.org/content/6/12/4059).

Bed bugs are an human ectoparasite that have experienced a population boom in the last two decades. They are nasty things, so a lot of research has focused on using pesticides to control them. However, some bedbug populations have evolved pesticide resistance, particularly to the most commonly used pyrethroid insecticide.

In their study, Fountain et al crossed two strains of bedbugs. one resistant to the pesticide and the other susceptible. Using a resistant female and susceptible male, they created an F1 generation and then crossed two randomly selected F1 offspring, ultimately producing 90 F2 individuals. They then exposed the F2s to pytheroid insecticide and scored their resistance to it. The pesticide disrupts motor function, so F2s were scored either as susceptible (unable to right themselves if turned over), partially resistant (able to right themselves but walk with some difficulty) and resistant (walk normally, no apparent effect on motor control).

The two grandparents, the two F1 parents and the 90 F2s were then genotyped using RAD-sequencing. RAD-sequences were mapped to a draft bedbug genome and then SNPs were called from 12 962 RAD tags. With this data we can perform a QTL analysis to identify the areas of the bedbug genome that are associatied with resistance to the pesticide.

#### Reading in the bedbug data

First we need to download the data, which is [here](https://bios1140.github.io/data/bedbugs_cross_data.csv)

Since we loaded the `qtl` package at the start of the tutorial, we can now read in the data using the `read.cross()` function.

::: {.yellow}

```r
bedbugs <- read.cross(format = "csv", dir = "",
                      file = "./bedbugs_cross_data.csv", 
                      genotypes = c("AA", "AB", "BB"), 
                      estimate.map = FALSE)
```
:::



When you run this command, you will see that we read in the data from 71 individuals and 334 markers. Strangely, there are only two phenotypes here. This isn't right, there should be three (susceptible, partially resistant, resistant), so we will need to correct this later. As mentioned in the introduction, the specifics of the functions in the `qtl` package, like `read.cross()`, are not that important at this point, but see the footnotes for some details.[^exercise6-6]

[^exercise6-6]: Let's break down what we did here - we used `qtl`'s `read.cross` function to read in our cross data. We specified the format as a comma-separated variable file, we specified the directory the data is in (left blank here because it is in the same directory we are working in) and also the path to the file.

    We also specified how our genotypes are encoded using the `genotypes` argument and importantly, we specified `estimate.map = FALSE` to ensure that we are only reading in the data and not creating a linkage map at this stage. It is worth noting at this point that `qtl` is an extremely powerful and complex package with a lot of options and functions. At the end of the tutorial, we will point you towards other resources that can help you learn more about it, but for now we can ignore these options. However if you are interested in learning a little more, you can learn more about these arguments by looking at the help like so: `?read.cross`.

Try typing in `bedbugs` to see what you get in the R console. You'll see a lot of summary information on the cross object we created when we read in the data. Again, it says there are only 2 phenotypes...

#### Correcting the phenotypes

So, we need to correct the phenotypes. Let's first take a look at what is stored so far. The stucture of `bedbugs` is rather complex, but we can look at the stored values with `$`, as we would for a data frame.


```r
# look at the phenotypes
bedbugs$pheno
```

Aha, the reason R says there are 2 phenotypes is because there are two columns in the phenotype data.frame - one called `id` and the other called `res`.[^exercise6-7] This second variable is the resistance (i.e. S = susceptible, PR = partially resistant and R = resistant). We can extract the `res` column from `bedbugs$pheno` using *an additional* `$`, and store this to an object.

[^exercise6-7]: Incidentally, how did we know to use `$pheno` to access the phenotypic data? Using the `objects` function on the `bedbugs` object - i.e. `objects(bedbugs)` will give us a rundown of what we can access inside.


```r
# Assign resistance as an environmental variable
res <- bedbugs$pheno$res
```

#### Examining the linkage map

A linkage map is the position of markers in the genome in terms of their recombination distance from one another - i.e. how many recombination events occur between them. Lets take a look at a summary of the linkage map. Note that sometimes, a linkage map is also referred to as a **genetic map**.


```r
# examing the bedbug linkage map
summaryMap(bedbugs)
```

This returns a `data.frame` where each row is a linkage group. A linkage group is all the genes on one chromosome - so each row here is one chromosome. The four columns are:

*`n.mar` - the number of markers* `length` - the length of the linkage group in centimorgans (see below) *`ave.spacing` - the average spacing between markers (in centimorgans)* `max.spacing` - the maximum spacing between markers (in centimorgans)

We can see that that the 334 markers are spread across 14 linkage groups. Spacing of markers here is shown in **centimorgans** and the total length of the linkage map is 407 cM. Recall that a single centimorgan represents the probability of 0.01 that a recombination event occurs in one generation. Alternatively you could think of it as one recombination event every 100 generations.

Next we can take a look at the linkage map itself.


```r
plotMap(bedbugs, show.marker.names = FALSE, main = "Bedbug linkage map")
```

<img src="Exercise6_files/figure-html/plot_map-1.png" width="672" />

This is a visualisation of the data from the summary table - i.e. it is the spacing and distribution of markers. There are 14 groups and we see the markers laid out on each of them. The further apart the markers are, the greater the probability that there will be a recombination event between them.

#### Performing a QTL analysis

With the linkage map in place, we can now attempt to actually map out pesticide resistance. Let's take a look at the distribution of phenotypes.


```r
# make a data.frame of the phenotype data
pheno <- data.frame(res)
ggplot(pheno, aes(res)) + geom_bar()
```

<img src="Exercise6_files/figure-html/examine_pheno-1.png" width="672" />

You can see from this that majority of the F2 generation were susceptible to pyrethroid and that only a small number were partially resistant. When we perform a QTL mapping experiment, we are essentially looking for the genome region that can describe the greatest percentage of the variance in this phenotypic distribution.

Before beginning mapping, we need to perform one quick fiddle with our code. `qtl` requires that the phenotype is encoded as a number, so we use the following command to change our resistance coding to numbers.


```r
# convert to numeric data
bedbugs$pheno$res <- as.numeric(res)
# examine the results
bedbugs$pheno$res
```

We're now good to go! To perform the analysis, we will use the `scanone` function like so:


```r
bedbugs_scan <- scanone(bedbugs, pheno.col = 2)
```

You might see a warning here, but don't worry too much about that since we are only looking at a simple example. So what exactly have we just done? Using the `scanone` function, we ran a QTL analysis across the entire set of markers and looked for an association between the genotypes at a marker and the phenotype. This is more or less an ANOVA, but we will return to that shortly. For now, let's take a closer look at the results:


```r
summary(bedbugs_scan, threshold = 3)
```

Calling `summary` on the scan object shows us a single marker on linkage group 12 (referred to a chromsome here) at 21.9 cM may be a QTL. It also returns something called a `lod` - this is a LOD score and for this marker it is 6.84. Side note: The `threshold = 3` argument told R to only show markers with a LOD score of more than 3. Try removing the argument and see what happens!

Let's plot the LOD distribution to get a better idea of what is going on.


```r
plot(bedbugs_scan, col = "red")
```

<img src="Exercise6_files/figure-html/plot_scan-1.png" width="672" />

You can see quite clearly that whatever the LOD is, it is much higher on linkage group 12 and this peak focuses right where our marker is. This suggests a strong association between genotypes here and the phenotype in question.

::: {.blue}
**What do we mean by a LOD score?**\
It is beyond the scope of the tutorial to go in to too much detail about this, but LOD stands for logarithim of the odds ratio. It is essentially the ratio between a model where a QTL exists at a marker and one where there is no QTL at all. So, if a LOD is 0 or close to 0, then there is essentially no evidence a QTL is present. However, if a QTL is present and explains variance in the phenotype then the LOD score is expected to be higher, as it is at this marker. For more info on LOD scores, see section 6.3.4 in the textbook.
:::

### Linking ANOVA to our QTL analysis

Now that we have performed a QTL analysis and learned about ANOVA, we will try to bring the two together to demonstrate how they are closely related... as well as demonstrating the importance of statistics in evolutionary genetics!

#### Exploring the phenotype-genotype association

A good way to summarise this data is to see it in a table. The following code summarises the association between different geno- and phenotypes for our locus. [^exercise6-8]

[^exercise6-8]: This code extracts the phenotype information and also the marker information for the QTL and used the function `factor` to turn them in to `factor` variables - where there is a label for each category of the data. We then made everything into a `data.frame` for later.

::: {.yellow}

```r
# pheno - 1 is partially resistant, 2 is resistant, 3 is susceptible
phenotype <- factor(bedbugs$pheno$res, labels = c("partial resistance", "resistant", "susceptible"))
phenotype <- fct_relevel(phenotype, "susceptible")

pheno_geno <- plotPXG(bedbugs, pheno.col = 2, "r449_NW_014465016")
# geno - 1 is AA, 2 is AB, 3 is BB
qtl_marker <- factor(pheno_geno$r449_NW_014465016, labels = c("AA", "AB", "BB"))
# make into a data frame
qtl_df <- data.frame(phenotype, qtl_marker)
# summary table
table(qtl_df)
```
:::

Now we have a table where we can see the numbers of each resistance phenotype for each genotype. It is fairly clear from this table and the figure if a bedbug has an A allele at this locus, it is more likely to be susceptible to the pesticide. In contrast, most BB individuals are resistant.

Visualising this data can also be useful to see the associations. I have attempted a couple of different ones, but there is no single best way to do this. See if you can come up with a better one yourself!


```r
ggplot(qtl_df, aes(phenotype, qtl_marker)) + geom_jitter(height = 0.2, width = 0.2)
```

<img src="Exercise6_files/figure-html/unnamed-chunk-17-1.png" width="672" />

```r
ggplot(qtl_df, aes(phenotype, fill = qtl_marker)) + geom_bar()
```

<img src="Exercise6_files/figure-html/unnamed-chunk-17-2.png" width="672" />

### Testing the same genotype phenotype association with ANOVA

Last but not least, we can test the same association with ANOVA. This part will be left for you to do in the assignment. To get you started, the data can be found [here](https://BIOS1140.github.io/data/qtl_markers.tsv), and you can read it into R with the following code:


```r
qtl_markers <- read.table("qtl_markers.tsv", header = TRUE, sep = "\t", stringsAsFactors = TRUE)
```

More details on the data can be found in [Week 6 assignment](#w06). Good luck!

## Study questions

The study questions for week 6 are found [here](#w06). Deliver them in Canvas before the deadline as a word or pdf document. See [the appendix](#rmarkdown) for some important points on how the assignments should be delivered. There, you will also find an introduction to R Markdown, a good way to combine code, output and text for a report.

## Going further

-   [John H McDonald's brilliant online statistics handbook and its section on ANOVA](http://www.biostathandbook.com/onewayanova.html)
-   [Graham Coop's notes on recombination and correlations between loci](http://cooplab.github.io/popgen-notes/#correlations-between-loci-linkage-disequilibrium-and-recombination)
-   [The R qtl package website and associated tutorials](http://www.rqtl.org/)
