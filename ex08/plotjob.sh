#!/usr/bin/gnuplot

set terminal png
set output "zplot_D.png"
set title "performance vs power[w]"
set key top right

set grid
set logscale x
set xlabel "performance [Gflops/s]"
set ylabel "Energy [J]"

set xtics rotate by 90 right


plot './simdata/tesfile_1600000' title "1.6 GHz" with linespoints, \
      './simdata/tesfile_2400000' title "2.4 GHz" with linespoints\