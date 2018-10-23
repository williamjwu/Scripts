#!/bin/bash
VERIFIED_EMAIL=(
"gmail.com"
"yahoo.com"
"outlook.com"
"icloud.com"
"aol.com"
"qq.com"
)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
mainmenu() {
	echo "Pick configuration to use:"
	echo "  [1] Send Email"
	echo "  [2] Spamming"
	echo "  [3] Read Email"
	echo -n "Enter selection and press [ENTER]: "
	read mainmenuinput

	if [ "$mainmenuinput" = "1" ]; then
		sendmail
		printf "${GREEN}Email sent!${NC}"
		exit
		elif [ "$mainmenuinput" = "2" ]; then
			spammail
			echo -e "${GREEN}Attack completed!${NC}"
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
		printf "${RED}Err: \"$recepientEmail\" is an invalid email.${NC}"
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
    		printf "${RED}Err: \"$spamnum\" is not an integer.${NC}"
			exit
		fi
	else
		printf "${RED}Err: \"$recepientEmail\" is an invalid email.${NC}"
		exit
	fi
}
validatemail() {
	if [ "$1" = "" ]; then
		echo "${RED}Err: empty email address.${NC}"
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
			printf "${RED}Err: \"$answer\" is not a valid input.${NC}"
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