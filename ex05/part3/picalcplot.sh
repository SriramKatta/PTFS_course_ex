#!/usr/bin/gnuplot

set terminal png
set output "pispeedup.png"
set title "speedup vs numthreads"
set key left top

set grid
set xlabel "Number of threads"
set ylabel "speedup"

set xtics rotate by 90 right


plot './simdata/simfix-dat' title "fixed freq" with linespoints, \
    './simdata/simturbo-dat' title "turbo" with linespoints, \
