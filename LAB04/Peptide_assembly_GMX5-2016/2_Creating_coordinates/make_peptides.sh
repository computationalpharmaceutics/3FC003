#!/bin/bash

vmd='/content/vmd/bin/vmd'

declare -a aminoacid1=("TYR")
declare -a aminoacid2=("ALA" "CYS" "ASP" "GLU" "PHE" "GLY" "HIS" "ILE" "LYS" "LEU" "MET" "ASN" "PRO" "GLN" "ARG" "SER" "THR" "VAL" "TRP" "TYR")
declare -a aminoacid3=("TYR")
#declare -a oneletters=("A" "C" "D" "E" "F" "G" "H" "I" "K" "L" "M" "N" "P" "Q" "R" "S" "T" "V" "W" "Y")

for i in "${aminoacid1[@]}"
do
   for j in "${aminoacid2[@]}"
   do
      for k in "${aminoacid3[@]}"
      do
         echo "$i"
         sed -e "s/XXX/"$i"/g" XYZ.pdb > tmp1
         sed -e "s/YYY/"$j"/g" tmp1 > tmp2
         sed -e "s/ZZZ/"$k"/g" tmp2 > $i"-"$j"-"$k"_aa.pdb"
         sed -e "s/XXX/"$i"/g" create_tripeptides.tcl > tmp3
         sed -e "s/YYY/"$j"/g" tmp3 > tmp4 
         sed -e "s/ZZZ/"$k"/g" tmp4 > tmp5 
         $vmd -dispdev text -e tmp5
         sed -i "s/HSD/HIS/g" $i"-"$j"-"$k"_aa.pdb"
      done
   done
done
rm tmp1 tmp2 tmp3 tmp4 tmp5

