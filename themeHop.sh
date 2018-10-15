#!/bin/bash

mainmenu() {
	echo -n "Pick configuration to use:"
	echo ""
	echo "  [1] Dark"
	echo "  [2] Light"
	echo "  [3] All Dark"
	echo "  [4] All Light"
	echo -n "Enter selection and press [ENTER]: "
	read theme

	if [ "$theme" = "1" ]; then
		writeSpecifcFile $theme
		echo "File successfully written!"
		elif [ "$theme" = "2" ]; then
			writeSpecifcFile $theme
			echo "File successfully written!"
		elif [ "$theme" = "3" ]; then
			echo "Default theme: dark"
			defaults write -g NSRequiresAquaSystemAppearance -bool NO
			echo "File successfully written!"
		elif [ "$theme" = "4" ]; then
			echo "Default theme: light"
			defaults write -g NSRequiresAquaSystemAppearance -bool YES
			echo "File successfully written!"
		else
			echo "Please enter a valid number between 1 and 4"
			abortinput
	fi

}
writeSpecifcFile() {
	echo "Tips: locate your application in ~/Library/Preferences"
	echo -n "Which plist do you want to write? "
	read input
	# when input is empty
	if [ "$input" = "" ]; then
		abortinput
	fi
	if [ ! -e ~/Library/Preferences/"$input" ]; then
    	echo "File not found! Program terminated."
		exit
	else
		cutindex=$(echo -n $input | wc -m)-6
		file=${input:0:$cutindex}
		if [ "$1" = "1" ]; then
			echo "File written: $file"
			echo "Theme: dark"
			defaults write $file NSRequiresAquaSystemAppearance -bool NO
		elif [ "$1" = "2" ]; then
			echo "File written: $file"
			echo "Theme: light"
			defaults write $file NSRequiresAquaSystemAppearance -bool YES
		fi
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
