#!/bin/bash

VERIFIED_EMAIL=(
"gmail.com"
"yahoo.com"
"outlook.com"
"icloud.com"
"aol.com"
"qq.com"
)

mainmenu() {
	echo "Pick configuration to use:"
	echo "  [1] Send Email"
	echo "  [2] Spamming"
	echo "  [3] Read Email"
	echo -n "Enter selection and press [ENTER]: "
	read mainmenuinput

	if [ "$mainmenuinput" = "1" ]; then
		sendmail
		echo "Email sent!"
		exit
		elif [ "$mainmenuinput" = "2" ]; then
			spammail
			echo "Attack completed!"
			exit
	    elif [ "$mainmenuinput" = "3" ]; then
			echo "Not yet available!"
			exit
		else
			echo "Please enter a valid number between 1 and 3"
			abortinput
	fi
}

sendmail() {
	echo -n "To: "
	read recepientEmail
	isValid=$(validatemail $recepientEmail)

	if [ "$isValid" = "1" ]; then
		mailcreate $recepientEmail
	else
		echo "Err: \"$recepientEmail\" is an invalid email."
		exit
	fi

}
spammail() {
	echo -n "To: "
	read recepientEmail
	isValid=$(validatemail $recepientEmail)

	if [ "$isValid" = "1" ]; then
		echo -n "How many email do you want to spam this person: "
		read spamnum
		if [ $spamnum -eq $spamnum 2>/dev/null ]; then
     		if [ "$spamnum" -lt "100" ]; then
				mailcreate $recepientEmail $spamnum
			else
				echo "Hey that's too much spamming! Be nice to people."
				exit
			fi
		else
    		echo "Err: \"$spamnum\" is not an integer."
			exit
		fi
	else
		echo "Err: \"$recepientEmail\" is an invalid email."
		exit
	fi
}
validatemail() {
	if [ "$1" = "" ]; then
		echo "Empty email address. Program terminated."
		exit
	fi

	tailValid=0
	validTail=$(echo $1 | cut -d'@' -f 2)
	# check length and the validation of the tailing
	if [ "$(echo -n $validTail | wc -m)" != "$(echo -n $1 | wc -m)" ]; then
		# echo "$validTail"
		COUNT=0
        while [  $COUNT -lt 5 ]; do
            if [ "$validTail" = "${VERIFIED_EMAIL[$COUNT]}" ]; then
				let tailValid=1
				break
			fi
            let COUNT=COUNT+1
        done
	fi
	echo "$tailValid"
}
mailcreate() {
	bodyBuffer=""
	echo -n "Subject: "
	read subject
	if ! command_loc="$(type -p "mvim")" || [[ -z $command_loc ]];
	then
		vim -v emailBody.txt
	else
		mvim -v emailBody.txt
	fi
	if [ -f ./emailBody.txt ]; then
		file="./emailBody.txt"
		while IFS= read line
		do
			bodyBuffer="$bodyBuffer"$'\n'"$line"
		done <"$file"
		rm emailBody.txt
	fi
	
	if [ "$2" = "" ]; then
		echo "$bodyBuffer" | mail -s "$subject" "$1"
	else
		echo -n "Aww why so much hate. Are you sure to spam this person? [y/n]: "
		read answer
		if [ "$answer" = "y" ]; then
			COUNT=0
			while [ "$COUNT" -lt $2 ]; do
				echo "$bodyBuffer" | mail -s "$subject" "$1"
				let COUNT=COUNT+1
			done
		elif [ "$answer" = "n" ]; then
			echo "Thanks for being a nice person!"
			exit
		else
			echo "Err: \"$answer\" is not a valid input."
			exit
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
