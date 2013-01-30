#!/bin/bash

if [[ $# -ne 2 ]]
then
	echo -e "\nusage: $0 <start> <end>. 'start' and 'end' are integer (1,2,3...) sizes in mm (metric)\n"
fi

RANGE_START=${1:-1}
RANGE_END=${2:-10}
LIBRARY_NAME="KiCad-icon.mod"

for number in `seq $RANGE_START $RANGE_END`
do
	TMP_FILE=`mktemp`
        ./scale.pl KiCad.emp $TMP_FILE 21 ${number}.0mm
	perl -pi -e "s/LOGO/${LIBRARY_NAME/%.mod/}_silkscreen-front_${number}mm/" $TMP_FILE
	cat $TMP_FILE >> ./$LIBRARY_NAME
	rm $TMP_FILE

        ./scale.pl KiCad.emp $TMP_FILE 20 ${number}.0mm
	perl -pi -e "s/LOGO/${LIBRARY_NAME/%.mod/}_silkscreen-back_${number}mm/" $TMP_FILE
	cat $TMP_FILE >> ./$LIBRARY_NAME
	rm $TMP_FILE
done

for number in `seq $RANGE_START $RANGE_END`
do
	TMP_FILE=`mktemp`
       	./scale.pl KiCad.emp $TMP_FILE 15 ${number}.0mm
	perl -pi -e "s/LOGO/${LIBRARY_NAME/%.mod/}_copper-front_${number}mm/" $TMP_FILE
	cat $TMP_FILE >> ./$LIBRARY_NAME

	./scale.pl KiCad.emp $TMP_FILE 0 ${number}.0mm
	perl -pi -e "s/LOGO/${LIBRARY_NAME/%.mod/}_copper-back_${number}mm/" $TMP_FILE
	cat $TMP_FILE >> ./$LIBRARY_NAME
done

mv $LIBRARY_NAME ./lib

