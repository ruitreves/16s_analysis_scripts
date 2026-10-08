library(statomatic)
library(tidyverse)

phylum_table <- read.csv("results/abundance_tables/phylum_abundance.csv")

sample_info <- read.csv("sample_info.csv") %>% select(sample, group)

phylum_table %>% pivot_longer(cols = colnames(phylum_table)[2:ncol(phylum_table)])

x <- phylum_table %>% pivot_longer(cols = colnames(phylum_table)[2:ncol(phylum_table)]) %>% 
    rename(sample = name, count = value, phylum = X) %>%
    inner_join(., sample_info)

bar <- x %>% group_by(phylum, group) %>%
    summarize(group_count = sum(count)) %>%
    pivot_wider(names_from = group, values_from = group_count) %>%
    as.data.frame()

bar_norm <- bar

bar_norm[, 2:ncol(bar)] <- t(t(bar[, 2:ncol(bar)]) / colSums(bar[, 2:ncol(bar)]))

bar_norm <- bar_norm %>% pivot_longer(cols = colnames(bar_norm)[2:ncol(bar_norm)]) %>%
    rename(group = name, rel_abund = value)

bar_norm %>% ggplot(aes(x = group, y = rel_abund, fill = phylum)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1))

ggsave("results/phylum_barplot.png")
