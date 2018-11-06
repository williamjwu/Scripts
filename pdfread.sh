#!/bin/bash

# if $1 exist and it is true start the program
# if not then echo out the illegal arguments
if [ "$1" = "" ]; then
	echo "hh"
else
	echo "Illegal argument: use flag \"--help\" to look for instructions"
fi
