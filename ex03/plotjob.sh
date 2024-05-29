#!/usr/bin/gnuplot

set terminal png
set output "stride_performance.png"
set title "loop performance in MFlops/sec v/s stride"

set grid
set logscale x
set xlabel "stride"
set ylabel "Mflops/sec"

plot 'stride2pow-dat' title "2^n Stride" with linespoints, \
    'stride8_1_2pow-dat' title "8*1.2^n stride" with linespoints

