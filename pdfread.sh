#!/bin/bash

# if $1 exist and it is true start the program
# if not then echo out the illegal arguments
main() {
	if [ -f ./$1 ]; then
		echo "before func"
		checkpglimit $1
		echo "after func"
		pdftotext $1
		filename=$(echo $1 | cut -d'.' -f 1)
		vi $filename.txt
		rm $filename.txt
	elif [ "$1" = "--help" ]; then
		echo "help page not available"
	else
		echo "Illegal argument: use flag \"--help\" to look for instructions"
	fi
}
checkpglimit() {
	pg=$(pdfinfo $1 | grep Pages | awk '{print $2}')
	echo "$pg"
	if [ "$pg" -gt "20" ]; then
		echo "Warning: This document is more than 20 pages"
		echo -n "Do you want to open the pdf itself instead of viewing it in Terminal? [y/n]: "
		read answer
		if [ "$answer" = "y" ]; then
			open $1
		fi
		exit
	fi
}

main $1
