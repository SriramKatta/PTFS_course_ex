#!/usr/bin/gnuplot

set terminal png
set output opfname
set title title_str

set grid
set logscale x
set xlabel "stride"
set ylabel "array updates per second"

plot 'stride-dat' title "stride access" with linespoints,

