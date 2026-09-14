#!/bin/bash

declare -a aminoacid1=("TYR")
declare -a aminoacid2=("ALA" "CYS" "ASP" "GLU" "PHE" "GLY" "HIS" "ILE" "LYS" "LEU" "MET" "ASN" "PRO" "GLN" "ARG" "SER" "THR" "VAL" "TRP" "TYR")
declare -a aminoacid3=("TYR")
npep=100
box_vector=8

for i in "${aminoacid1[@]}"
do
   for j in "${aminoacid2[@]}"
   do
      for k in "${aminoacid3[@]}"
      do
#create peptide boxes
         pep=$i"-"$j"-"$k
         ./martinize.py -f "../2_Creating_coordinates/"$pep"_aa.pdb" -name $pep -o $pep".top" -x $pep".pdb" -ff martini22 -ss EEE -nt
         gmx insert-molecules -box $box_vector $box_vector $box_vector -nmol $npep -ci $pep".pdb" -radius 0.4 -o $pep"_box.gro"
         gmx solvate -cp $pep"_box.gro" -cs water-80A_eq.gro -radius 0.21 -o $pep"_water.gro"
#correct top file
         sed -i "s/martini/martini_v2.2/" $pep".top"
         sed -i "s/1/"$npep"/g" $pep".top"
#calculate number of waters and add to top file
         tail -n 2 < $pep"_water.gro" | head -n 1 > tmp
         nw=`awk 'BEGIN { FS = "W"} ; {print $1}' < tmp`
         nwat=$(($nw - ( 3 * $npep )))
         rm tmp
         printf "\nW       $nwat" >> $pep".top"
#do minimization and add ions
         gmx grompp -f tripep_water_min.mdp -p $pep -c $pep"_water" -o $pep"_genion"
         echo 13 | gmx genion -s $pep"_genion" -neutral -pname NA+ -nname CL- -p $pep -o $pep"_water"
         sed -i '2 i\#include "martini_v2.0_ions.itp"' $pep".top"
      done
   done
done

# clean up back-up files

rm -f \#*

exit
