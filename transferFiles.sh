#!/bin/bash

srcDirectory=~/IRPOS_results/trapezoid_generator_results/
destDirectory=~/Dokumenty/inż/trap_gen_raport/raport_graphs/
matSrcDirectory=~/matlab_skrypty/trajectory_gen_symulators/Results/

frec=0.002

m=0
if [ $# -gt 0 ] && [ $1 == "-m" ]; then
	echo "[OPT] Transfering matlab files as well"
	m=1
	shift
fi

if [ $# -lt 1 ]; then
	echo "[ERR] You've not specified joints"
	exit
fi

cd 

f=`glf $srcDirectory`

for i in $@; do
	setups=`more $f/function_signature.txt`

	setups=${setups}`awk -v s="" '$1~/^[0-9\-]/ {s = s ":"$1}
						 END {print s}' $f/user_setup.txt`
	#echo $setups

	cd ${destDirectory}SymulationResults/
	mkdir -p ${setups}
	cd

	awk -v t=-0.002 '$1~/^[0-9\-]/ {t+='$frec'
		printf("%.3f %f\n", t, $'$i')}' $f/results.txt > joint-$i-result.txt
	mv joint-$i-result.txt ${destDirectory}SymulationResults/${setups}

	awk -v t=-0.002 '$1~/^[0-9\-]/ {t+='$frec'
		printf("%.3f %f\n", t, $'$i')}' $f/setpoints.txt > joint-$i-setpoint.txt
	mv joint-$i-setpoint.txt ${destDirectory}SymulationResults/${setups}

	echo "Created file for joint $i"
	echo "--saved in ${destDirectory}SymulationResults/${setups}--"

done

if [ $m -gt 0 ]
then
	f=`glf $matSrcDirecotry`
	echo $matSrcDirectory
	cp $f ${destDirectory}MatlabResults
fi