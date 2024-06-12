#!/usr/bin/gnuplot

set terminal png
set output "perf.png"
set title "performance"

set grid
set xlabel "Number of threads"
set ylabel "speedup"

set xtics rotate by 90 right


plot 'simfix-dat' title "fixed freqiency" with linespoints, \
    'simturbo-dat' title "turbo thread" with linespoints, \
