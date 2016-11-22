#!/bin/bash


#commande qui permet de faire un ficher donnant la taille d'une file d'attente dans chaque noeud de la simulation
for i in $(seq 4)
do
	awk '{if($1=="+"||$4=="$i"){ ++count; print count, $2}; if($1=="-"||$4=="$i"){ --count; print count, $2}}' out.tr > taille_queue_node$i.txt
done

[000 100] [
