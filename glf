#!/bin/bash

# glf - get latest file

f="none"
modTime=0
s=0

if [ $# -gt 1 ]; then
	if [ $1 == "-s" ]; then
		s=1
		shift
	fi
fi

echo $1

if [ $# -eq 1 ]; then
	directory=$1
	if [[ $1 =~ [^/]$ ]]; then
		directory=${directory}"/"
	fi
else
	directory=`pwd`"/"
fi

for file in ${directory}*
do
	newModTime=`stat -c %Y "$file"`
	if [ $newModTime -gt $modTime ]
	then
		f=$file
		modTime=$newModTime
	fi
done

if [ $s -eq 1 ]; then
	f=(${f//${directory}/})
fi

echo $f