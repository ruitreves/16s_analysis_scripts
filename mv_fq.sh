#!/bin/bash

mkdir -p fastq

find data_release/result_X202SC26091832-Z01-F001/01.RawData \
  -type f \
  -name '*.fastq.gz' \
  ! -name '*.extendedFrags*' \
  ! -name '*.raw*' \
  -exec cp -n {} fastq/ \;