#!/usr/bin/gnuplot

set terminal png
set output "scaling_graph.png"
set title "Gflops vs Num of Cores"

set grid
set xlabel "Num cores"
set ylabel "Gflops/s"

set xtics rotate by 90 right

plot './simdata/simscaling-dat' with linespoints