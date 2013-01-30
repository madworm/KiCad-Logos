#!/bin/bash

for file in `ls *.emp`; do perl -pi -e "s/LOGO/${file/%.emp/}/;" $file; done
for file in `ls *.emp`; do cat $file >>./OSHW-logo.mod; done
