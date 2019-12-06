#!/bin/bash
#
# Here I run FineRADstructure to inferr individuals coancestry. Available here: https://github.com/millanek/fineRADstructure
#
#
# I ran gstacks script with a)four populations/species as defined in popmap, b)as 1 population as defined in 
# popmap 2 (to test if there would be any difference). The script population.sh (4 populations) and populations2.sh 
# (1 population) was ran to create input file to RADpainter and fineRADstructure
#
# Following commands were used to run FineRADstructure

RADpainter paint populations.haps.radpainter

finestructure -x 500000 -y 1000000 -z 1000 populations.haps_chunks.out populations_chunks.mcmc.xml

finestructure -m T -x 10000 populations.haps_chunks.out populations_chunks.mcmc.xml populations_chunks.mcmcTree.xml

# The results were visualized in RStudio using provided script FineRADstructurePlot.R
#
# Important: necessary to modify original R script and set up "maxIndv" and "maxPop" to more then 1000 (I choose 100000)
#
# To plot the results of fineRADstructure I used R script of Milan Malinsky
# available here: https://github.com/millanek/fineRADstructure/blob/master/fineRADstructurePlot.R
