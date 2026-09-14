#!/bin/bash

declare -a aminoacid1=("TYR")
declare -a aminoacid2=("ALA" "CYS" "ASP" "GLU" "PHE" "GLY" "HIS" "ILE" "LYS" "LEU" "MET" "ASN" "PRO" "GLN" "ARG" "SER" "THR" "VAL" "TRP" "TYR")
declare -a aminoacid3=("TYR")

for i in "${aminoacid1[@]}"
do
   for j in "${aminoacid2[@]}"
   do
      for k in "${aminoacid3[@]}"
      do
         pep=$i"-"$j"-"$k
#run simulations
         gmx grompp -f tripep_water_min.mdp -p "../3_Coarse-graining/"$pep -c "../3_Coarse-graining/"$pep"_water" -o $pep"_min" -maxwarn 2
         gmx mdrun -v -deffnm $pep"_min"
         gmx grompp -f tripep_water_eq.mdp -p "../3_Coarse-graining/"$pep -c $pep"_min" -o $pep"_eq" -maxwarn 2
         gmx mdrun -v -deffnm $pep"_eq"
# clean up back-up files
         rm -f \#*
      done
   done
done

exit


