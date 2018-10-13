#!/bin/bash

mainmenu() {
	echo "Tips: locate your application in ~/Library/Preferences"
	echo -n "Which plist do you want to write? "
	read input
	# when input is empty
	if [ "$input" = "" ]; then
		abortinput
	fi
	if [ ! -e ~/Library/Preferences/"$input" ]; then
    	echo "File not found! Program terminated."
	else
		cutindex=$(echo -n $input | wc -m)-6
		file=${input:0:$cutindex}
		echo -n "Pick configuration to use:"
		echo ""
		echo "  [1] Dark"
		echo "  [2] Light"
		echo -n "Enter selection and press [ENTER]: "
		read theme

		if [ "$theme" = "1" ]; then
			echo "File written: $file"
			echo "Theme: dark"
			defaults write $file NSRequiresAquaSystemAppearance -bool NO
			elif [ "$theme" = "2" ]; then
				echo "File written: $file"
				echo "Theme: light"
				defaults write $file NSRequiresAquaSystemAppearance -bool YES
			else
				echo "Please enter a valid number between 1 and 2"
				abortinput
		fi
		echo "File written successfully!"
	fi
}
abortinput() {
	echo -n "Do you want to continue? [y/n]: "
	read abortinput
	if [ "$abortinput" = "y" ]; then
		echo ""
		mainmenu
	else
		echo "Program terminated."
		exit
	fi
}

mainmenu
