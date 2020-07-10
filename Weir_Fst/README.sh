# !/bin/bash
#
# I will count Weir´s Fst between species (Weir and Cockerham’s 1984) and
# identified lineages according to Admixture
# that is between Ibaerian and Apennine lineade of E. europaeus
# and Balkan and Asian lineage of E.roumanicus. I am primarily
# interested in difference between lineages of roumanicus
#
# I will use dataset for TreeMix since it contains all
# individuals of all species.

if [ ! -e treemix.recode.vcf ]; then
cp ~/hedgehog/results_2020/2020-06-05/treemix.recode.vcf ~/hedgehog/results_2020/2020-06-09b
cp ~/hedgehog/results_2020/2020-06-05/popmap_treemix.txt ~/hedgehog/results_2020/2020-06-09b
cp ~/hedgehog/results_2020/2020-06-05/popmap_treemix_lineages.txt ~/hedgehog/results_2020/2020-06-09b
fi

# I will use vcftools. First I need file corresponding to all populations
# I would like to compare


if [ ! -e roumanicus_balkan.txt ]; then
awk '{
if ($2 =="roum_South")
        print;
}' popmap_treemix_lineages.txt > roumanicus_balkan.txt
fi

if [ ! -e roumanicus_asian.txt ]; then
awk '{
if ($2 =="roum_North")
        print;
}' popmap_treemix_lineages.txt > roumanicus_asian.txt
fi

if [ ! -e europaeus_Apennine.txt ]; then
awk '{
if ($2 =="eur_Apennine")
        print;
}' popmap_treemix_lineages.txt > europaeus_Apennine.txt
fi

if [ ! -e europaeus_Iberian.txt ]; then
awk '{
if ($2 =="eur_Iberian")
        print;
}' popmap_treemix_lineages.txt > europaeus_Iberian.txt
fi

if [ ! -e concolor.txt ]; then
awk '{
if ($2 =="concolor")
        print;
}' popmap_treemix_lineages.txt > concolor.txt
fi

if [ ! -e amurensis.txt ]; then
awk '{
if ($2 =="amurensis")
        print;
}' popmap_treemix_lineages.txt > amurensis.txt
fi

if [ ! -e roumanicus.txt ]; then
awk '{
if ($2 =="roum_North" || $2 =="roum_South")
        print;
}' popmap_treemix_lineages.txt > roumanicus.txt
fi

if [ ! -e europaeus.txt ]; then
awk '{
if ($2 =="eur_Apennine" || $2 =="eur_Iberian")
        print;
}' popmap_treemix_lineages.txt > europaeus.txt
fi


# running vcftools --weir-fst between species

if [ ! -e concolor_vs_amurensis.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop concolor.txt --weir-fst-pop amurensis.txt --out concolor_vs_amurensis

fi

if [ ! -e europaeus_vs_amurensis.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop europaeus.txt --weir-fst-pop amurensis.txt --out europaeus_vs_amurensis

fi

if [ ! -e roumanicus_vs_amurensis.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop roumanicus.txt --weir-fst-pop amurensis.txt --out roumanicus_vs_amurensis

fi

if [ ! -e concolor_vs_roumanicus.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop concolor.txt --weir-fst-pop roumanicus.txt --out concolor_vs_roumanicus

fi

if [ ! -e concolor_vs_europaeus.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop concolor.txt --weir-fst-pop europaeus.txt --out concolor_vs_europaeus

fi

if [ ! -e roumanicus_vs_europaeus.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop roumanicus.txt --weir-fst-pop europaeus.txt --out roumanicus_vs_europaeus

fi


# between lineages of the same species

if [ ! -e roumanicus_asian_vs_roumanicus_balkan.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop roumanicus_asian.txt --weir-fst-pop roumanicus_balkan.txt --out roumanicus_asian_vs_roumanicus_balkan

fi

if [ ! -e europaeus_Iberian_vs_europaeus_Apennine.weir.fst ]; then

vcftools --vcf treemix.recode.vcf --weir-fst-pop europaeus_Iberian.txt --weir-fst-pop europaeus_Apennine.txt --out europaeus_Iberian_vs_europaeus_Apennine

fi

