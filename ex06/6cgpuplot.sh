#!/usr/bin/gnuplot

set terminal png
set output "perf6c1.png"
set title "Bandwidth vs N(elements in array)"
set key left top

set grid
set logscale x
set xlabel "N(elements in array)"
set ylabel "Bandwidth (GB/s)"

set xtics rotate by 90 right


plot './simdata/kernelBW_sizevar-dat' title "kernel bandwidth" with linespoints


reset 

set terminal png
set output "perf6c2.png"
set title "Bandwidth vs N(elements in array)"
set key left top

set grid
set logscale x
set xlabel "N(elements in array)"
set ylabel "Bandwidth (GB/s)"

set xtics rotate by 90 right

plot './simdata/htodBW_sizevar-dat' title "htod bandwidth" with linespoints

unset output
