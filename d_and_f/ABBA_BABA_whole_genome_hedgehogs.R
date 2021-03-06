# Script to count ABBA/BABA sites across bat genome using modified script of Simon Martin,
# available here: https://github.com/simonhmartin/genomics_general
# a known phylogeny of Pipistrellus genus is (((concolor)(roumanicus))(europaeus))
# an input file was created using script freq2_pip.awk made by Ignasi. It uses allele frequencies
# for specified populations and also uses only variable sites where
# outgroup (Hemiechinus) is fixed for the ancestral allele.


### D

setwd("~/hedgehog/results_2018/2018-03-27b")

abba <- function(p1, p2, p3) (1 - p1) * p2 * p3

baba <- function(p1, p2, p3) p1 * (1 - p2) * p3

D.stat <- function(dataframe) (sum(dataframe$ABBA) - sum(dataframe$BABA)) / (sum(dataframe$ABBA) + sum(dataframe$BABA))


freq_table <- read.table("russia.tsv", header=T, as.is=T)


P1 = "concolor"
P2 = "roumanicus"
P3 = "europaeus"

ABBA <- abba(freq_table[,P1], freq_table[,P2], freq_table[,P3])
BABA <- baba(freq_table[,P1], freq_table[,P2], freq_table[,P3])

ABBA_BABA_df <- as.data.frame(cbind(ABBA,BABA))

D = D.stat(ABBA_BABA_df)


source("jackknife.R")

chrom_table <- read.table("chromosome_map")
chrom_lengths <- chrom_table[,2]
names(chrom_lengths) <- chrom_table[,1]

blocks <- get_genome_blocks(block_size=1e6, chrom_lengths=chrom_lengths)
n_blocks = nrow(blocks)
 
 indices <- get_genome_jackknife_indices(chromosome=freq_table$scaffold,
                                 position=freq_table$position,
                                 block_info=blocks) 
 
D_sd <- get_jackknife_sd(FUN=D.stat, input_dataframe=as.data.frame(cbind(ABBA,BABA)),
                          jackknife_indices=indices)
 
 
D_err <- D_sd/sqrt(n_blocks)
D_Z <- D / D_err
D_p <- 2*pnorm(-abs(D_Z))



#### f

abba <- function(p1, p2, p3) (1 - p1) * p2 * p3

baba <- function(p1, p2, p3) p1 * (1 - p2) * p3

D.stat <- function(dataframe) (sum(dataframe$ABBA) - sum(dataframe$BABA)) / (sum(dataframe$ABBA) + sum(dataframe$BABA))


freq_table <- read.table("russia_quantif.tsv", header=T, as.is=T)


ABBA_BABA_df <- as.data.frame(cbind(ABBA,BABA))



P1 = "concolor"
P2 = "roumanicus"
P3 = "europaeus1"

ABBA <- abba(freq_table[,P1], freq_table[,P2], freq_table[,P3])
BABA <- baba(freq_table[,P1], freq_table[,P2], freq_table[,P3])


D = D.stat(ABBA_BABA_df)

P1 = "concolor"
P2 = "roumanicus"
P3a = "europeaus1"
P3b = "europeaus2"

ABBA_1_2_3a <- abba(freq_table[,P1], freq_table[,P2], freq_table[,P3a])
BABA_1_2_3a <- baba(freq_table[,P1], freq_table[,P2], freq_table[,P3a])

ABBA_1_3b_3a <- abba(freq_table[,P1], freq_table[,P3b], freq_table[,P3a])
BABA_1_3b_3a <- baba(freq_table[,P1], freq_table[,P3b], freq_table[,P3a])

f <- (sum(ABBA_1_2_3a) - sum(BABA_1_2_3a))/
     (sum(ABBA_1_3b_3a) - sum(BABA_1_3b_3a))




