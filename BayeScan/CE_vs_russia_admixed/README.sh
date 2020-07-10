# Barbora suggests other comparison - compare pure population from CE with pure from RB population

SOURCE=~/hedgehog/results_2020/2020-02-28

if [ ! -e popmap_CE.txt ]; then

cp ~/hedgehog/results_2020/2020-06-16/popmap_CE.txt ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure

fi

if [ ! -e popmap_CE_pure_roumanicus ]; then
awk '{
if ( $2 =="2")
        print;
}' popmap_CE.txt > popmap_CE_pure_roumanicus

fi


if [ ! -e popmap_CE_pure_europaeus ]; then
awk '{
if ( $2 =="1")
        print;
}' popmap_CE.txt > popmap_CE_pure_europaeus

fi

if [ ! -e roumanicus_admixed_russia_popmap.txt ]; then

cp ~/hedgehog/results_2020/2020-05-02/roumanicus_admixed_russia_popmap.txt ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure
cp ~/hedgehog/results_2020/2020-05-02/europaeus_admixed_russia_popmap.txt ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure

fi

if [ ! -e popmap_RB_pure_roumanicus ]; then
awk '{
if ( $2 =="2")
        print;
}' roumanicus_admixed_russia_popmap.txt > popmap_RB_pure_roumanicus

fi

if [ ! -e popmap_RB_pure_europaeus ]; then
awk '{
if ( $2 =="1")
        print;
}' europaeus_admixed_russia_popmap.txt > popmap_RB_pure_europaeus

fi

if [ ! -e popmap_pure_roumanicus.txt ]; then

cat  popmap_RB_pure_roumanicus popmap_CE_pure_roumanicus > popmap_pure_roumanicus.txt

cat  popmap_RB_pure_europaeus popmap_CE_pure_europaeus > popmap_pure_europaeus.txt

fi

# I  edit it popmap of roumanicus and europaeus manually, just to split tmen into two
# population according to contact zone

if [ ! -e CE_RB_pure_roumanicus.recode.vcf ]; then

  vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep popmap_pure_roumanicus.txt \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 6 \
            --minQ 50 \
            --thin 261 \
            --max-missing 0.9 \
            --recode --recode-INFO QR --recode-INFO QA --recode-INFO RO --recode-INFO AO \
            --out CE_RB_pure_roumanicus

fi

if [ ! -e CE_RB_pure_europaeus.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep popmap_pure_europaeus.txt \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 6 \
            --minQ 50 \
            --thin 261 \
            --max-missing 0.85 \
            --recode --recode-INFO QR --recode-INFO QA --recode-INFO RO --recode-INFO AO \
	    --out CE_RB_pure_europaeus

fi


if [ ! -e CE_RB_pure_europaeus.genepop ]; then

populations -V CE_RB_pure_europaeus.recode.vcf --out_path ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure -M popmap_pure_europaeus.txt --genepop

populations -V CE_RB_pure_roumanicus.recode.vcf --out_path ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure -M popmap_pure_roumanicus.txt --genepop

fi

# after conversion with PGD Spider I run BayeScan

 BIN=~/bin/BayeScan2.1/binaries

 if [ ! -e CE_RB_pure_europaeus_bayescan100_fst.txt ]; then

 $BIN/./BayeScan2.1_linux64bits CE_RB_pure_europaeus_bayescan.txt  -threads 12 -o CE_RB_pure_europaeus_bayescan100 -od ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure -n 50000 \
 -thin 10 -nbp 20 -pilot 5000 -burn 50000 -pr_odds 100

 fi

 if [ ! -e CE_RB_pure_roumanicus_bayescan100_fst.txt ]; then

 $BIN/./BayeScan2.1_linux64bits CE_RB_pure_roumanicus_bayescan.txt  -threads 12 -o CE_RB_pure_roumanicus_bayescan100 -od ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure -n 50000 \
 -thin 10 -nbp 20 -pilot 5000 -burn 50000 -pr_odds 100

 fi




