# (APPENDIX) Appendix {-}

# About assignments and RMarkdown {#rmarkdown}

There are some important things to consider when handing in the assignments:

1. All answers, plots and code should be contained in _a single document_. This needs to be either a word or a pdf document.
2. The document should contain **all the code** you used to complete the assignment. It should also contain **all relevant output** from the code. This should be in a font that's suitable for programming (i.e., where all characters have the same width), for example "source code pro".
3. You are allowed to work together, but **identical hand-ins are not allowed**. Similarly, all the text should be your own, **copying from the book, tutorials or any other sources is not allowed**. If you really want to quote someone, you should make it clear that it's a quote, and cite it properly. It is OK to use the *code* in the tutorials without citing that.

One simple way of combining code, plots and text is to write in a word document where you also paste your code and figures that you've exported from R. Another way is to use RMarkdown, which will be introduced in the next section.

A simple template for handing in assignments in R Markdown can be found [here](https://BIOS1140.github.io/data/assignment_template.Rmd)

### R Markdown {-}

R Markdown is a way to work where you can write, code and show output in the same document. It can be a very convenient way to communicate science, and to write comprehensive data journals detailing how you have analysed your data. In fact, these tutorials are all written in R Markdown! Here we will briefly introduce R Markdown so you will be able to use it for the assignments if you want to. For a more comprehensive introduction, see [the introduction tutorials](https://rmarkdown.rstudio.com/lesson-1.html).

Before using R Markdown, you need to install it. You install it like you would any normal R package.


``` r
install.packages("rmarkdown")
```

When you write R Markdown documents, you write within RStudio, before converting your text and code to either a HTML, PDF or Word document (known as "knitting"). For this course you need to deliver assignments either in PDF or Word format. PDF requires $\LaTeX$, and can thus be a bit tricky sometimes. The simplest way to download Latex is by installing [TinyTex](https://yihui.org/tinytex/) with the following code:


``` r
install.packages('tinytex')
tinytex::install_tinytex()
```

Now you have all you need for creating PDF documents with R Markdown!

### Getting started {-}

Create a new R Markdown document by navigating to `File > New File > R Markdown ...`. You will then be prompted to provide a title, an author and an output format (you can change these later). Choose PDF as the format and proceed. You have now created an R Markdown file! Notice that it already contains some usage examples. You don't need these for the assignments, so you can safely delete everything from `## R Markdown` and to the end of the document.

Here, we will only provide the very basics needed to hand in the assignments. If you're interested, you can learn more about the basics [here](https://bookdown.org/yihui/rmarkdown-cookbook/basics.html).

1. Anything you write in the document will be rendered as normal text.

2. You can write R code by inserting a _code chunk_. A code chunk looks like this (hotkey `ctrl`/`cmd`+`alt`+`i`):

    ````markdown
    ```{r}
    
    ```
    ````
    
    Inside the code chunk, you can write regular R code that you can execute normally with `ctrl`/`cmd`+`enter`.

3. You can get a top-level header by starting a line with `#` (outside of a code chunk). You get a second level header with `##`, third level with `###` and so on.

4. You get **bold** text by flanking the text with two asterisks like this: `**bold text**` and *italic* text with a single asterisk: `*italic text*`

When you're done with the document, you can press the tiny yarnball at the top of the document that says "knit" to render your document (or press `ctrl`/`cmd`+`shift`+`k`). This will execute all code that is in the code chunks from a clean environment, and include any plots that are produced by your code. If everything worked, you now have a beautiful document containing code, text and plots!

:::{.blue}
**Some notes about R Markdown:**

* All your code is run from a clean slate. This means that all objects must be defined within the document to make it work.
* If you even have a single error in the code, the document will not knit. On the plus side, this can be a good way of checking that all your code works!
* When working with data files, the data file has to be contained in the same folder as the R Markdown document. Setting working directory within the document will not work most of the time.
* Plots will appear inline instead of in the plot window. Disable this by navigating to the cog wheel at the top, and select "chunk output in console".

:::

# Technical information {#tech}



These tutorials were made using Rmarkdown version 2.27 and Bookdown version 0.39. All code was executed in R programming language version 4.4.1.

The following packages and versions were used for the current tutorials:


Table: (\#tab:unnamed-chunk-4)Packages needed to run all the tutorials, and the package versions used to knit the current version of the tutorials.

|Package   |Version |
|:---------|:-------|
|adegenet  |2.1.10  |
|ape       |5.8     |
|parallel  |4.4.1   |
|pegas     |1.3     |
|phangorn  |2.11.1  |
|PopGenome |2.7.5   |
|qtl       |1.66    |
|tidyverse |2.0.0   |

The specific versions of the tidyverse packages are outlined below:


Table: (\#tab:unnamed-chunk-5)Package versions of core Tidyverse packages

|Package |Version |
|:-------|:-------|
|ggplot2 |3.5.1   |
|dplyr   |1.1.4   |
|tidyr   |1.3.1   |
|readr   |2.1.5   |
|purrr   |1.0.2   |
|tibble  |3.2.1   |
|stringr |1.5.1   |
|forcats |1.0.0   |

