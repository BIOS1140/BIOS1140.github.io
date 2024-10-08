# (PART) Assignments {-}

# Week 1-2 assignment 1 {- #w01}

Solve all the problems below using R. Some questions have optional parts that are a little more difficult. We encourage you to do these, but feel free to skip them if the mandatory tasks offers sufficient challenge. You can solve the problems in any way you want (as long as you're using R!) unless otherwise stated.

#### 1. Basic R {-}

**1.1**

a) Assign a variable with the value 6 to an object named after your favorite animal.  
b) Assign a variable with the value 1 to an object named after your least favorite animal.  
c) Calculate the mean of your two objects, and assign that number to an object named after an animal you think is mediocre at best.
d) Combine all your scores in a vector and assign it to an object. Add names to each element of the vector so that the name corresponds to the score.
e) **Optional:** Combine your scores into a data frame with one column for the name and one for the score. Add a column with the average weight of your animals, and another with their top speeds.


``` r
grevling <- 6
rur <- 1
torsk <- mean(c(grevling, rur))

dyr <- c(grevling, rur, torsk)
names(dyr) <- c("grevling", "rur", "torsk")
#dyr
```


**1.2**

The formula for the volume of a sphere is $\frac{4}{3}\pi r^3$.

a) Calculate the volume of a sphere with a radius of 4.5 cm
b) Create a vector of radiuses from 1 to 10, in steps of 0.5. Calculate the volume of spheres with all these radiuses. (*hint: in R the easiest way to do this is in a single operation without the use of any loops, see if you can figure it out!*)
c) **Optional:** make a function that takes one or more radiuses as input, and outputs the volume of a sphere with those radiuses.

**1.3**

You should use logical operators (`==`, `>` etc.) to solve the following tasks.

a) Check if the number $e$ is larger than the number $\pi$.

    
    Create a vector of random numbers with the following code:  
    
    
    ``` r
    set.seed(645)
    rnumbers <- rpois(100, lambda = 2)
    ```

b) How many of the numbers are equal to or larger than 2?  
    *Hint: you can use the* `sum()` *function on a vector of TRUE/FALSE, it will then treat each TRUE as 1 and each FALSE as 0. Example: * `sum(c(TRUE, FALSE, TRUE))` *returns* `2`

c) How many of the numbers are exactly 1?
a) **Optional:** Check if R considers $(\sqrt2 )^2$ to be exactly equal to 2. What is the result? Why is it this way?


#### 2. Data import and plotting {-}

For this section you will use the dataset [vitruvian.txt](https://bios1140.github.io/data/vitruvian.txt). The data set consists of body measurements from biology students from earlier years in the course BIO2150. Make sure you download it, and take note of where it's stored on your computer.

For this part of the exercise, in addition to the course's computing exercises, [these short tutorials](https://evengar.github.io/short-tutorials) may be helpful. Go through them before continuing if you'd like, or use them as reference material when you're unsure about something.

**2.1**

Importing and inspecting the data

a) Open the file "vitruvian.txt" in a plain text editor (like notepad for PC or TextEdit for mac). What kind of file is this? How are the data entries separated?
b) Import the file into R.
c) Use tools in R to figure out the following:
    i) are there any missing values (NAs) in this data set?
    i) how many observations (rows) and variables (columns) are there?
    i) which years did the measuring take place?
    i) what is the sex ratio for biology students in this period?
d) Remove any rows that contain NA in your data set, leaving you with only complete cases. How many rows did you lose?

**2.2**

Summarizing the data 

a) What is the mean body length of all bio students from all years? What is the standard deviation? What is the median?

    A popular claim/myth is that the ratio of body length to the length from foot to navel is approximately the golden ratio ($\approx$ 1.618)

b) Check if this is true for the bio students by getting the mean and standard deviation of the ratio between `body.length` and `foot.navel`.
c) Calculate the mean height of each of the sexes from all years.
d) Subset your data to everyone taller than the average for their respective sex. How many males and females are taller than average?
e) **Optional:** use R's `lm()` function to model `body.length` from `foot.navel`. What is the slope of the regression? What is the intercept, and how do you interpret that?

**2.3**

Before plotting the vitruvian data, we take a detour with some basic plot exercises.

a) Make a vector of the numbers 1 through 50, and one with the numbers 51 through 100, call them x and y respectively. Plot them against each other as points.
b) Plot x against x^2^ as a line with any color other than black.
c) Plot a line of x against $\frac{y^2}{4}$ on top of your previous plot in a different color.
d) Add a title to your plot, stating how pretty it is.


**2.4**

Now we return to our vitruvian data set. We will more or less be plotting the same things we explored in task 2.2.

a) Make a histogram of `body.length`. What can you say about the resulting distribution?
b) Plot `foot.navel` against `body.length` (so that body length is on the y-axis), and color the points by sex. Add a line with a slope of 1.618. How well does the data fit the golden ratio? Add a title, legend and informative axis labels to your plot.
c) Make a boxplot of students' heights for the two sexes. Are there any outliers?
d) Make a subset of your data that only contains observations from 2012. Make a boxplot of neck size for this year, grouped by sex.
e) **Optional** Use your model from 2.2 e. to add a line of best fit to your plot of `foot.navel` against `body.length`. How does it compare to the golden ratio line? Add a confidence interval if you figure out how.


#### 3. Interpreting code and errors {-}

**3.1**

Look at the code below:


``` r
a = 5
a == 6
```

a) In your own words, what is the difference between `=` and `==` in the code above?
b) What will the code output? Why?
c) What is the value of `a` after executing this code?

**3.2**

You tried to import the file "example.csv", and got the following error:


```
## Warning in file(file, "rt"): cannot open file 'example.csv': No such file or
## directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

What is the most probable cause of the error message? How can you fix it?

**3.4**

You tried to extract the `Sepal.Length` column from the iris data set as follows, but got an error:


``` r
iris[,Sepal.Length]
```

```
## Error in eval(expr, envir, enclos): object 'Sepal.Length' not found
```

What caused the error? How can you fix it?
