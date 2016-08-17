#SAMtools view - converting SAM to BAM
#!/bin/bash

DATADIR=~/hedgehog/results/2016-08-15

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
     samtools view -b -S -o ${SAMPLE[$i]}.bam ${SAMPLE[$i]}.sam
done
