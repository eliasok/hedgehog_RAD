#!/bin/bash
# to keep only roumanicus/only europaeus to perform tess3 separately for each species

SOURCE=~/hedgehog/results_2018/24-07-2018
DATADIR=~/hedgehog/results_2018/06-06-2018/roumanicus

   vcftools --gzvcf $SOURCE/ErinMaxMiss63_r10e10c4.vcf \
            --recode \
            --recode-INFO-all \
            --keep $DATADIR/popmap_roumanicus.txt \ # popmap_europaeus.txt
            --out $DATADIR/roumanicus # europaeus

