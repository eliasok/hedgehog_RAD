#!/bin/bash
#
# script to run Admixture
# an input is vcf file converted to plink and to bed format


#preparing chromosome map
gawk 'BEGIN{N=1}(/^##contig=<ID=/){split($1,A,/=|,/); print A[3] "\t" N; N++}' erinaceus_41_r10e10c4.recode.vcf > chromosome_map

#creating plink from vcf
vcftools --vcf erinaceus_41_r10e10c4.recode.vcf --plink --chrom-map chromosome_map --out erinaceus_41_r10e10c4

#creationg bed
plink --noweb --file erinaceus_41_r10e10c4 --make-bed --out erinaceus_41_r10e10c4

#running Admixture

for K in 2 3 4 5 6 7 8 9 10 11 12; \
do admixture --cv erinaceus_41_r10e10c4.bed $K | tee log${K}.out; done

#to check CV errors:

grep -h CV log*.out

#to run Admixture after evaluating lowest K:

admixture -B erinaceus_41_r10e10c4 3

