#!/bin/bash

# if $1 exist and it is true start the program
# if not then echo out the illegal arguments

if [ -f ./$1 ]; then
	pdftotext $1
	filename=$(echo $1 | cut -d'.' -f 1)
	vi $filename.txt
	rm $filename.txt
else
	echo "Illegal argument: use flag \"--help\" to look for instructions"
fi
