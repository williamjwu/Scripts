#!/bin/sh

main() {
	if [ -f ./$1 ]; then
		checkpglimit $1
		pdftotext $1
		filename=$(echo $1 | cut -d'.' -f 1)
		vi $filename.txt
		rm $filename.txt
	elif [ "$1" = "--help" ]; then
		helppg
	else
		echo "Illegal argument: use flag \"--help\" to look for instructions"
	fi
}

checkpglimit() {
	pg=$(pdfinfo $1 | grep Pages | awk '{print $2}')
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

helppg() {
	echo "Help page not available at this moment!"
	exit
}

main $1
