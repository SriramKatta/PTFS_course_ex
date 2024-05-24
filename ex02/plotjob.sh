#!/usr/bin/gnuplot

set terminal png
set output opfname
set title title_str

set grid
set logscale x
set xlabel "N"
set ylabel "MFlops/s"

plot 'stream-dat' title "stream Kernel" with linespoints, \
    'daxpy-dat' title "DAXPY kernel" with linespoints

