#!/bin/bash
#
# Using radpainter, a fineRADstructure component

DATADIR=~/hedgehog/results_2018/17-04-2018

populations -P $DATADIR -M $DATADIR/popmap2 --fstats --radpainter -r 90 --verbose
