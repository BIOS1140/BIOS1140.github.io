# Reconstructing the Past {#ch09}


<script src="js/hideOutput.js"></script>








How can we use genetics and genomics to understand the evolutionary history of organisms? Although evolutionary change can be rapid, it mainly occurs on a timescale that extends far beyond the average human lifespan. For this reason, we must turn to other means in order to reconstruct a picture of the evolutionary history of species and populations. In this tutorial, we will focus on two such methods. The first of these is phylogenetic analysis as a means to visualise the evolutionary relationships among species. We will then turn to principal components analysis, a popular method for examining the variation we see in genomic data and a first step for gaining insight into the processes that might have led to the evolution of such structure within or between species.

### What to expect {.unnumbered}

In this section we will:

-   learn some tools for visualising phylogenetic trees
-   learn how to create phylogenies
-   perform a PCA on genomic data

### Getting started {.unnumbered}

As always, we need to set up our R environment. We'll load `tidyverse` as usual, but we will also need a few more packages today to help us handle different types of data. Chief among these is `ape` which is the basis for a lot of phylogenetic analysis in R. We will also load another phylogenetic package, `phangorn` (which has an extremely [geeky reference](https://en.wikipedia.org/wiki/Fangorn) in its name). The package `adegenet` will also be used to perform some population genomic analyses and since these are quite computationally intensive, we will also install and load `parallel` - a package that allows R to run computations in parallel to speed up analysis.


``` r
# clear the R environment
rm(list = ls())

# install new packages
install.packages("ape")
install.packages("phangorn")
install.packages("adegenet")
install.packages("parallel")

# load packages
library(ape)
library(phangorn)
library(adegenet)
library(tidyverse)
library(parallel)
```

With these packages installed, we are ready to begin!

## Phylogenetics in R


<script src="js/hideOutput.js"></script>


