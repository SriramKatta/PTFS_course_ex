#!/usr/bin/gnuplot

set terminal png
set output "perf6b_tilesizevar.png"
set title "MPX/s vs numthreads"
set key bottom right

set grid
set logscale x
set xlabel "tilesize"
set ylabel "Bandwidth (MPX/s)"

set xtics rotate by 90 right


plot './simdata/raytra_tilesizevar_static' title "OMP schedule static" with linespoints, \
      './simdata/raytra_tilesizevar_dynamic' title "OMP schedule dynamic" with linespoints, \
      './simdata/raytra_tilesizevar_auto' title "OMP schedule auto" with linespoints, \