#!/usr/bin/gnuplot

set terminal png
set output "perf6c.png"
set title "times vs N(elements in array)"
set key left top

set grid
set logscale x
set xlabel "N(elements in array)"
set ylabel "time"

set xtics rotate by 90 right


plot './simdata/kernalBW_sizevar-dat' title "kernel bandwidth" with linespoints, \
    './simdata/htodBW_sizevar-dat' title "htod bandwidth" with linespoints