R has a number of extremely powerful packages for performing phylogenetic analysis, from plotting trees to testing comparative models of evolution. You can see [here](https://cran.r-project.org/web/views/Phylogenetics.html) for more information if you are interested in learning about what sort of things are possible. For today's session, we will learn how to handle and visualise phylogenetic trees in R. We will also construct a series of trees from a sequence alignment. First, let's familiarise ourselves with how R handles phylogenetic data.

### Storing trees in R

The backbone of most phylogenetic analysis in R comes from the functions that are part of the `ape` package. `ape` stores trees as `phylo` objects, which are easy to access and manipulate. The easiest way to understand this is to have a look at a simple phylogeny, so we'll create a random tree now.


``` r
# set seed to ensure the same tree is produced
set.seed(32)
# generate a tree
tree <- rtree(n = 4, tip.label = c("a", "b", "c", "d"))
```

What have we done here? First, the `set.seed` function just sets a seed for our random simulation of a tree. You won't need to worry about this for the majority of the time, here we are using it to make sure that when we randomly create a tree, we all create the same one.

What you need to focus on is the second line of code that uses the `rtree` function. This is simply a means to generate a random tree. With the `n = 4` argument, we are simply stating our tree will have four taxa and we are already specifying what they should be called with the `tip.label` argument.

Let's take a closer look at our `tree` object. It is a `phylo` object - you can demonstrate this to yourself with `class(tree)`.


``` r
tree
#> 
#> Phylogenetic tree with 4 tips and 3 internal nodes.
#> 
#> Tip labels:
#>   c, a, d, b
#> 
#> Rooted; includes branch lengths.
```

By printing `tree` to the console, we see it is a tree with 4 tips and 3 internal nodes, a set of tip labels. We also see it is rooted and that the branch lengths are stored in this object too.

You can actually look more deeply into the data stored within the `tree` object if you want to. Try the following code and see what is inside.


``` r
str(tree)
objects(tree)
tree$edge
tree$edge.length
```

It is of course, much easier to understand a tree when we visualise it. Luckily this is easy in R.


``` r
plot(tree)
```

<img src="Exercise9_files/figure-html/unnamed-chunk-6-1.png" width="672" />

In the next section, we will learn more about how to plot trees.

### Plotting trees

We can do a lot with our trees in R using a few simple plot commands. We will use some of these later in the tutorial and assignment, so here's a quick introduction of some of the options you have. 

First, let's generate another random tree, this time with 5 taxa.


``` r
# set seed to ensure the same tree is produced
set.seed(32)
# generate a tree
tree <- rtree(n = 5, tip.label = c("a", "b", "c", "d", "e"))
```

Now, try modifying the appearance of the tree using some of these arguments to `plot()`:

* `use.edge.length` (`TRUE` (default) or `FALSE`): should branch length be used to represent evolutionary distance?
* `type`: the type of tree to plot. Options include "phylogram" (default), "cladogram", "unrooted" and "fan".
* `edge.width`: sets the thickness of the branches
* `edge.color`: sets the color of the branches

See `?plot.phylo` for a comprehensive list of arguments.

You can also manipulate the contents of your tree:  

* `drop.tip()` removes a tip from the tree
* `rotate()` switches places of two tips in the visualisation of the tree (without altering the evolutionary relationship among taxa) 
* `extract.clade()` subsets the tree to a given clade

See the help pages for the functions to find out more about how they work. Now, let's use some of the options we've learned here for looking at some real data.

### A simple example with real data - avian phylogenetics

So far, we have only looked at randomly generated trees. Let's have a look at some data stored within `ape`---a phylogeny of birds at the order level.


``` r
# get bird order data
data("bird.orders")
```

Let's plot the phylogeny to have a look at it. We will also add some annotation to make sense of the phylogeny.


``` r
# no.margin = TRUE gives prettier plots
plot(bird.orders, no.margin = TRUE)
segments(38, 1, 38, 5, lwd = 2)
text(39, 3, "Proaves", srt = 270)
segments(38, 6, 38, 23, lwd = 2)
text(39, 14.5, "Neoaves", srt = 270)
```

<img src="Exercise9_files/figure-html/unnamed-chunk-9-1.png" width="672" />

Here, the `segments` and `text` functions specify the bars and names of the two major groups in our avian phylogeny. We are just using them for display purposes here, but if you'd like to know more about them, you can look at the R help with `?segments` and `?text` commands.

Let's focus on the Neoaves clade for now. Perhaps we want to test whether certain families within Neoaves form a monophyletic group? We can do this with the `is.monophyletic` function.


``` r
# Parrots and Passerines?
is.monophyletic(bird.orders, c("Passeriformes", "Psittaciformes"))
#> [1] FALSE
```

``` r
# hummingbirds and swifts?
is.monophyletic(bird.orders, c("Trochiliformes", "Apodiformes"))
#> [1] TRUE
```

If we want to look at just the Neoaves, we can subset our tree using `extract.clade()`. We need to supply a node from our tree to `extract.clade`, so let's find the correct node first. The nodes in the tree can be found by running the `nodelabels()` function after using `plot()`:


``` r
plot(bird.orders, no.margin = TRUE)
segments(38, 1, 38, 5, lwd = 2)
text(39, 3, "Proaves", srt = 270)
segments(38, 6, 38, 23, lwd = 2)
text(39, 14.5, "Neoaves", srt = 270)
nodelabels()
```

<img src="Exercise9_files/figure-html/unnamed-chunk-11-1.png" width="672" />

We can see that the Neoaves start at node 29, so let's extract that one.


``` r
# extract clade
neoaves <- extract.clade(bird.orders, 29)
# plot
plot(neoaves, no.margin = TRUE)
```

<img src="Exercise9_files/figure-html/unnamed-chunk-12-1.png" width="672" />

The functions provided by `ape` make it quite easy to handle phylogenies in R, feel free to experiment further to find out what you can do!

### Constructing trees with R

So far, we have only looked at examples of trees that are already constructed in some way. However, if you are working with your own data, this is not the case - you need to actually make the tree yourself. Luckily, `phangorn` is ideally suited for this. We will use some data, bundled with the package, for the next steps. The following code loads the data:

::: {.yellow}

``` r
# get phangorn primates data
fdir <- system.file("extdata/trees", package = "phangorn")
primates <- read.dna(file.path(fdir, "primates.dna"), format = "interleaved")
```
:::

This is a set of 14 mitochondrial DNA sequences from 12 primate species and 2 outgroups - a mouse and a cow. The sequences are 232 basepairs long. The data is originally from [this paper](https://academic.oup.com/mbe/article/5/6/626/1044336) and is a well-known example dataset in phylogenetics.

We have seen the structure this data is stored in before - it is a `DNA.bin` object like we worked with in [Chapter 7](#ch07).

Print `primates` to your screen and have a look at it. For the next section, we will use just four species - the hominidae (i.e. Orangutan, Gorilla, Chimpanzee and Human). Let's subset our data in order to do that.


``` r
# subset data to get hominidae
hominidae <- primates[11:14, ]
```

We also need to convert our dataset so that `phangorn` is able to use it properly. The package uses a data structure called `phyDAT`. Luckily conversion is very easy indeed:


``` r
# convert data
hominidae <- as.phyDat(hominidae)
```

We are going to create two types of trees - UPGMA and Neighbour Joining. These are distance based measures and so we must first make a distance matrix among our taxa, which requires a substitution model. The default substitution model is the Jukes & Cantor model, but we can also use Felsenstein's 1981 model. Which is the best to apply here? To find that out, we should first test the different models using `modelTest`:


``` r
# perform model selection
hominidae_mt <- modelTest(hominidae, model = c("JC", "F81"), G = FALSE, I = FALSE)
#> Model        df  logLik   AIC      BIC
#>           JC 5 -862.0267 1734.053 1751.287 
#>          F81 8 -787.2579 1590.516 1618.09
```

Take a look at the `hominidae_mt` table. What we have done here is performed a maximum likelihood analysis and a form of model selection to determine which of the two models we tested - JC69 and F81 (specified by `model = c("JC", "F81")`) best fits our data. We also set `G` and `I` to false in order to simplify the output. Don't worry too much about what these are for now, but feel free to use `?modelTest` if you wish to learn more.

Anyway, how can we interpret this table? Well, we are looking for the model with the **log likelihood** closest to zero and also the lowest value of AIC (Akaike information criterion - [see here for more information](https://en.wikipedia.org/wiki/Akaike_information_criterion)). In this case, it is clear that F81 is a better fit for the data than the JC model, so we will calculate our distance matrix with this model instead.

We can now calculate evolutionary distance using `dist.ml` - a function that compares pairwise distances among sequences the substitution model we chose.


``` r
# first generate a distance matrix
hominidae_dist <- dist.ml(hominidae, model = "F81")
```

Take a look at `hominidae_dist`. You will see it is a matrix of the distance or difference between the sequences. The distances are based on the number of nucleotide substitutions, and the actual values depend on the model we use---here, the F81. It is not straightforward to interpret how much the groups differ from the numbers directly, but in general, the larger the number the greater the genetic distance.

Next we can create our trees. For an UPGMA tree, we use the `upgma` function:


``` r
# upgma tree
hom_upgma <- upgma(hominidae_dist)
```

Next we will make a neighbour joining tree. This is easily done with the `NJ` function.


``` r
# NJ tree
hom_nj <- NJ(hominidae_dist)
```

Now that we have created both of our trees, we should plot them to have a look at them. 


``` r
# plot them both
par(mfrow = c(2, 1)) # 2 plots in same window
plot(hom_upgma, no.margin = TRUE)
plot(hom_nj, type = "unrooted", no.margin = TRUE)
par(mfrow = c(1,1)) # reset mfrow
```

<img src="Exercise9_files/figure-html/unnamed-chunk-20-1.png" width="672" />

Note that when we plot the NJ tree, we add an extra argument to get an unrooted tree. The default in R is to plot rooted trees, but since the neighbour joining algorithm produces an unrooted phylogeny, the correct way to plot it is unrooted. 

We can verify that the tree is unrooted (compared to the UPGMA tree) using the `is.rooted()` function.


``` r
# check whether the tree is rooted
is.rooted(hom_nj)
is.rooted(hom_upgma)
```

We can also set a root on our tree, if we know what we should set the outgroup to. In this case, we can set our outgroup to Orangutan, because we know it is the most divergent from the clade that consists of humans, chimps and gorillas.

We will set the root of our neighbour joining tree below using the `root` function and we'll then plot it to see how it looks.


``` r
# plot nj rooted
hom_nj_r <- root(hom_nj, "Orang")
plot(hom_nj_r, no.margin = TRUE)
```

<img src="Exercise9_files/figure-html/unnamed-chunk-22-1.png" width="672" />

In this case, it hasn't actually made a huge difference to our tree topology, but with a larger dataset, it might do.

As a final point here, we might want to try and compare our two trees and see which we should accept as the best model for the evolutionary relationships among our taxa. One way to do this is to use the **parsimony score** of a phylogeny. Essentially, the lower the parsimony score is for a tree, the more parsimonious explanation of the data it might be. This is very easy to achieve with the `parsimony` function.


``` r
# calculate parsimony
parsimony(hom_upgma, hominidae)
parsimony(hom_nj_r, hominidae)
```

For the `parsimony` function, the first argument is the tree, the second is the data. Here we can see that both parsimony scores are equal for the two trees, suggesting that they are both equivalent models of the evolutionary relationships among the taxa we are studying here. 

If you test the parsimony score for the rooted and the unrooted NJ tree, you will see that they are the same. It is important to note that this is not usually the case! Choosing an outgroup will normally change the tree length, and therefore the parsimony score.

## Population structure


<script src="js/hideOutput.js"></script>


Examining population structure can give us a great deal of insight into the history and origin of populations. Model-free methods for examining population structure and ancestry, such as [**principal components analysis**](https://en.wikipedia.org/wiki/Principal_component_analysis) (PCA), are extremely popular in population genomic research. This is because it is typically simple to apply and relatively easy to interpret when you have learned how. Essentially, PCA aims to identify the main axes of variation in a dataset with each axis being independent of the next (i.e. there should be no correlation between them). Here, we will do a PCA analysis, and then walk you through the interpretation of the PCA, as it can be a bit tricky to wrap your head around the first time you see it.

### Village dogs as an insight to dog domestication

To demonstrate how a PCA can help visualise and interpret population structure, we will use a dataset adapted from that originally used by [Shannon et al. (2015)](http://www.pnas.org/content/112/44/13639) to examine the genetic diversity in a worldwide sample of domestic dogs. All of us are familiar with domestic dogs as breeds and pets, but it is easy to overlook the fact that the majority of dogs on earth are in fact free-roaming, human commensals. Rather than being pets or working animals, they just live alongside humans and are [equally charming](https://en.wikipedia.org/wiki/Free-ranging_dog).

In their study, [Shannon et al. (2015)](http://www.pnas.org/content/112/44/13639) surveyed hundreds of dogs from across the world, focusing mainly on village dogs in developing countries. Since domestic dog breeds are often characterised by severe bottlenecks and inbreeding, they lack a lot of the diversity that would have been present when they first became a domestic species. In contrast, village dogs are unlikely to have undergone such bottlenecks and so might represent a more broad sample of the true genetic diversity present in dogs.

The researchers used a SNP chip and previously published data to collate variant calls from over 5,406 dogs at 185,805 SNP markers. Of the 5,406 dogs, 549 were village dogs. It is these free-roaming dogs we will focus on today.

### Reading the data into R

In order to run our PCA analysis, we will need to use `adegenet`. However, the full dataset is much too large to read, so instead we will use a smaller subsetted dataset. We will read in a special format of SNP data produced by a program called [PLINK](https://www.cog-genomics.org/plink/1.9/). Don't worry too much about the data format for now - our main aim is to get it into R. However, feel free to explore the PLINK website if you are interested.

We will need a [**plink raw file**](https://bios1140.github.io/data/village_subsample.raw) and also a [**plink map file**](https://bios1140.github.io/data/village_subsample.map) for our dog data. Follow the links to download the data and then use the `read.PLINK` function below to read them in. (if you're on a mac, and think this goes too slowly, try changing the `parallel` argument to `TRUE`)

::: {.yellow}

``` r
# read in the dog data
dogs <- read.PLINK(file = "./village_subsample.raw", 
                   map.file = "./village_subsample.map", parallel = FALSE,
                   chunkSize = 2000)
```
:::



Running the function will create a `genlight` object - a special data structure for `adegenet`. If you call the `dogs` object, you will see some summary information and also the number of individuals and markers. As you will see, we have subsampled this data to make it more feasible to run an analysis in R.

### Performing a PCA

With `adegenet`, we can perform PCA on our genomic data with the `glPCA` function.


``` r
# perform pca on dogs
dogs_pca <- glPca(dogs, parallel = TRUE, nf = 20)
```

Here again Mac and Linux users can benefit from parallel processing with `parallel = TRUE`. We also use `nf = 20` in order to tell the function we want to retain 20 principal components.

Let's take a moment to look at the output of our PCA analysis.


``` r
# look at pca object
objects(dogs_pca)
```

Our `dogs_pca` object is a list with four elements. We can ignore `call` - that is just the call to the function we performed above. `eig` returns the eigenvalues for all the principal components calculated (more on this later). `loadings` is a matrix of how the SNPs load onto the PC scores - i.e. how their changes in allele frequency effect the position of the data points along the axis. Finally the `scores` matrix is the actual principal component scores for each individual, allowing us to actually see how the invidivudals are distributed in our analysis.


### Visualising the PCA

Plotting a PCA is the best way to properly interpret it, so we will do this now. The first thing we should do is extract the **principal component scores** from the data. Remember that ggplot needs data to be in a data frame, so we will begin by converting `dogs_pca$scores` to a data frame. The ID of each dog is stored as row names, but we want it in a regular column, so we have to add an `id` column as well.


``` r
pca_df <- data.frame(dogs_pca$scores)
pca_df$id <- rownames(dogs_pca$scores)
```

We can then plot the first 2 axes using `ggplot()`^[since distances between points matter, as we explain below, we use `coord_fixed()` to make sure that the distance between values are the same on both axes].


``` r
# plot with ggplot2
ggplot(pca_df, aes(PC1, PC2)) + 
  geom_point() + 
  theme_light() + 
  coord_fixed()
```

<img src="Exercise9_files/figure-html/unnamed-chunk-29-1.png" width="672" />

So what does this plot tell us? Let's explain a bit about how to interpret PCA plots.

:::{.green}
#### Interpreting PCA plots {-}

A PCA plot is a bit different from other plots you may have encountered before. One key difference is that the value on the axes cannot be translated into anything concrete. The principal components (PC1, PC2, etc.) simply arranges the points (individual dogs in our case) along the axis depending on how similar they are to one another. This means that the further away two points are, the more different they are _in some undefined aspect_^[There are ways to try to determine which sources of variation is explained by the axes, but that is too much to go through here.]. The simplest way to read a PCA plot is:

* points that are close together are similar to one another
* points that are far apart are different to one another
* consequently, if points form a cluster (e.g., the group of points in the bottom right of the plot above), they are similar to one another and different from everything else

Another thing to note is that the principal components are ordered after how much variation they explain. For example, PC1 is the component explaining most variation in the data, PC2 the second most, PC3 the third most and so on. So two points being far apart on PC1 means that they are "more different" than two points far apart on PC2.

:::

OK, so the above plot looks interesting. We can see that one group of points in particular forms a cluster in the bottom right corner. But which dogs form this cluster? Are they from the same population? To investigate this we need to add some more information to our plot, namely the population each dog belongs to. We have prepared that information for you and you can download it [here](https://bios1140.github.io/data/village_dogs.tsv). Then read it in like so:


``` r
# read in village dog data
village_data <- read.table("./village_dogs.tsv", sep = "\t", header = TRUE)
```




Take a moment to look at this. It has three columns, `id`, `breed` and `location`. Our `my_pca` object also has an id column, so we need to join the two datasets. We can do this with a `dplyr` function called `left_join()` (which we explain more about next week):

:::{.yellow}


``` r
# join pca and village dog data
village_pca <- left_join(pca_df, village_data, by = "id")
```

:::

Now we have added location to our data set. This means we can plot the PCA using `ggplot()` and at the same time colour the points by the location they were sampled in (try doing this without looking at my code first!).

:::{.fold .c}


``` r
# plot with ggplot2
ggplot(village_pca, aes(PC1, PC2, col = location)) + 
  geom_point() + 
  theme_light() +
  coord_fixed()
```

<img src="Exercise9_files/figure-html/unnamed-chunk-33-1.png" width="672" />

:::

So from this PCA, what can we deduce? First of all, the cluster we identified earlier are dogs from East Asia. Similarly, Central Asian, African and European dogs seem to form their own clusters. In the original paper, [Shannon et al. (2015)](http://www.pnas.org/content/112/44/13639) suggest that the origin of dog domestication might actually be in Central Asia. This is hard to deduce from the PCA but it is clear that there is geographical structure among village dogs.

### Eigenvalues

How much of the variance in the data set is captured by the PCA? For this, we can use the _eigenvalues_ of the principal components, stored in `dogs_pca$eig`. Have a look at this vector, where PC1 is the first element, PC2 the second and so on, and notice that the numbers are decreasing. This means that PC1 explains more variation than the other axes, as we mentioned previously.

These numbers are not easy to interpret by themselves, but are useful if we view them as a fraction of the total. For example, we can see how much of the total variation is explained by PC1 like this:


``` r
dogs_pca$eig[1] / sum(dogs_pca$eig)
#> [1] 0.04596527
```

And see that PC1 explains around 4.6 % of the variation of the data. Due to R treating vectors as it would single numbers in many cases, we can calculate variance explained for all principal components in a single operation like this:


``` r
eig <- (dogs_pca$eig / sum(dogs_pca$eig))
eig
```

From `eig`, we can see that if we sum the first two elements (i.e., PC1 and PC2), we find that around 7.63% of variance explained by the first two principal components (and by extension, the patterns we wee in our plot). A total of 7.63% for the first two vectors sounds small, but it is actually quite an appreciable amount of variance. Typically, we would concentrate on the principal components that together account for at least 10% of the variance.

### The full data set

It is important to remember that the analyses we have done have been on a small subsample. Working with the full data, however, could make patterns clearer. Therefore, you will be working with the complete data in the assignment. 

Since the full data set is very large, we cannot perform PCA on this in R. However, we have conducted this for you and you can find the full PCA data set [here](https://bios1140.github.io/data/full_village_dogs_pca.tsv). You can also find the eigenvectors [here](https://bios1140.github.io/data/full_village.eigenval). More on this in the assignment!

## Study questions

The study questions for week 8 are found [here](#w09). Deliver them in Canvas before the deadline as a word or pdf document. See [the appendix](#rmarkdown) for some important points on how the assignments should be delivered. There, you will also find an introduction to R Markdown, a good way to combine code, output and text for a report.

## Going further

-   [A short tutorial on phylogenetics in R and also with some comparative phylogenetic functions](http://www.phytools.org/eqg/Exercise_3.2/)
-   [Going further with phylogenetics in R - plus links to other tutorials](https://www.molecularecologist.com/2016/02/quick-and-dirty-tree-building-in-r/)
-   [ggTree - a package for more elegant tree drawing in R](https://www.molecularecologist.com/2017/02/phylogenetic-trees-in-r-using-ggtree/)
-   [A series of tutorials for running analyses (including PCA) in adegenet](https://github.com/thibautjombart/adegenet/wiki/Tutorials)
