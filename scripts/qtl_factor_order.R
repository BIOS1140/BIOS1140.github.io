library(forcats)
library(qtl)

# read in data
bedbugs <- read.cross(format = "csv", dir = "",
                      file = "./bedbugs_cross_data.csv", 
                      genotypes = c("AA", "AB", "BB"), 
                      estimate.map = FALSE)


# get phenotypes as environmental variable
res <- bedbugs$pheno$res

# original order
bedbugs$pheno$res <- as.numeric(res)
bedbugs_scan_orig <- scanone(bedbugs, pheno.col = 2)

# ordered by increasing resistance
bedbugs$pheno$res <- as.numeric(fct_relevel(res, "S"))
bedbugs_scan_inc <- scanone(bedbugs, pheno.col = 2)

# ordered with "S" in the middle
bedbugs$pheno$res <- as.numeric(fct_relevel(res, c("PR", "S", "R")))
bedbugs_scan_s <- scanone(bedbugs, pheno.col = 2)

# show summary of tests
tests <- list(bedbugs_scan_orig, bedbugs_scan_inc, bedbugs_scan_s)

lapply(tests, summary, threshold = 3)

