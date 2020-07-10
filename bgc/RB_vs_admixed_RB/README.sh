# 2020-05-05
#
# Here I will do bgc again but this
# time only for individuals in Russian-Baltic
# contact zone. I will use similar filtering strategy
# as with Bayescan and the same subset of individuals as with
# bayescan.

# here a took popmaps from latest bayescan directory and merged them
# and delete hybrids from first file because they were doubled.

# cat europaeus_admixed_russia_popmap.txt roumanicus_admixed_russia_popmap.txt > popmap_bgc_russia.txt


SOURCE_VCF=~/hedgehog/results_2020/2020-02-28
DATADIR=~/hedgehog/results_2020/2020-05-05


if [ ! -e bgc_russia.recode.vcf ]; then

   vcftools --vcf $SOURCE_VCF/all_merged_2020.vcf \
            --keep $DATADIR/popmap_bgc_russia.txt \
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
            --out $DATADIR/bgc_russia

fi

# I will use the sequencing error model as Ignasi noted in his folder data/joiglu/hedgehos/results/2018-12-15
# I need to install vcfpy: pip install vcfpy and pysam: pip install pysam

if [ ! -e popmap_bgc_russia_names.txt ]; then

awk ' { gsub("1","europaeus", $2);gsub("2","roumanicus", $2);gsub("7","admixed", $2);print } ' popmap_bgc_russia.txt > popmap_bgc_russia_names.txt
sed -i 's/ /\t/g' popmap_bgc_russia_names.txt

fi

 if [ ! -e bgc_strict_roumanicus.txt ] || [ ! -e bgc_strict_europaeus.txt ] || [ ! -e bgc_strict_admixed.txt ]; then
         python vcf2bgc.py -v bgc_russia.recode.vcf -0 roumanicus -1 europaeus -a admixed -u -e 0 -p bgc_russia_ popmap_bgc_russia_names.txt
 fi

# From Ignasi notes: I should run at least 2 chains to check for convergence.
# Even though only one will be used to estimate the posterior because I don't
# know how to combine hdf5 files, and I do want to take advantage of the estpost program that extracts
# puntual estimates and credibility intervals from hdf5. Preliminar runs suggest very little burnin is necessary.

if [ ! -e $DATADIR/mcmcout_1.hdf5 ] || [ ! -e $DATADIR/mcmcout_2.hdf5 ]; then
        bgc -a bgc_russia_roumanicus.txt \
          -b bgc_russia_europaeus.txt \
          -h bgc_russia_admixed.txt \
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
      bgc -a bgc_russia_roumanicus.txt \
          -b bgc_russia_europaeus.txt \
          -h bgc_russia_admixed.txt \
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
          plot_chains.R must take two input files and one output file.
         R --no-save < plot_chains.R --args ${param}_chain1.txt ${param}_chain2.txt ${param}_chains.png
      fi
   done

   # Summarize the results for this number of samples. Using only first chain.
   if [ ! -e positions.txt ]; then
      grep locus bgc_russia_admixed.txt | gawk '{split($2, A, /:/); print A[1] "\t" A[2]}' > positions.txt
   fi
  for param in alpha beta hi gamma-quantile zeta-quantile; do
      if [ ! -e ${param}.pdf ]; then
         if [ ! -e ${param}_estimates.txt ]; then
            estpost -i mcmcout_1.hdf5 -p $param -o ${param}_estimates.txt -c 0.80 -s 0 -w 0
         fi
	# plot_summary.R should take input file name and output, and figure out what to plot, depending on the input.
         R --no-save < plot_summary.R --args ${param}_estimates.txt positions.txt ${param}.pdf
      fi
   done

