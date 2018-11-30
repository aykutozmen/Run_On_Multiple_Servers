#!/bin/bash

echo > ${PWD}/Run_For_Me.log
Command_File=${PWD}"/Run_For_Me.command"

function Give_Break {
echo
echo "------------------------------------------"
}

if [ -f $Command_File ]
then
	CommandLineCount=`cat ${Command_File} | wc -l`
	if [ "$CommandLineCount" -eq 1 ]
	then
		echo "A command line found in file: "${Command_File}
		echo "The command will be run on servers..."
	else
		echo "There must be only one line containing a command to be run in file "${Command_File}
		exit 1
	fi
else
	echo "File "$Command_File" missing... You need to input a command line to this file..."
	exit 1
fi

Server_List=( admin1 admin2 db1 db2 fc1 fc2 mail1 mail2 web1 web2 sip1 sip2 tele1 tele2 )

while true
do
read -p "Do you want to send the result to a log file? [y/n]" Answer
case $Answer in
[yY]*)	exec >> ${PWD}/Run_For_Me.log 2>/dev/null
	Flag=1
	break
	;;
[nN]*)  exec 2> /dev/null
	Flag=0
	break
	;;
*)      echo "Please type y[es] or n[o]..."
	;;
esac
done

for Server in "${Server_List[@]}"
do
echo "Running '"`cat $Command_File`"' on "${Server}"..."
ssh ${Server} "`cat ${Command_File}`"
Give_Break
done

if [ "$Flag" -eq 1 ]
then
	echo "Log File: "${PWD}"/Run_For_Me.log"
fi

exit 0

