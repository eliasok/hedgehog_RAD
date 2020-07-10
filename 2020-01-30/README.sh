#!/bin/bash
#
# 2020-28-01
#
# Mapping fastq files in ~/hedgehog/data_2020 to the reference genome EriEur2
# (http://pre.ensembl.org/Erinaceus_europaeus/Info/Index).
# I installed bowtie2 and remade previously used script to be suitable
# for single end data. I am not sure how or if I could improve the process for
# single reads as it can be done with paired end (like supressing alignment
# of unpaired reads and so on) so I left it in sensitive mode with basic settings at least for now.



REFERENCE=~/hedgehog/data_2016/reference
DATADIR=~/hedgehog/results_2020/2020-01-30

SAMPLE=(Er76_Ch8f
Er77_Ch18f
Er78_Ch11
Er79_Ch19
Er80_Ch23
Er81_Ch44
Er82_Ch53
Er83_Ea108
Er84_Ea091
Er85_TuE2
Er86_Tv1302
Er87_Tv161
Er88_PTZ092
Er89_PTZ1301
Er90_PTZ1303
Er91_GR24
Er92_GR28
Er93_ZBS073
Er94_ZBS093
Er95_ZBS104
Er96_ZBS1011
Er97_ZBS1015
Er98_ZBS103.111
Er99_ZBS122
Er100_ZBS133
Er101_ZBS135
Er102_ZBS1675
Er103_ZBSTvE8
Er104_Kal121
Er105_Vor151
Er106_NGE1
Er107_Kos27
Er108_VLD2013
Er109_NVB
Er110_Krasngr
Er111_Saratov111
Er112_Samara171
Er113_KaluE6
Er114_Penza171
Er115_VortsaE12)

for i in `seq 0 39`; do
 if [ ! -e Er76_Ch8f.sam ]; then
      bowtie2 --very-sensitive \
           -x $REFERENCE/reference_erinaceus \
           -U $DATADIR/${SAMPLE[$i]}.fastq.gz \
           --un-conc $DATADIR/${SAMPLE[$i]}_unmapped.fq \
           --rg-id $DATADIR/${SAMPLE[$i]} \
           --rg "PL:ILLUMINA" \
           --rg "DT:2020" \
           --rg "SM:"${SAMPLE[$i]} \
           --met-stderr \
           -S $DATADIR/${SAMPLE[$i]}.sam 2> $DATADIR/${SAMPLE[$i]}_bowtie2.log &
 fi
done
wait

#Options:
#
# -U unpaired input
# -x index for the reference genome
#--un-conc write pairs that didn't align concordantly
#--rg flag, SAM header -id, type, date, sample name (SM, necessary if using FreeBayes
# as a variant detector in the next step)
#-S standard output, .sam and send protocol about alignment to .log
#
#
#
# The mapping has finished with quite good mapping success ~80%
# however there is much bigger number of reads aligned more then one
# time (~20%) in comparison to paired end data (~5%). I was expecting
# something like that, since there is no second read in known
# distance which would make the mapping more accurate.
#
#
#
# A conversion from sam to bam follows here:

./samtools_view_2020.sh

# Sorting reads:

./samtools_sort_2020.sh

# Indexing reads

./samtools_index_all.sh

# Then I prepared z1 file with command

samtools view -H Er99_ZBS122_sorted.bam | grep "@SQ" | gawk '{C=substr($2,4); L=substr($3,4); print C "\t" 1 "\t" L}' > z1

# from z1 file I removed a header corresponding to mitochondrial sequences NC_002080.2
# at the end of a file. To get nuclear bam only:

./get_nuclear_bam.sh

# I indexed the sorted bam files again.
# That way I will get only reads corresponding to nuclear sequences with suffix _sortednuc.bam

./samtools_index_only_nuc.sh


# At some point became uncomfortable to work with bam files named with diffrent suffix.
# I shouldnt have let that happen in the first place, but when I have them already like that
# I will rename them. I will just change the suffinx _nucsorted to _msnc using file rename_in_interval.sh
