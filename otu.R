library(statomatic)
library(tidyverse)

otu_data <- read.table("fastq/final.opti_mcc.0.03.subsample.shared", header = TRUE, sep = "\t")
taxonomy <- read.table("fastq/final.opti_mcc.0.03.cons.taxonomy", header = TRUE, sep = "\t")

otu_data <- t(otu_data)
colnames(otu_data) <- otu_data[2, ] 
otu_data <- otu_data[-c(1:3), ]
otu_data <- as.data.frame(otu_data)

sample_info <- read.csv("sample_info.csv")

otu_data <- otu_data[, match(sample_info$sample, colnames(otu_data))]

taxonomy <- cf(taxonomy)

otu_table <- merge(otu_data, taxonomy, by = 0)
otu_table <- cf(otu_table)

dir.create("results")

write.csv(otu_table, "results/otu_table.csv")
