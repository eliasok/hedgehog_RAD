#!/bin/bash
#
#2016-08-04
#
#Trimming overrepresented sequences identified by FastQC as belonging to Illumina primers.
#
#File adaptersII.fasta represents two sequences of Illumina primers as identified by FastQC.

SAMPLE=(Er51_436
Er52_451
Er53_ASR7
Er54_AU1
Er55_AU7
Er56_AZ5
Er57_COR4
Er58_FI7
Er59_FR1
Er60_GR
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
cutadapt    -a file:adaptersII.fasta  \
            -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCC \
            -o ${SAMPLE[$i]}_R1.fastq.gz \
            -p ${SAMPLE[$i]}_R2.fastq.gz \
            -q 17 \
            ${SAMPLE[$i]}_1.fastq.gz \
            ${SAMPLE[$i]}_2.fastq.gz > ${SAMPLE[$i]}_cutadapt.log &
done

#Options:
#-a sequence of an adapter that was ligated to the 3' end - foreward read, Illumina primer 2
#-A 3' adapter to be removed from second read in a pair - reverse read, Illumina primer 1
#-o, -p specify an output file
#-q trim low-quality bases from 3' ends of read before adapter removal,
# which have phred quality score below threshold 17
