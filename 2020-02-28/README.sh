# bin/bash!
#
# In this directory I would like to merge both
# our datasets. It could be done by running
# Freebayes with all our samples together, however
# Ignasi hit a point by assuming it would run for
# very long with standard settings.
#
# I created a popmap called popmap_all which includes
# all our samples sorted into species plus I created
# a hybrid category for all admixed individuals identified
# with Admixture. The file merged two previous popmap
# files popmap_2020 and hedgehog_populations_correct.
#
# I will use an option -g to skip regions with coverage
# higher then 1400 as Ignasi suggest to save same time.
#
# I am not sure freebayes can take input bam  files from two
# separate directiories, I suppose not, so I
# moved the older data with suffix msnc.bam into folder
# ~/hedgehog/results_2020/2020-01-30.

REFERENCE=~/hedgehog/data_2016/reference
SOURCE=~/hedgehog/results_2020/2020-01-30

 if [ ! -e all_merged_2020.vcf ]; then
 freebayes -f $REFERENCE/GCF_000296755.1_EriEur2.0_genomic.fna --skip-coverage 1400 --genotype-qualities --min-mapping-quality 15 --min-base-quality 15 \
 -b $SOURCE/*.bam > all_merged_2020.vcf &
 fi
 wait

# Now I will filter the obtained all_merged_2020.vcf
# Frm popmap_all_without_bad I excluded FR1 and PRT1
# GR95 and GR87 sample from first dataset known to be
# wrong/really bad quality.

DATADIR=~/hedgehog/results_2020/2020-02-28

if [ ! -e erinaceus_merged_2020_filt.recode.vcf ]; then

   vcftools --vcf $DATADIR/all_merged_2020.vcf \
            --keep popmap_erinaceus_without_bad.txt \
            --recode \
            --maf 0.0125 \
            --max-maf 0.9875 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 6 \
            --minQ 50 \
            --thin 261 \
            --max-missing 0.75 \
            --recode-INFO-all \
            --out $DATADIR/erinaceus_merged_2020_filt

fi

# Next I am curious about results of Admixture
# preparing chromosome map

gawk 'BEGIN{N=1}(/^##contig=<ID=/){split($1,A,/=|,/); print A[3] "\t" N; N++}' erinaceus_merged_2020_filt.recode.vcf > chromosome_map

# creating plink from vcf

vcftools --vcf erinaceus_merged_2020_filt.recode.vcf --plink --chrom-map chromosome_map --out erinaceus_all
# creationg bed

~/bin/plink-1.07-x86_64/plink --noweb --file erinaceus_all --make-bed --out erinaceus_all

# Next I run Admixture

for K in 2 3 4 5 6 7 8 9 10; \
do admixture --cv erinaceus_all.bed $K | tee log${K}.out; done

# to check CV errors:

grep -h CV log*.out

# Admixture for some reason finished with K6, then it basicaly
# stopped running.


