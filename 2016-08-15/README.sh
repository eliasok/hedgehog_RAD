#!/bin/bash
#
#2016-08-15
#
#Mapping reads to the reference genome EriEur2 (http://pre.ensembl.org/Erinaceus_europaeus/
#Info/Index) using Bowtie2 in very sensitive mode

SAMPLE=(Er51_436
Er52_451
Er53_ASR7
Er54_AU1
Er55_AU7
Er56_AZ5
Er57_COR4
Er58_FI7
Er59_FR1
Er60_GR5
Er61_GR87
Er62_GR95
Er63_IR6
Er64_IS1
Er65_IS25
Er66_IT3
Er67_IT5
Er68_PRT1B
Er69_R2
Er70_RMN42
Er71_SAR2
Er72_SIE1B
Er73_SNG1
Er74_SP16
Er75_TRC2A)

for i in `seq 0 24`; do

   bowtie2 --very-sensitive \
           -x reference_erinaceus \
           -q \
           -1 ${SAMPLE[$i]}_R1.fastq.gz \
           -2 ${SAMPLE[$i]}_R2.fastq.gz \
           --maxins 1000 \
           --fr \
           --no-mixed \
           --un-conc ${SAMPLE[$i]}_unmapped.fq \
           --rg-id ${SAMPLE[$i]} \
           --rg "PL:ILLUMINA" \
           --rg "DT:2016" \
           --rg "SM:"${SAMPLE[$i]} \
           --met-stderr \
           -S ${SAMPLE[$i]}.sam 2> ${SAMPLE[$i]}_bowtie2.log &
done
wait

#Options:
#-q standard input, .fastq
#--maxins maximum fragment length
#--fr mates align forward/reverse
#--no mixed suppress unpaired alignments for paired reads
#--un-conc write pairs that didn't align concordantly
#--rg flag, SAM header -id, type, date, sample name (SM, necessary if using FreeBayes
#as a variant detector in the next step)
#-S standard output, .sam and send protocol about alignment to .log

