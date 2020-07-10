#!/bin/bash
# indexing reads corresponding to all mitochondrial and nuclear sequences

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
 if [ ! -e Er76_Ch8f_sorted.bam.bai ]; then
     samtools index ${SAMPLE[$i]}_sorted.bam &
 fi
done
wait
