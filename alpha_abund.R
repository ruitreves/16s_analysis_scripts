library(tidyverse)

alpha_abundance <- read_tsv("fastq/final.opti_mcc.groups.ave-std.summary") %>% as.data.frame()
x <- alpha_abundance[1:40, c("group", "shannon", "simpson", "chao")]
colnames(x)[1] <- "sample"

si <- read.csv("sample_info.csv")
x <- x[match(si$sample, x$sample), ]

write.csv(x, "results/alpha_index.csv")
