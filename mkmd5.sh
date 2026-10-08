#!/bin/bash

for fq in data_release/result_X202SC26091832-Z01-F001/01.RawData/*/*.fastq.gz; do
    echo $fq
done

md5sum-lite data_release/result_X202SC26091832-Z01-F001/01.RawData/*/*.fastq.gz > rui_md5sum_list.txt

md5sum-lite data_release/result_X202SC26091832-Z01-F001/00.CleanData/*/*.gz > rui_clean_md5sum_list.txt


