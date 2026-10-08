library(tidyverse)

# for 01.RawData

a <- read.table("data_release/result_X202SC26091832-Z01-F001/01.RawData/Rawdata_MD5.txt")
a$V2 <- basename(a$V2)

b <- read.table("rui_md5sum_list.txt")
b$V2 <- basename(b$V2)


idx <- match(b$V2, a$V2)
a <- a[idx, ]

comp <- data.frame(a_name = a$V2, a_md5 = a$V1, b_name = b$V2, b_md5 = b$V1)

comp$names_match <- (comp$a_name == comp$b_name)
comp$md5_match <- (comp$a_md5 == comp$b_md5)

# write.csv(comp, "md5_check.csv")

# for 00.CleanData

a <- read.table("data_release/result_X202SC26091832-Z01-F001/00.CleanData/Cleandata_MD5.txt")
a$V2 <- basename(a$V2)

b <- read.table("rui_clean_md5sum_list.txt")
b$V2 <- basename(b$V2)


idx <- match(b$V2, a$V2)
a <- a[idx, ]

comp <- data.frame(a_name = a$V2, a_md5 = a$V1, b_name = b$V2, b_md5 = b$V1)

comp$names_match <- (comp$a_name == comp$b_name)
comp$md5_match <- (comp$a_md5 == comp$b_md5)