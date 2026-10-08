library(tidyverse)
library(plotly)
library(htmlwidgets)
library(htmltools)
library(RColorBrewer)

sample_info <- read.csv("sample_info.csv")

pcoa <- read_tsv("fastq/final.opti_mcc.braycurtis.0.03.lt.ave.pcoa.axes") %>% as.data.frame() %>%
    select(group, axis1, axis2, axis3) %>%
    rename(sample = group)
loads <- read_tsv("fastq/final.opti_mcc.braycurtis.0.03.lt.ave.pcoa.loadings")
loads$axis <- paste0("axis", loads$axis)
loads <- loads[1:3, ]

plot <- plot_ly(pcoa, x = pcoa$axis1, y = pcoa$axis2, z = pcoa$axis3, 
        mode = "markers", type = "scatter3d", color = sample_info$group,
        colors = colormap)

saveWidget(plot, "pcoa.html")
