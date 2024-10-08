# Week 9 assignment 7 {- #w10}

_These study questions are meant only to test yourself. Hand-in is not required and will not count on the required number of approved hands-in. We will, however, provide a hand-in folder for those who would like feedback from one of the group teachers_

This assignment makes you apply a lot of your R knowledge to analyse data. Some parts may be challenging, and the most important thing this week is that you try your best! So take this as a learning opportunity, and don't fret if you're stuck on an exercise. All honest attempts at solving this assignment will be approved. Good luck!

#### 1. Categorising and joining {-}

_Once again, we will be using the data in [worlddata.csv](https://bios1140.github.io/data/worlddata.csv). Read in the data first, and do the exercises below._

The world is sometimes divided into "The West" (Europe and North America) and "The Rest" (which is not necessarily constructive nor useful). In this part of the assignment we will investigate this division for a bit.

a) Use (nested) `ifelse()` statements to create a new column that says "The West" if the country is a part of Europe or North America, and "The Rest" if not.

b) Plot life expectancy at birth against total fertility rate, and color the points by the column you created in a. _If you weren't able to complete a., color by continent instead._

_The [Gapminder foundation](https://www.gapminder.org/) aims to debunk common misconceptions about the world using a fact-based worldview and [excellent interactive data visualisations](https://www.gapminder.org/tools/#$chart-type=bubbles&url=v1). The foundation collects a lot of population data on their website, which we will use some of here._

Download the file [gdp_per_capita.csv](https://bios1140.github.io/data/gdp_per_capita.csv) and import it into R *(Tip: some country names have commas in them, which might confuse `read.table()` a bit. Try using `read.csv()` instead)*. The file contains GDP per capita (in inflation-adjusted dollars) for the countries of the world for 2020. Note that the GDP data has slightly fewer countries than the world data, and that some countries may not be named in exactly the same way. We'll ignore this for the purpose of this exercise and let R handle the mismatches.

c) Use `left_join()` to join the GDP data to the world data. Remember that since you're adding to the world data, that should be the first argument. Print your new data frame to check that it worked.

d) Make a plot of life expectancy against GDP, color the points by continent, map size to population size, and map shape to the "West" and "Rest" column you made in a.  Is the West/Rest division helpful for determining patterns? _Tip: add `scale_x_log10()` to your ggplot to get GDP on a logarithmic axis, the patterns may be easier to see that way._ _If you weren't able to complete the previous exercises, download [this file](https://bios1140.github.io/data/worlddata_income.csv) and plot that instead (the columns are called "gdp" and "Division")._

If you are interested in learning more, take a look at the previously mentioned [interactive visualisations](https://www.gapminder.org/tools/#$chart-type=bubbles&url=v1). Look how much the world has changed the past 200 years!

#### 2. Vectorisation {-}

_In this part of the assignment, we will use vectorisation to investigate the development of the word's countries since 1900 until today. But first a few vectorisation assignments!_

a) Create a function that takes a vector as an argument, and returns the last element of the vector divided by the first. For example, when using the function on the vector `c(2, 4, 10)`, it should return `5`, because $\frac{10}{2} = 5$. _Hint: use_ `x[length(x)]` _to get the last element of a vector_ `x` _._

For the next assignment, run the following code to create an example list:


``` r
numbers <- list(
  c(1,2,3),
  c(14, 36, 60, 78),
  c(40, 700, 1000)
)
```


b) Use `lapply()` or `sapply()` to apply the function you created in a. to `numbers`.

For the next part of the assignment, download the file [gdp_year.rds](https://bios1140.github.io/data/gdp_year.rds). This data is also from Gapminder, and shows the development in GDP per capita from 1900 to 2020 by country. Load the data with `readRDS()`:


``` r
data <- readRDS("gdp_year.rds")
```

If you look at the data, you will see that it is a list, with each list element representing a country, and containing a vector of GDPs per capita, one for each year.

c) Use `sapply()` to apply the function you made in a. to the data you just loaded, to get each country's relative GDP growth from 1900 until today. The result should be a named vector with a single number per country.

    Next, convert your vector to a data frame with the following code (assuming your vector is named `gdp_change`):
    
    
    ``` r
    gdp_df <- data.frame(gdp_change) %>% rownames_to_column("Country")
    ```
    
d) Use `left_join()` to join `gdp_df` with the world data. Make a boxplot of GDP change by continent. Is there anything in particular you find interesting or surprising with this plot? _if you aren't able to join, download [this data](https://bios1140.github.io/data/worlddata_gdp_change.csv) and plot that instead._
