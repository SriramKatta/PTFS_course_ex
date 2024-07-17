#!/usr/bin/gnuplot

set terminal png
set output "perf_tasking.png"
set title "Mpx/s vs tilesize"
set key top left


set grid
set xlabel "tilesize"
set ylabel "Mpx/s"
set logscale x

plot './simdata/ompparallel' title "omp for with collapse version" with linespoints, \
      './simdata/ompparallel_task' title "omp tasks version" with linespoints