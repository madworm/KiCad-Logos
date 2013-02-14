#!/bin/bash

if [[ $# -ne 6 ]]
then
	echo -e "\n  usage: $0 input-file.emp library-name.mod <start> <increment> <end> <h-sym: y/n>."
	echo -e "\n         <start>, <increment> and <end> are integer (1,2,3...) sizes in mm (metric)."
	echo -e "\n         Images with horizontal symmetry don't need to be mirrored for back-layers. Answer with 'y' or 'n'."
	echo -e "\n\n  Example 1: create a library with sizes of 5, 10, 15 and 20mm for a h-symmetric logo."
	echo -e "\n             $0 my-logo.emp my-logo.mod 5 5 20 y\n"
	echo -e "\n  Example 2: create a library with sizes of 10, 20, and 30mm for a non-h-symmetric logo."
	echo -e "\n             $0 my-logo.emp my-logo.mod 10 10 30 n\n"
	exit
fi

INPUT_FILE=$1
LIB_NAME=$2
RANGE_START=$3
RANGE_INCREMENT=$4
RANGE_END=$5
LIB_FOLDER="./lib"
IMAGE_IS_H_SYMMETRIC=$6

if [[ ! -d $LIB_FOLDER ]]
then
	echo -e "\n Hey, the library folder is missing... creating '$LIB_FOLDER' folder\n"
	mkdir $LIB_FOLDER
fi

echo -e "\n working...\n"

TMP_FILE=`mktemp`

if [[ $IMAGE_IS_H_SYMMETRIC = "y" ]]
then
	for number in `seq $RANGE_START $RANGE_INCREMENT $RANGE_END`
	do
	        ./scale.pl $INPUT_FILE $TMP_FILE 21 ${number}.0mm
		perl -pi -e "s/LOGO/${LIB_NAME/%.mod/}_silkscreen_${number}mm/" $TMP_FILE
		cat $TMP_FILE >> ./$LIB_NAME
	done

	for number in `seq $RANGE_START $RANGE_INCREMENT $RANGE_END`
	do
	       	./scale.pl $INPUT_FILE $TMP_FILE 15 ${number}.0mm
		perl -pi -e "s/LOGO/${LIB_NAME/%.mod/}_copper_${number}mm/" $TMP_FILE
		cat $TMP_FILE >> ./$LIB_NAME
	done

else
	for number in `seq $RANGE_START $RANGE_INCREMENT $RANGE_END`
	do
	        ./scale.pl $INPUT_FILE $TMP_FILE 21 ${number}.0mm
		perl -pi -e "s/LOGO/${LIB_NAME/%.mod/}_silkscreen-front_${number}mm/" $TMP_FILE
		cat $TMP_FILE >> ./$LIB_NAME

	        ./scale.pl $INPUT_FILE $TMP_FILE 20 ${number}.0mm
		perl -pi -e "s/LOGO/${LIB_NAME/%.mod/}_silkscreen-back_${number}mm/" $TMP_FILE
		cat $TMP_FILE >> ./$LIB_NAME
	done

	for number in `seq $RANGE_START $RANGE_INCREMENT $RANGE_END`
	do
	       	./scale.pl $INPUT_FILE $TMP_FILE 15 ${number}.0mm
		perl -pi -e "s/LOGO/${LIB_NAME/%.mod/}_copper-front_${number}mm/" $TMP_FILE
		cat $TMP_FILE >> ./$LIB_NAME

		./scale.pl $INPUT_FILE $TMP_FILE 0 ${number}.0mm
		perl -pi -e "s/LOGO/${LIB_NAME/%.mod/}_copper-back_${number}mm/" $TMP_FILE
		cat $TMP_FILE >> ./$LIB_NAME
	done
fi




echo -e "\n cleaning up... removed $TMP_FILE\n"
rm $TMP_FILE

mv $LIB_NAME $LIB_FOLDER

echo -e "\n done.\n"
