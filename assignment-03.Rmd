# Week 3 Assignment {- #w03}

#### 1. for-loops {-}

Create one vector containing names of 4 animals you feel strongly about. Create another vector that contains what you feel about the animal. Use a for-loop to print the animal and the feeling together (like in section 1.3 of the tutorial). Example output:

```{}
"Pangolins are amazing"
# and similarly for 3 more animals
```

#### 2. Hardy Weinberg Equilibrium {-}

You genotype three populations of grasshoppers along a north south transect across the European Alps. Near Munich, Germany, north of the Alps you sample 120 individuals; near Innsbruck, Austria, within the Alps you sample 122 individuals; near Verona, Italy, south of the Alps you sample 118 individuals. you find the following number of each genotype:

* Munich: 6 (a1a1), 33 (a1a2), 81 (a2a2)
* Innsbruck: 20 (a1a1), 59 (a1a2), 43 (a2a2)
* Verona: 65 (a1a1), 39 (a1a2), 14 (a2a2)

a. Using the r code we learnt during the tutorial, calculate the allele frequencies in each population. Then test (statistically) whether there is a deviation from Hardy-Weinberg equilibrium in each of them. If any of the populations deviate, what could be the cause of the deviation?

b. In the statistical test in the previous question we use the Hardy Weinberg model as a _null model_. Explain what this means.

c. Why is it that when an allele goes to fixation in a population, there are no heterozygotes but there is also no deviation from the Hardy-Weinberg expectation? _Hint: calculate the expected heterozygote frequency when_ $p = 1, q = 0$.

#### 3. Genetic drift {-}

a. You want to model what will happen to the grashoppers' alleles over time, assuming no other forces than genetic drift are changing allele frequencies. Using the for-loop from the tutorial as a starting point, simulate drift over 2000 generations for each of the three populations in the previous exercise. Make sure that the $N$ and initial $p$ match those of the populations. You should make 3 simulations in total, and plot your results.

b. How does the initial p alter the outcome of the simulations? Which population is more likely to go to fixation for either allele?

_Tip: Since this exercise uses random sampling, results will be different every time you run your simulations. You may want to run the simulations several times to get a feeling for what the results generally will be._

