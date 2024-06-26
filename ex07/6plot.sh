#!/usr/bin/gnuplot

set terminal png
set output "perf6b.png"
set title "MPX/s vs numthreads"
set key bottom right

set grid
set xlabel "Num Threads"
set ylabel "Bandwidth (MPX/s)"

set xtics rotate by 90 right


plot './simdata/raytra_static' title "OMP schedule static" with linespoints, \
      './simdata/raytra_dynamic' title "OMP schedule dynamic" with linespoints