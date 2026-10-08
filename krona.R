library(statomatic)
library(tidyverse)

sample_info <- read.csv("sample_info.csv")

otu_table <- read.csv("results/otu_table.csv") %>% cf() %>%
    select(-Size)

tax <- otu_table %>% select(Taxonomy)

tax_levels <- c("kingdom", "phylum", "class", "order", "family", "genus")

taxonomy <- tax %>% 
    rename_all(tolower) %>%
    mutate(taxonomy = str_replace_all(string = taxonomy, pattern = "\\(\\d*\\)", replacement = "")) %>%
    mutate(taxonomy = str_replace_all(string = taxonomy, pattern = ";$", replacement = "")) %>%
    separate(taxonomy, into = tax_levels, sep = ";") %>%
    mutate(across(c(phylum:genus), ~str_replace_all(string = ., pattern = ".*_unclassified", "unclassifed"))) %>%
    select(-kingdom)

x <-  otu_table %>%
    select(-Taxonomy)

dir.create("krona_stuff")

groups <- unique(sample_info$group)
for (i in 1:length(groups)) {
    rel_samples <- sample_info$sample[sample_info$group == groups[i]]
    rel_counts <- x[, rel_samples]
    rel_counts$X <- rowSums(rel_counts)
    rel_counts <- cbind(rel_counts, taxonomy)
    rel_counts <- rel_counts[, 6:ncol(rel_counts)]
    write_tsv(rel_counts, paste0("krona_stuff/", groups[i], ".krona"), col_names = FALSE)
    print(head(rel_counts))
}
