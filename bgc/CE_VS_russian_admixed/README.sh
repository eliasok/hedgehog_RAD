# 2020-06-24
#
# After using more comparison with BayeScan I feel
# necessity apply the same logic with bgc. The comparison
# with BayeScan included a) RB pure population of each species
# vs admixed individuals b) pure population from Central Europe
# c) pure species from CE(balkan and apennine lineage) vs admixed russian samples. The logic
# is simplz to find some signs of selection. There may not be any
# in Russia but there should be in CE. Well, it does not looks
# like there is something either. However here I will rone once
# more bgc but this time for pure CE individuals of both species
# vs russian admixed individuals



if [ ! -e popmap_admixed_RB ]; then

cp ~/hedgehog/results_2020/2020-05-05/vcf2bgc.py ~/hedgehog/results_2020/2020-06-24
cp ~/hedgehog/results_2020/2020-05-05/plot_chains.R ~/hedgehog/results_2020/2020-06-24
cp ~/hedgehog/results_2020/2020-05-05/plot_summary.R ~/hedgehog/results_2020/2020-06-24

cp ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure/popmap_CE_pure_europaeus ~/hedgehog/results_2020/2020-06-24
cp ~/hedgehog/results_2020/2020-06-16/CE_vs_RB_pure/popmap_CE_pure_roumanicus ~/hedgehog/results_2020/2020-06-24
cp ~/hedgehog/results_2020/2020-06-16/CE_vs_russian_admixed/popmap_admixed_RB ~/hedgehog/results_2020/2020-06-24

cat popmap_CE_pure_europaeus popmap_CE_pure_roumanicus popmap_admixed_RB > popmap_bgc_CE_vs_russian_admixed.txt

fi



SOURCE_VCF=~/hedgehog/results_2020/2020-02-28

if [ ! -e bgc_CE_admixed_russia.recode.vcf ]; then

   vcftools --vcf $SOURCE_VCF/all_merged_2020.vcf \
            --keep popmap_bgc_CE_vs_russian_admixed_names.txt \
            --maf 0.0125 \
            --max-maf 0.987 \
            --remove-indels \
            --min-alleles 2 \
            --max-alleles 2 \
            --maxDP 200 \
            --minDP 4 \
            --minQ 50 \
            --thin 261 \
            --max-missing-count 2 \
            --recode --recode-INFO QR --recode-INFO QA --recode-INFO RO --recode-INFO AO \
            --out bgc_CE_admixed_russia

fi

# after filtering all individuals I ended up with 500 SNPs so I decided to exclude few individuals from CE
# then I got ~3000 SNPs

# I will use the sequencing error model as Ignasi noted in his folder data/joiglu/hedgehos/results/2018-12-15
# I need to install vcfpy: pip install vcfpy and pysam: pip install pysam

 if [ ! -e popmap_bgc_CE_vs_russian_admixed_names.txt ]; then

 awk ' { gsub("1","europaeus", $2);gsub("2","roumanicus", $2);gsub("7","admixed", $2);print } ' popmap_bgc_CE_vs_russian_admixed.txt > popmap_bgc_CE_vs_russian_admixed_names.txt
 sed -i 's/ /\t/g' popmap_bgc_CE_vs_russian_admixed_names.txt

 fi

 if [ ! -e bgc_CE_russia_admixed.txt ] || [ ! -e bgc_CE_russia_europaeus.txt ] || [ ! -e bgc_CE_russia_roumanicus.txt ]; then
         python vcf2bgc.py -v bgc_CE_admixed_russia.recode.vcf -0 roumanicus -1 europaeus -a admixed -u -e 0 -p bgc_CE_russia_  popmap_bgc_CE_vs_russian_admixed_names.txt
 fi

# From Ignasi notes: I should run at least 2 chains to check for convergence.
# Even though only one will be used to estimate the posterior because I don't
# know how to combine hdf5 files, and I do want to take advantage of the estpost program that extracts
# puntual estimates and credibility intervals from hdf5. Preliminar runs suggest very little burnin is necessary.

if [ ! -e $DATADIR/mcmcout_1.hdf5 ] || [ ! -e $DATADIR/mcmcout_2.hdf5 ]; then
       bgc -a bgc_CE_russia_roumanicus.txt \
          -b bgc_CE_russia_europaeus.txt \
          -h bgc_CE_russia_admixed.txt \
          -F mcmcout_1 \
          -O 0 \
          -x 150000 \
          -n  10000 \
          -t 100 \
          -p 2 \
          -q 1 \
          -N 1 \
          -E 1 \
          -o 1 &> mcmc_1.log &

      # Ignasi note: bgc's random number generator is seeded by rand(), which is seeded in turn by the clock.
      # To get two truely independent chains, I need to start them at different times.
      sleep 3
      bgc -a bgc_CE_russia_roumanicus.txt \
          -b bgc_CE_russia_europaeus.txt \
          -h bgc_CE_russia_admixed.txt \
          -F mcmcout_2 \
          -O 0 \
          -x 150000 \
          -n  10000 \
          -t 100 \
          -p 2 \
          -q 1 \
          -N 1 \
          -E 1 \
          -o 1 &>mcmc_2.log &
   fi


#   # Check for convergence and mixture:
   for param in LnL alpha beta; do
    if [ ! -e chains.png ]; then
         for chain in 1 2; do
            if [ ! -e ${param}_chain${chain}.txt ]; then
               estpost -i mcmcout_${chain}.hdf5 -p $param -o ${param}_chain${chain}.txt -s 2 -w 0
            fi
         done
         #plot_chains.R must take two input files and one output file.
         R --no-save < plot_chains.R --args ${param}_chain1.txt ${param}_chain2.txt ${param}_chains.png
     fi
   done

   # Summarize the results for this number of samples. Using only first chain.
   if [ ! -e positions.txt ]; then
      grep locus bgc_CE_russia_admixed.txt | gawk '{split($2, A, /:/); print A[1] "\t" A[2]}' > positions.txt
  fi
  for param in alpha beta hi gamma-quantile zeta-quantile; do
      if [ ! -e ${param}.pdf ]; then
        if [ ! -e ${param}_estimates.txt ]; then
            estpost -i mcmcout_1.hdf5 -p $param -o ${param}_estimates.txt -c 0.80 -s 0 -w 0
         fi
	 #plot_summary.R should take input file name and output, and figure out what to plot, depending on the input.
         R --no-save < plot_summary.R --args ${param}_estimates.txt positions.txt ${param}.pdf
      fi
   done
