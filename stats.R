library(statomatic)
library(tidyverse)

a <- list.files("abundance_tables", full.names = TRUE)
readin <- lapply(a, read.csv, row.names=1)
sample_info <- read.csv("sample_info.csv")

lapply(1:length(readin), function(i) {
    x <- readin[[i]]
    tax_level <- basename(a[[i]]) %>% str_remove("_abundance.csv")
    savename <- paste0("results/", tax_level, "_results.csv")
    x <- log(x+1)
    anova_res <- run_anova(x, sample_info$sex, sample_info$diet, sample_info$treatment)
    tukey_res <- run_tukey(x, sample_info$group)
    fc <- fold_change(x, sample_info$group)
    tukey_fc <- combine_fc_pvals(tukey_res, fc)
    res <- merge(anova_res, tukey_fc, by = 0) %>% cf()
    write.csv(res, savename)
})
