#!/usr/bin/gnuplot

set terminal png
set output opfname
set title title_str

set grid
#set logscale x
set xlabel "N"
set ylabel "s"

plot 'stride-dat' title "stride access" with linespoints,

