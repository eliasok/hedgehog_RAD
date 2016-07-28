#!/bin/bash
#
#2016-11-07
#
#Demultiplexing raw reads using Sabre (https://github.com/najoshi/sabre)
#
#Files representing raw paired-end reads: runII.1.fasta.gz(forward), runII.2.fasta.gz(reverse)
#present in the directory together with .txt file barcode

sabre pe -m 1 -c -f runII.1.fasta.gz -r runII.2.fasta.gz -b barcode.txt -u unknown_barcode1.fasta -w unknown_barcode2.fasta

#Options:
#sabre (pe) pair-end reads,
#(-m 1) allows for one mismatch in the barcode sequence,
#(-c) remove barcodes from both files,
#(-f) specifying forward input file,
#(-r) specifying reverse input file, (-b) barcode file,
#(-u) output file contains unknown forward sequences,
#(-w) output file contains unknown reverse sequences.
#
#One allowed mismatch in the barcode sequences derived
#from python script hamm.py assessing minimum distance
#between words(five letters barcodes).
#Script finished run with minimum distance between words = 3.
#
#Checking quality of reads and detection of overrepresent sequences using FastQC

if [ ! -d fastqc ]; then    mkdir fastqc;    fastqc -o fastqc -f fastq Er*_*.fastq.gz ; fi
