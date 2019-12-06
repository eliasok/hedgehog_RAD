#!/bin/bash
#
# calling variability with freebayes for merged files from years 2016 and 2018

REF=~/hedgehog/data_2016/reference
SOURCE=~/hedgehog/data_2018/merged_bam

freebayes -f $REF/GCF_000296755.1_EriEur2.0_genomic.fna --genotype-qualities --min-mapping-quality 15 --min-base-quality 15 \
 -b $SOURCE/*_msnc.bam > merged.vcf &
wait
