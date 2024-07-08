#!/usr/bin/gnuplot

set terminal png
set output "perf3b.png"
set title "it/s vs numcores"
set key bottom right


set grid
set xlabel "Num Cores"
set ylabel "Bandwidth (it/s)"

plot './simdata/sim_atomic' title "atomic version" with linespoints, \
      './simdata/sim_red' title "reduction version" with linespoints