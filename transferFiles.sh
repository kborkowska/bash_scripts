#!/bin/bash

if [ $# -lt 1 ]; then
	echo "you'ne not specified joints"
fi

frec=0.002

cd 

f="none"
modTime=0

for file in ~/IRPOS_results/trapezoid_generator_results/*
do
	newModTime=`stat -c %Y "$file"`
	if [ $newModTime -gt $modTime ]
	then
		f=$file
		modTime=$newModTime
	fi
done
echo "Found latest file"
#cd $f

for i in $@; do
	setups=$(awk -v s="" 'NR==1 {if($1 == duration)
										{s="D"}
								 else
								 		{s="V"}}
						  $1~/^[0-9]/ {s = s ":"$1}
						  END {print s}' $f/user_setup.txt)
	toSavePath="~/Dokumenty/inż/trap_gen_raport/raport_graphs/${setups}"
	cd ~/Dokumenty/inż/trap_gen_raport/raport_graphs/
	mkdir -p ${setups}
	cd
	awk -v t=0.000 '$1~/^[0-9]/ {t+='$frec'
		printf("%.3f %f\n", t, $'$i')}' $f/results.txt > joint-$i-result.txt
	mv joint-$i-result.txt ~/Dokumenty/inż/trap_gen_raport/raport_graphs/${setups}
	awk -v t=0.000 '$1~/^[0-9]/ {t+='$frec'
		printf("%.3f %f\n", t, $'$i')}' $f/setpoints.txt > joint-$i-setpoint.txt
	mv joint-$i-setpoint.txt ~/Dokumenty/inż/trap_gen_raport/raport_graphs/${setups}
	echo "Created file for joint $i"
	echo "--saved in ${toSavePath}--"
done