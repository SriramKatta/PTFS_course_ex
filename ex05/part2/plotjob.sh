#!/usr/bin/gnuplot

set terminal png
set output "parastreamompbenchmark.png"
set title "Gflops vs loop length"
set key left top
set yrange [0:65]

set grid
set logscale x
set xlabel "N"
set ylabel "GFlops/s"
set key font ",8"

set xtics rotate by 90 right

set arrow from 2000, graph 0 to 2000, graph 1 nohead
set arrow from 52083, graph 0 to 52083, graph 1 nohead
set arrow from 2250000, graph 0 to 2250000, graph 1 nohead

plot './simdata/sim1-dat' title "1 threads" with linespoints, \
        './simdata/sim2-dat' title "2 threads" with linespoints, \
        './simdata/sim4-dat' title "4 threads" with linespoints, \
        './simdata/sim8-dat' title "8 threads" with linespoints, \
        './simdata/sim12-dat' title "12 threads" with linespoints, \
        './simdata/sim16-dat' title "16 threads" with linespoints, \
        './simdata/sim18-dat' title "18 threads" with linespoints, \
        './simdata/simseq-dat' title "no OMP code" with linespoints


