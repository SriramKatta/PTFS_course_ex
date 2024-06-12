#!/usr/bin/gnuplot

set terminal png
set output "perf.png"
set title "performance"
set key left top
set yrange [0:65]

set grid
set logscale x
set xlabel "N"
set ylabel "GFlops/s"

set xtics rotate by 90 right

set arrow from 5000, graph 0 to 5000, graph 1 nohead

plot 'sim1-dat' title "1 thread" with linespoints, \
    'sim2-dat' title "2 thread" with linespoints, \
    'sim4-dat' title "4 thread" with linespoints, \
    'sim8-dat' title "8 thread" with linespoints, \
    'sim12-dat' title "12 thread" with linespoints, \
    'sim16-dat' title "16 thread" with linespoints, \
    'sim18-dat' title "18 thread" with linespoints, \
    'simseq-dat' title "no OMP code" with linespoints, \






