# Here I used Freebayes (https://github.com/ekg/freebayes)
# and Stacks (http://catchenlab.life.illinois.edu/stacks/)
# to call SNP variantion from sorted bam files. The main 
# difference is that Freebayes uses reference genome to call SNPs. 
# It has been set to call only sites with mapping quality and base
# quality higher then 15.
# Stacks component gstacks was set to remove unpaired reads and
# potential PCR duplicates and to omitt SNPs with mapping quality 
# below 30. I call variation with gstacks twice, using all individuals
# as a member of group (popmap2) and splitted into species (popmap)

