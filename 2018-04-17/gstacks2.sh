DATADIR=~/hedgehog/results_2018/17-04-2018
BAM=~/hedgehog/data_2018/merged_bam

gstacks -I $BAM -O $DATADIR -M $DATADIR/popmap --rm-unpaired-reads --rm-pcr-duplicates --min-mapq 30 -t 5 --details
