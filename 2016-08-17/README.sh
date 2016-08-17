#!/bin/bash
#
#2016-08-17
#
#Using SAMtools to view (converting SAM to BAM), sort (sorting reads by their location in genome) 
#and index (indexing a previously sorted bam file) mapped reads (see shell scripts) to prepare 
#them for variant calling process. 
#A necessary step at this point is filtering out mitochondrial sequences using SAMtools view 
#once more. When NC_002080.2 is a name of cytochrome sequence I will concatenate all headers @SQ 
#with defined C(name)and L(lenght) and paste them to z1 file. Then I will remove NC_002080.2
#name out of list and use z1 file to select all apart from mitochondrial sequences.
#I will index output sequences again.

samtools view -H Er51_436_sorted.bam | grep "@SQ" | gawk '{C=substr($2,4); L=substr($3,4); print C "\t" 1 "\t" L}' > z1

#then to obtain only nuclear sequences:

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
        samtools view -b -h -L z1 ${SAMPLE[$i]}_sorted.bam  > ${SAMPLE[$i]}_sortednuc.bam
done


