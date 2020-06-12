# After talking with Barbora nad Pavel I agreed
# to diffrent publication strategy. To split papers
# to one comparing two hybrid zones and second focused
# on selection.
# They suggest to do PCA and DAPC with all the samples
# from both contact zones so that what I will do here.


# first I will filter data. I will exclude some more indidivuals
# then in the original admixture file in 2020-02-28. GR24 and GR28 among them,
# because they were supposed to be concolor but clearly are roumanicus
# likely some mistake on my side, those were some Barboras old isolates
# without marks, just coordinates in excle file, so I may took wrong, or
# they were displaced during all those years.
# I will use era_popmap.txt from previous 2020-04-13 which containes
# individuals with good quality but only rouamnicus and europaeus and hybrids.
# I will add concolor and amurensis

if [ ! -e popmap_erca_only_good.txt ]; then
awk '{
if ($2 =="3" || $2 == "4")
        print;
}' popmap_all > add.txt

cat add.txt era_popmap.txt >  popmap_erca_only_good.txt

sed -i '8,9d' popmap_erca_only_good.txt

fi

# I deleted two lines with GR28 and GR24
# I will do PCA with only roumanicus, europaes and concolor and amurensis
# later only with roumanicus and europaeus


DATADIR=~/hedgehog/results_2020/2020-04-20
SOURCE=~/hedgehog/results_2020/2020-02-28

if [ ! -e erinaceus_merged_2020_only_good.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep popmap_erca_only_good.txt \
            --recode \
            --maf 0.0125 \
            --max-maf 0.987 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 4 \
            --minQ 50 \
            --thin 261 \
            --max-missing 0.85 \
            --recode-INFO-all \
            --out $DATADIR/erinaceus_merged_2020_only_good

fi

# I will use previously created popmap in ~/hedgehog/results_2020/2020-04-13 with only roumanicus and europaeus

if [ ! -e eur_roum_merged_2020.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep era_popmap.txt \
            --recode \
            --maf 0.0125 \
            --max-maf 0.987 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 4 \
            --minQ 50 \
            --thin 261 \
            --max-missing 0.85 \
            --recode-INFO-all \
            --out $DATADIR/eur_roum_merged_2020

fi


# Creating the input for Adegenet:

if [ ! -e erinaceus_merged_2020_only_good.012 ]; then
vcftools --vcf erinaceus_merged_2020_only_good.recode.vcf --012 --out erinaceus_merged_2020_only_good
sed -i 's/-1/NA/g' erinaceus_merged_2020_only_good.012
awk '{$1=""; print $0}' erinaceus_merged_2020_only_good.012 > SNP_erinaceus
fi


if [ ! -e eur_roum_merged_2020.012 ]; then
vcftools --vcf eur_roum_merged_2020.recode.vcf --012 --out eur_roum_merged_2020
sed -i 's/-1/NA/g' eur_roum_merged_2020.012
awk '{$1=""; print $0}' eur_roum_merged_2020.012 > SNP_eur_roum
fi


# to create file with names for Adegenet:
# in this command I need to check manually first line
# I havent found any easier solution for this simple task with awk yet

awk '{RS=OFS;$1=$1}1' erinaceus_merged_2020_only_good.012.indv > indiv_erinaceus_merged_2020_only_good.reverse

awk '{RS=OFS;$1=$1}1' eur_roum_merged_2020.012.indv > indiv_eur_roum_merged_2020.reverse


# Creating popmap for Adegenet for O12 sorted file. Dont forget popmap has to match order of individuals in 012.indv file
# Well I had to edit  erinaceus_merged_2020_only_good.012.indv first to add species mark
# manually because I didnt know the way to extract information from a diffrently sorted popmap file

awk ' { gsub("1","europaeus", $2);gsub("2","roumanicus", $2);gsub("7","admixed", $2);gsub("3","concolor", $2)gsub("4","amurensis", $2); print } ' erinaceus_merged_2020_only_good.012.indv > popmap_erinaceus_merged_2020_only_good_adegenet.txt

awk ' { gsub("1","europaeus", $2);gsub("2","roumanicus", $2);gsub("7","admixed", $2); print } ' eur_roum_merged_2020.012.indv > popmap_eur_roum_merged_2020.txt

# and back to create plot only with numbers

awk ' { gsub("roumanicus_North","1", $2);gsub("roumanicus_South","2", $2);gsub("europaeus_Apennine","3", $2);gsub("europaeus_Iberian","4", $2);gsub("admixed_Russia-Baltic","5", $2);gsub("admixed_Central_Europe","6", $2); print } ' popmap_eur_roum_merged_2020_lineage.txt > popmap_eur_roum_merged_2020_lineage_number.txt

 awk ' { gsub("roumanicus","1", $2);gsub("europaeus","2", $2);gsub("admixed","3", $2);print }  ' popmap_eur_roum_merged_2020.txt > popmap_eur_roum_numbers.txt

