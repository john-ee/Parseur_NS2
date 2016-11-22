gnuplot <<- EOF
	set terminal png
	set output "graph.png"
	plot "$1" using 1:2 with lines
EOF