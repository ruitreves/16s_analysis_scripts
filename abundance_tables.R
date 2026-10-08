library(tidyverse)

f <- function(otu, tax, cutoff = 1) {

    tax_levels <- c("kingdom", "phylum", "class", "order", "family", "genus")

    taxonomy <- tax %>% 
    rename_all(tolower) %>%
    mutate(taxonomy = str_replace_all(string = taxonomy, pattern = "\\(\\d*\\)", replacement = "")) %>%
    mutate(taxonomy = str_replace_all(string = taxonomy, pattern = ";$", replacement = "")) %>%
    separate(taxonomy, into = tax_levels, sep = ";") %>%
    mutate(across(c(phylum:genus), ~str_replace_all(string = ., pattern = ".*_unclassified", "unclassifed")))

    otu_data <- otu %>% select(-label, -numOtus) %>%
        rename(sample = Group) %>%
        pivot_longer(cols = -sample, names_to = "otu", values_to = "count")

    agg_tax <- inner_join(otu_data, taxonomy)

    tax_tables <- c()
    for (i in 1:length(tax_levels)) {
        t <- tax_levels[i]
        a <- agg_tax %>% group_by(sample, !!sym(t)) %>%
        summarize(total = sum(count)) %>%
        ungroup()

        top <- a %>% group_by(!!sym(t)) %>%
            summarize(median = median(total)) %>%
            filter(median > cutoff) %>%
            arrange(desc(median)) %>%
            pull(!!sym(t))
        
        temp <- a %>% filter(!!sym(t) %in% top) %>%
            group_by(!!sym(t)) %>%
            pivot_wider(names_from = sample, values_from = total, values_fill = 0) %>%
            arrange(desc(rowSums(across(where(is.numeric)))))
        tax_tables[[i]] <- temp
    }
    return(tax_tables)
}

otu_data <- read.table("fastq/final.opti_mcc.0.03.subsample.shared", header = TRUE, sep = "\t")
taxonomy <- read.table("fastq/final.opti_mcc.0.03.cons.taxonomy", header = TRUE, sep = "\t")

tax_levels <- c("kingdom", "phylum", "class", "order", "family", "genus")

tables <- f(otu_data, taxonomy)

dir.create("abundance_tables")

for (i in 2:length(tables)) {
    temp <- tables[[i]]
    name <- paste0("abundance_tables/", tax_levels[i], "_abundance.csv")
    write.csv(temp, name)
}

