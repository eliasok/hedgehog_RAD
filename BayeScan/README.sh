# 2020-05-02
#
# Here I would like to repeat the run of bayescan once more
# but this time I will include only individuals from Russian
# contact zone. It makes more sense to do it just for them, because the selective
# pressure might be different in each of two zones. The results would be
# easier to interpret. Only disadvantage is that the number of individuals
# will be lower.

# I will filter it with --max-missing 2 option, allowing no missing data per site

SOURCE=~/hedgehog/results_2020/2020-02-28
DATADIR=~/hedgehog/results_2020/2020-05-02

if [ ! -e europaeus_bayescan_russia.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep $DATADIR/europaeus_admixed_russia_popmap.txt \
            --maf 0.0125 \
            --max-maf 0.987 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 6 \
            --minQ 50 \
            --thin 261 \
            --max-missing-count 2 \
            --recode --recode-INFO QR --recode-INFO QA --recode-INFO RO --recode-INFO AO \
            --out $DATADIR/europaeus_bayescan_russia

fi

if [ ! -e roumanicus_bayescan_russia.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep $DATADIR/roumanicus_admixed_russia_popmap.txt \
            --maf 0.0125 \
            --max-maf 0.987 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 6 \
            --minQ 50 \
            --thin 261 \
            --max-missing-count 2 \
            --recode --recode-INFO QR --recode-INFO QA --recode-INFO RO --recode-INFO AO \
	    --out $DATADIR/roumanicus_bayescan_russia

fi

# I converted vcf files into bayescan using my laptop and PGDSpider
# with spid protocol. Optionally I will provide popmap to PGDspider
# with individuals ordered by the vcf files

if [ ! -e popmap_PGD_roumanicus.txt ]; then

vcftools --vcf roumanicus_bayescan_russia.recode.vcf --012 --out roumanicus

awk 'FNR==NR {x2[$1] = $0; next} $1 in x2 {print x2[$1]}'  roumanicus_admixed_russia_popmap.txt roumanicus.012.indv > popmap_PGD_roumanicus.txt

fi

if [ ! -e popmap_PGD_europaeus.txt ]; then

vcftools --vcf europaeus_bayescan_russia.recode.vcf --012 --out europaeus

awk 'FNR==NR {x2[$1] = $0; next} $1 in x2 {print x2[$1]}'  europaeus_admixed_russia_popmap.txt europaeus.012.indv > popmap_PGD_europaeus.txt

fi


# Next I will run bayescan

BIN=~/bin/BayeScan2.1/binaries

if [ ! -e europaeus_admixed_russia_bayescan100_fst.txt ]; then

$BIN/./BayeScan2.1_linux64bits europaeus_vcf_to_bayescan.txt -threads 6 -o europaeus_admixed_russia_bayescan100 -od ~/hedgehog/results_2020/2020-05-02 -n 50000 \
-thin 10 -nbp 20 -pilot 5000 -burn 50000 -pr_odds 100

fi

if [ ! -e roumanicus_admixed_russia_bayescan100_fst.txt ]; then

$BIN/./BayeScan2.1_linux64bits roumanicus_vcf_to_bayescan.txt -threads 6 -o roumanicus_admixed_russia_bayescan100 -od ~/hedgehog/results_2020/2020-05-02 -n 50000 \
-thin 10 -nbp 20 -pilot 5000 -burn 50000 -pr_odds 100

fi

# creating a list of SNPs for plot

if [ ! -e list_of_snps_europaeus ]; then

vcftools --vcf europaeus_bayescan_russia.recode.vcf --missing-site --out europaeus

awk '{ print $1 $2 }' europaeus.lmiss > list_of_snps_europaeus

fi

if [ ! -e list_of_snps_roumanicus ]; then

vcftools --vcf roumanicus_bayescan_russia.recode.vcf --missing-site --out roumanicus

awk '{ print $1 $2 }' roumanicus.lmiss > list_of_snps_roumanicus

fi

# finally I will plot the results with BayeScan provided script plot_R.r

# Ok. The results are still the same as I expected, that is good. It detects no loci under
# diversifying selection. The Fst is even higher. I actually have never seen such high number.
# but I was never comparing hybrids with pure species, only populations.
