# 2020-06-24
#
# Last time I will run BeayeScan to be sure all analyses were done
# the same way. No big changes so I expect same results as in folder
# ~/hedgehog/results_2020/2020-04-23 but I want to be sure. The main diffrence
# is the conversion via genepop file so I am sure individuals are correctly placed
# into populations. But I havent found anz mistake in regard to conversion. Also I
# remove filter wit minor and maximum allele frequency but I expect no diffrence either

SOURCE=~/hedgehog/results_2020/2020-02-28

if [ ! -e roumanicus_admixed_popmap_correct.txt ]; then

cp ~/hedgehog/results_2020/2020-04-23/roumanicus_admixed_popmap_correct.txt ~/hedgehog/results_2020/2020-06-16/RB_vs_admixed_RB
cp ~/hedgehog/results_2020/2020-04-23/europaeus_admixed_popmap_correct.txt ~/hedgehog/results_2020/2020-06-16/RB_vs_admixed_RB

fi

# I removed lines correcponding to CE individuals

# and I substitude 7 for 1 in popmap

if [ ! -e roumanicus_popmap.txt ]; then


awk ' { gsub("7","1", $2); print } ' roumanicus_admixed_popmap_correct.txt > roumanicus_popmap.txt

awk ' { gsub("7","2", $2); print } ' europaeus_admixed_popmap_correct.txt > europaeus_popmap.txt


fi

if [ ! -e roumanicus_bayescan_russia.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep roumanicus_popmap.txt \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 6 \
            --minQ 50 \
            --thin 261 \
            --max-missing 1 \
            --recode --recode-INFO QR --recode-INFO QA --recode-INFO RO --recode-INFO AO \
            --out roumanicus_bayescan_russia

fi

if [ ! -e europaeus_bayescan_russia.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep europaeus_popmap.txt \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 6 \
            --minQ 50 \
            --thin 261 \
            --max-missing 1 \
            --recode --recode-INFO QR --recode-INFO QA --recode-INFO RO --recode-INFO AO \
	    --out europaeus_bayescan_russia

fi


if [ ! -e roumanicus_bayescan_russia.genepop ]; then

populations -V europaeus_bayescan_russia.recode.vcf --out_path ~/hedgehog/results_2020/2020-06-16/RB_vs_admixed_RB -M europaeus_popmap.txt --genepop

populations -V roumanicus_bayescan_russia.recode.vcf --out_path ~/hedgehog/results_2020/2020-06-16/RB_vs_admixed_RB -M roumanicus_popmap.txt --genepop

fi


# after conversion with PGD Spider I run BayeScan

 BIN=~/bin/BayeScan2.1/binaries

 if [ ! -e europaeus_RB_admixed_bayescan100_fst.txt ]; then

 $BIN/./BayeScan2.1_linux64bits europaeus_RB_admixed_RB_bayescan.txt -threads 12 -o europaeus_RB_admixed_bayescan100 -od ~/hedgehog/results_2020/2020-06-16/RB_vs_admixed_RB -n 50000 \
 -thin 10 -nbp 20 -pilot 5000 -burn 50000 -pr_odds 100

 fi

 if [ ! -e roumanicus_RB_admixed_bayescan100_fst.txt ]; then

 $BIN/./BayeScan2.1_linux64bits roumanicus_RB_admixed_RB_bayescan.txt -threads 12 -o roumanicus_RB_admixed_bayescan100 -od ~/hedgehog/results_2020/2020-06-16/RB_vs_admixed_RB -n 50000 \
 -thin 10 -nbp 20 -pilot 5000 -burn 50000 -pr_odds 100

 fi


