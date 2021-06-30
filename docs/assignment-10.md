# Week 10 assignment {- #w10}

#### 1. Categorising and joining {-}

_Once again, we will be using the data in [worlddata.csv](bios1140.github.io/data/worlddata.csv). Read in the data first, and do the exercises below._

The world is sometimes divided into "The West" (Europe and North America) and "The Rest" (which is not necessarily constructive nor useful). In this part of the assignment we will investigate this division for a bit.

a) Use (nested) `ifelse()` statements to create a new column that says "The West" if the country is a part of Europe or North America, and "The Rest" if not.

b) Plot life expectancy at birth against total fertility rate, and color the points by the column you created in a. _If you weren't able to complete a., color by continent instead._

_The [Gapminder foundation](https://www.gapminder.org/) aims to debunk common misconceptions about the world using a fact-based worldview and [excellent interactive data visualisations](https://www.gapminder.org/tools/#$chart-type=bubbles&url=v1). The foundation collects a lot of population data on their website, which we will use some of here._

Download the file [gdp_per_capita.csv](bios1140.github.io/data/gdp_per_capita.csv) and import it into R. The file contains GDP per capita (in inflation-adjusted dollars) for the countries of the world for 2020. Note that the GDP data has slightly fewer countries than the world data, and that some countries may not be named in exactly the same way. We'll ignore this for the purpose of this exercise and let R handle the mismatches.

c) Use `left_join()` to join the GDP data to the world data. Remember that since you're adding to the world data, that should be the first argument. Print your new data frame to check that it worked.

d) Make a plot of life expectancy against GDP, color the points by continent, map size to population size, and map shape to the "West" and "Rest" column you made in a. _Skip the shape if you weren't able to complete a.)_ Is the West/Rest division helpful for determining patterns? _Tip: add `scale_x_log10()` to your ggplot to get GDP on a logarithmic axis, the patterns may be easier to see that way_

If you are interested in learning more, take a look at the previously mentioned [interactive visualisations](https://www.gapminder.org/tools/#$chart-type=bubbles&url=v1). Look how much the world has changed the past 200 years!

#### 2. Vectorisation

