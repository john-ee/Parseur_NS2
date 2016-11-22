#!/bin/bash

# $1 est le fichier de trace
FILENAME=$1
# La file dont vous voulez tracer un graphe sur sa taille
FROM_NODE=$2
TO_NODE=$3

# ! Si le lien ($FROM_NODE,$TO_NODE) n'existe pas, le fichier sera vide

# On verifie si le fichier existe et on le supprime
if [[ -f "time_queue.dat" ]]; then
	rm time_queue.dat
fi

# Le nombre d'elt en file d'attente
queue=0

# On lit une ligne à la fois et on met chauqe elt de la ligne dans une variable
# Exemple de ligne de trace :
# + 0.011 1 0 tcp 40 ------- 0 1.0 5.0 0 0
# Le couple (from_node,to_node) représente une file d'attente pour aller du noeud from_node au noeud to_node
while read event timestamp from_node to_node ptype psize flags flow src dest id
do
# code : + : on rajoute le paquet à la file (from_node,to_node)
#		 - : le paquet sort de la file (from_node,to_node)
#		 d : le paquet est détruit de la file (from_node,to_node)
# On ne traite que les paquets de la file d'attente (FROM_NODE,TO_NODE)
if [ "$from_node" == "$FROM_NODE" ];then
	if [ "$to_node" == "$TO_NODE" ]; then
		# + signfie qu'un paquet arrive quand la file
		if [ $event == "+" ]; then
			let queue++
		fi
		# - signifie qu'un paquet quitte
		if [ $event == "-" ]; then
			let queue--
		fi
		# d signifie que le paquet est détruit
		if [ $event == "d" ]; then
			let queue--
		fi
		# on rajoute une ligne avec le temps t et la valeur de queue
		echo "$timestamp $queue" >> time_queue.dat
	fi
fi
done < $FILENAME

# On utilise le script plot.sh pour tracer la courbe
#./plot.sh time_queue.dat | gnuplot > graph.png

gnuplot <<- EOF
	set xlabel "Temps"
	set ylabel "Taille file d'attente"
	set title "Taille de la file d'attente ($FROM_NODE,$TO_NODE)"
	set terminal png
	set output "graph.png"
	plot "time_queue.dat" using 1:2 with lines
EOF