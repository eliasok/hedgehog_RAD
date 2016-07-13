#!/usr/bin/python
from Bio import SeqIO
from Bio.Seq import Seq
import argparse
import sys

parser = argparse.ArgumentParser(description='''Reads a list of words from a file and
                                                reports a matrix of Hamming distances
                                                among them. Input file should have only
                                                one word per line''')
parser.add_argument('infile', help='Input file.')
parser.add_argument('-o', '--outfile', help='Output file. Default z1', default = 'z1')
parser.add_argument('-r', '--reverse', help='Compare the reverse complementary, and report the shortest distance. Default False.', action='store_true')
#parser.add_argument('-q', '--param2', help='Parameter 2')
#parser.add_argument('-r', '--param3', help='Parameter 3')
args = parser.parse_args()

def Hamm(seq1, seq2, reverse=False):
   DirectDist = 0
   ReverseDist = 0
   # This can only compare already aligned sequences of the same length,
   # with the option of checking if a reverse complementary
   assert len(seq1) == len(seq2)
   if reverse:
      seq3 = str(Seq(seq2).reverse_complement())
   for i in range(len(seq1)):
      if seq1[i] != seq2[i]:
         DirectDist += 1
      if reverse:
         if seq1[i] != seq3[i]:
            ReverseDist += 1
   if reverse:
      return sorted([DirectDist, ReverseDist])[0]
   else:
      return DirectDist

with open(args.infile, 'r') as f:
   code = f.read().splitlines()

with open(args.outfile, 'w') as f:
   f.write('     \t'+'\t'.join(code)+'\n')
   for j in range(len(code)):
      row = code[j]
      for i in range(j):
         row = row + '\t' + str(Hamm(code[j], code[i], reverse=args.reverse))
      f.write(row+'\n')
