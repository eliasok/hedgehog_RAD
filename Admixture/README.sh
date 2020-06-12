# I will do final run of Admixture for our article using
# file filtered in results_2020/2020-04-20 which includes all
# four speices and bad individuals are removed but I will use
# 100 iterations this time

# preparing chromosome map

SOURCE=~/hedgehog/results_2020/2020-04-20

if [ ! -e chromosome_map ]; then

gawk 'BEGIN{N=1}(/^##contig=<ID=/){split($1,A,/=|,/); print A[3] "\t" N; N++}' $SOURCE/erinaceus_merged_2020_only_good.recode.vcf > chromosome_map

fi

# creating plink from vcf

if [ ! -e erinaceus_all_2020.ped ]; then

vcftools --vcf $SOURCE/erinaceus_merged_2020_only_good.recode.vcf --plink --chrom-map chromosome_map --out erinaceus_all_2020

fi

# creationg bed


if [ ! -e erinaceus_all_2020.bed ]; then

~/bin/plink-1.07-x86_64/plink --noweb --file erinaceus_all_2020 --make-bed --out erinaceus_all_2020

fi

# Next I run Admixture

if [ ! -e erinaceus_all_2020.2.Q ]; then

for K in 2 3 4 5 6 7 8 9 10; \
do admixture --cv erinaceus_all_2020.bed -C 100 $K | tee log${K}.out; done

fi

# to check CV errors:

grep -h CV log*.out

# to get individuals names from vcf

if [ ! -e erinaceus_merged_2020_only_good.recode.012 ]; then

vcftools --vcf $SOURCE/erinaceus_merged_2020_only_good.recode.vcf --012 --out erinaceus_merged_2020_only_good

fi


# Aditionally to plot results I will need popmap and I took that from ~/hedgehog/results_2020/2020-04-20
# erinaceus_merged_2020_only_good.012.indv which is already manipulated file with added pop information

awk ' {print $2} '  erinaceus_merged_2020_only_good.012.indv > group_map.txt

# I will add column to group_map.txt so I can order the results of admixture this way.
# I cannot do it with scripts since I am not sure how. I need to see it and think about colors of the plot
