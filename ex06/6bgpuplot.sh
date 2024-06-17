#!/usr/bin/gnuplot

set terminal png
set output "perf6b.png"
set title "times vs numthreads"
set key left top

set grid
set xlabel "Number of threads"
set ylabel "time"

set xtics rotate by 90 right


plot './simdata/kernalBW_threadvar-dat' title "kernel bandwidth" with linespoints