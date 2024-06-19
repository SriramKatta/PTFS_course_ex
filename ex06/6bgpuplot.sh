#!/usr/bin/gnuplot

set terminal png
set output "perf6b.png"
set title "Bandwidth vs numthreads"
set key bottom right

set grid
set xlabel "threads per block"
set ylabel "Bandwidth (GB/s)"

set xtics rotate by 90 right


plot './simdata/kernelBW_threadvar32-dat' title "full occupancy bandwidth" with linespoints, \
      './simdata/kernelBW_threadvar16-dat' title "half occupancy bandwidth" with linespoints, \
      './simdata/kernelBW_threadvar24-dat' title "3 quaters occupancy bandwidth" with linespoints, \
      './simdata/kernelBW_threadvar8-dat' title "quater occupancy bandwidth" with linespoints, \
      './simdata/kernelBW_threadvar1-dat' title "min occupancy  bandwidth" with linespoints, \