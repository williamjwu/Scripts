#!/bin/bash

VERIFIED_EMAIL=(
"gmail.com"
"yahoo.com"
"outlook.com"
"icloud.com"
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

	# quit when recpepient email is empty
	if [ "$recepientEmail" = "" ]; then
		echo "Empty email address. Program terminated."
		exit
	fi

	tailValid=0
	validTail=$(echo $recepientEmail | cut -d'@' -f 2)
	# check length and the validation of the tailing
	if [ "$(echo -n $validTail | wc -m)" != "$(echo -n $recepientEmail | wc -m)" ]; then
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

	if [ "$tailValid" = "1" ]; then
		echo -n "Subject: "
		read subject
		if ! command_loc="$(type -p "mvim")" || [[ -z $command_loc ]];
		then
			vim -v emailBody.txt
		else
			mvim -v emailBody.txt
		fi
		file="./emailBody.txt"
		while IFS= read line
		do
			bodyBuffer="$bodyBuffer"$'\n'"$line"
		done <"$file"
		echo "$bodyBuffer" | mail -s "$subject" "$recepientEmail"
		rm emailBody.txt
	else
		echo "Err: Invalid email."
		exit
	fi

}
spammail() {
	echo -n "To: "
	read recepientEmail
	if [ "$recepientEmail" = "" ]; then
		echo "Empty email address. Program terminated."
		exit
	fi

	tailValid=0
	validTail=$(echo $recepientEmail | cut -d'@' -f 2)
	# check length and the validation of the tailing
	if [ "$(echo -n $validTail | wc -m)" != "$(echo -n $recepientEmail | wc -m)" ]; then
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

	if [ "$tailValid" = "1" ]; then
		echo -n "Subject: "
		read subject
		if ! command_loc="$(type -p "mvim")" || [[ -z $command_loc ]];
		then
			vim -v emailBody.txt
		else
			mvim -v emailBody.txt
		fi
		file="./emailBody.txt"
		while IFS= read line
		do
			bodyBuffer="$bodyBuffer"$'\n'"$line"
		done <"$file"
		rm emailBody.txt
		echo -n "How many email do you want to spam this person: "
		read spamnum
		if [ "$spamnum" -lt "100" ]; then
			echo -n "Aww why so much hate. Are you sure to spam this person? [y/n]: "
			read answer
			if [ "$answer" = "y" ]; then
				COUNT=0
				while [ "$COUNT" -lt $spamnum ]; do
					echo "$bodyBuffer" | mail -s "$subject" "$recepientEmail"
					let COUNT=COUNT+1
				done
			else
				echo "Thanks for being a nice person!"
				exit
			fi
		elif [ "$spamnum" -ge "100" ]; then
			echo "Hey that's too much spamming! Be nice to people."
			exit
		else
			echo "Invalid input. Program terminated."
			exit
		fi
	else
		echo "Err: Invalid email."
		exit
	fi
}
subjectCreate() {
	echo "place holder"

}
bodyCreate() {
	echo "another one"
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
