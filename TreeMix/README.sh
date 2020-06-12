# 05-06-2020
#
# Here I would like to performed Treemix (Pickrell and Pritchard 2012)
# to visualize gene flow between genetic lineages of hedgehogs. I will
# split population according to Admixture again.
# Manual here: manual here: http://gensoft.pasteur.fr/docs/treemix/1.12/treemix_manual_10_1_2012.pdf


# I need an vcf with all Erinaceus species without bad individuals plus Hemiechinus
# Treemix is using allele frequencies so I can use all samples. But I am afraid I will
# need to create new vcf with both zones and Hemiechinus

if [ ! -e popmap_all_correct ]; then

cp ~/hedgehog/results_2020/2020-04-20/popmap_all_correct  ~/hedgehog/results_2020/2020-06-05

fi

DATADIR=~/hedgehog/results_2020/2020-06-05
SOURCE=~/hedgehog/results_2020/2020-02-28

if [ ! -e popmap_treemix.txt ]; then
awk '{
if ($2 =="1" || $2 =="2" ||$2 =="3" || $2 == "4" || $2 =="5" || $2 =="7")
        print;
}' popmap_all_correct > popmap

awk ' { gsub("1","europaeus", $2);gsub("2","roumanicus", $2);gsub("7","admixed", $2);gsub("3","concolor", $2)gsub("4","amurensis", $2);gsub("5","Hemiechinus", $2); print } ' popmap > popmap2
sed -e 's/ /\t/g' popmap2 > popmap_treemix.txt
rm popmap popmap2
fi


if [ ! -e treemix.recode.vcf ]; then

   vcftools --vcf $SOURCE/all_merged_2020.vcf \
            --keep popmap_treemix.txt \
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
            --out $DATADIR/treemix

fi



if [ ! -e treemix.recode.treemix.log ]; then

populations --in_vcf treemix.recode.vcf --popmap popmap_treemix.txt --treemix --out_path  ~/hedgehog/results_2020/2020-06-05/lineages

fi

cd ~/hedgehog/results_2020/2020-06-05/lineages

 sed -i '1d' treemix.recode.treemix



if [ ! -e treemix.recode.treemix.gz ]; then

gzip treemix.recode.treemix

fi

# to run treemix with one migration event

if [ ! -e out_stem1.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 1 -o out_stem1

fi

# with 2


if [ ! -e out_stem2.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 2 -o out_stem2

fi

# with 3


if [ ! -e out_stem3.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 3 -o out_stem3

fi

# with 4

if [ ! -e out_stem4.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 4 -o out_stem4

fi


# with 5


if [ ! -e out_stem5.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 5 -o out_stem5

fi

# with 6


if [ ! -e out_stem6.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 6 -o out_stem6

fi

# and no migration

if [ ! -e out_stem7.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -o out_stem7

fi


# Now I have to edit popmap_treemix.txt manually according to Admixture
# and add lineages to roumanicus and europeaus plus split admixed population
# to both zones. I will name new popmap file popmap_treemix_lineages.txt

if [ ! -e treemix_lineages.recode.treemix ]; then

populations --in_vcf treemix.recode.vcf --popmap popmap_treemix_lineages.txt --treemix --out_path  ~/hedgehog/results_2020/2020-06-05/lineages

fi

cd ~/hedgehog/results_2020/2020-06-05/lineages
sed -i '1d' treemix.recode.treemix

if [ ! -e treemix.recode.treemix.gz ]; then

gzip treemix.recode.treemix

fi

# to run treemix with one migration event

if [ ! -e out_stem1.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 1 -o out_stem1

fi

# with 2


if [ ! -e out_stem2.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 2 -o out_stem2

fi

# with 3


if [ ! -e out_stem3.treeout.gz ]; then

treemix -i treemix.recode.treemix.gz -root Hemiechinus -m 3 -o out_stem3


