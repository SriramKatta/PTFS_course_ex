#!/usr/bin/gnuplot

set terminal png
set output "zplot.png"
set title "performance vs power[w]"
set key bottom right

set grid
set logscale x
set xlabel "performance"
set ylabel "Power [w]"

set xtics rotate by 90 right


plot './simdata/tesfile_1600000' title "1.6 GHz" with linespoints, \
      './simdata/tesfile_2400000' title "2.4 GHz" with linespoints\