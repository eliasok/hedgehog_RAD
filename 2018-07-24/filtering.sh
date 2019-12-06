#!/bin/bash
#
# Here I did final filtering with vcftools.
# I discarded sites having too high (>200) or too low coverage (<4),
# sites with quality below 50, sites which are located less then 261
# nucleotides apart to avoid linkage, I removed other variation
# then SNPs and discarded non informative sites with too high or low
# frequency in population. Finally I allowed maximum of 25 % of
# missing data using max-missing option. I removed individuals
# displaying more then 63% of missing data from popmap

SOURCE=~/hedgehog/results_2018/23-02-2018
DATADIR=~/hedgehog/results_2018/24-07-2018

   vcftools --gzvcf $SOURCE/merged.vcf.gz \
            --keep popmap \
            --recode \
            --maf 0.01 \
            --max-maf 0.95 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 4 \
            --minQ 50 \
	    --thin 261 \
            --max-missing 0.75 \
            --recode-INFO-all \
            --out $DATADIR/all

# However the filtering was redone once again by Ignacio with same settings
# but to request 4 E. concolor individuals to have data, when
# also requiring at least 10 genotypes from both E. roumanicus and E. europaeus
# the script available here: https://github.com/IgnasiLucas/hedgehog/tree/master/results/2018-09-26

