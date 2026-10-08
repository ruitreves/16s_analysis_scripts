#!/bin/bash

mkdir -p fastqc_report

find fastq/ -name "*.fastq.gz" | sort > fq_samplesheet.txt

parallel -j 24 --bar "fastqc --threads 2 --outdir fastqc_report {}" :::: fq_samplesheet.txt