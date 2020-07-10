# 2020-05-08
#
# Here I would like to count the D statistic for second,
# Russian contact zone.I followed Ignasi script from
# 2018-03-27b. I will do abbababa with 'pure' individuals
# of both species, I will use the Hemiechinus as outgroup
# and concolor as third species as usually.
#
# NOTE: I was filtering vcf by indviduals after adding flags which
# makes the flags useless. I will remake it
#
# I will make copy of all_merged_2020.vcf, I will filter
# what I need to filter and then I will add flags

VCF=~/hedgehog/results_2020/2020-02-28

# creating popmap

if [ ! -e popmap_D_russia.txt ]; then
awk '{
if ($2 =="1" || $2 =="2"|| $2 =="3"|| $2 =="5")
        print;
}' popmap_all_correct > popmap_D

fi

# I deleted all lines from first dataset apart from concolor and Hemiechinus

if [ ! -e popmap_D_russia.txt ]; then

awk ' { gsub("1","europaeus", $2);gsub("2","roumanicus", $2);gsub("3","concolor", $2);gsub("5","Hemiechinus", $2); print } ' popmap_D > popmap_D_russia.txt
sed -i 's/ /\t/g' popmap_D_russia.txt
rm popmap_D

fi

# Here I will filter dataset the same way as was
# filtered the previous dataset from Central Europe
# only

if [ ! -e russia_D.recode.vcf ]; then


vcftools --vcf $VCF/all_merged_2020.vcf \
            --keep popmap_D_russia.txt \
            --minQ 50 \
            --thin 261 \
            --maxDP 200 \
            --remove-indels \
            --recode \
            --recode-INFO-all \
            --maf 0.0125 \
            --max-maf 0.987 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 4 \
	    --out filtered
fi


if [ ! -e flagged.vcf ]; then

gawk -f add_flag.awk filtered.recode.vcf > flagged.vcf

fi

# to create popmap.txt (hardcoded in freq2.awk) I need to sort
# original popmap_D_russia.txt based on order of infividuals
# in the vcf

if [ ! -e popmap.txt ]; then

vcftools --vcf flagged.vcf --012 --out russia

awk 'FNR==NR {x2[$1] = $0; next} $1 in x2 {print x2[$1]}'  popmap_D_russia.txt russia.012.indv > popmap.txt

fi

# I will use Ignasi freq2.awk

if [ ! -e russia.tsv ]; then
   gawk -v P1=concolor -v P2=roumanicus -v P3=europaeus -v OUTGROUP=Hemiechinus -f freq2.awk popmap.txt flagged.vcf > russia.tsv
fi

# this time it works. It retained sites
# and the D is higly positive 0.279 and totally
# significant, p is zero. That is the results I would
# expect.

# to quantify introgression I will split the erinaceus
# in the popmap.txt to two populations named 1 and 2
# and count the D again


if [ ! -e russia_quantif.tsv ]; then
   gawk -v P1=concolor -v P2=roumanicus -v P3=europaeus -v P4=europaeus -v OUTGROUP=Hemiechinus -f freq2_quantif.awk popmap2.txt flagged.vcf > russia_quantif.tsv
fi

