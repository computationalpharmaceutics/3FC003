#!/bin/bash

declare -a aminoacid1=("TYR")
declare -a aminoacid2=("ALA" "CYS" "ASP" "GLU" "PHE" "GLY" "HIS" "ILE" "LYS" "LEU" "MET" "ASN" "PRO" "GLN" "ARG" "SER" "THR" "VAL" "TRP" "TYR")
#declare -a aminoacid2=("TYR")
declare -a aminoacid3=("TYR")
echo "pep               AP" > sasa_trip.txt
echo "pep         Time     nr_at Time   Itot    Ix    Iy    Iz" > inertia_trip.txt 


for i in "${aminoacid1[@]}"
do
   for j in "${aminoacid2[@]}"
   do
      for k in "${aminoacid3[@]}"
      do
         pep=$i"-"$j"-"$k
#cluster peptides across periodic boundaries
         echo 1 1 1 | gmx trjconv -f "../4_Running_simulations/"$pep"_eq.gro" -s "../4_Running_simulations/"$pep"_eq.tpr" -pbc cluster -center -o $pep"_clustered.gro"
#calculate change in solvent-accessible surface area
         echo 1 1 | gmx sasa -f "../4_Running_simulations/"$pep"_min.gro" -s "../4_Running_simulations/"$pep"_min.tpr" -o $pep"_sasa_init.xvg" -surface 'group "Protein"' -probe 0.4
         echo 1 1 | gmx sasa -f $pep"_clustered.gro" -s "../4_Running_simulations/"$pep"_eq.tpr" -o $pep"_sasa_end.xvg" -surface 'group "Protein"' -probe 0.4
         sasa_init=`tail -n 1 $pep"_sasa_init.xvg" | awk '{print $2}'`
         sasa_end=`tail -n 1 $pep"_sasa_end.xvg" | awk '{print $2}'`
         echo $sasa_init
         AP=`bc <<< "scale=3 ; $sasa_init/$sasa_end"`
         echo $pep $AP >> sasa_trip.txt
#calculate moments of inertia along principal axes of largest cluster
         gmx make_ndx -f "../4_Running_simulations/"$pep"_eq.gro" -o $pep"_noW.ndx" < options.txt
         gmx convert-tpr -s "../4_Running_simulations/"$pep"_eq.tpr" -n $pep"_noW.ndx" -nsteps -1 -o $pep"_noW.tpr"
         gmx clustsize -f "../4_Running_simulations/"$pep"_eq.xtc" -s "../4_Running_simulations/"$pep"_eq.tpr" -mcn $pep"_maxclust.ndx" -n $pep"_noW.ndx" -cut 0.5
         gmx trjconv -f $pep"_clustered.gro" -s $pep"_noW.tpr" -n $pep"_maxclust.ndx" -o $pep"_maxclust.gro"
         gmx convert-tpr -s $pep"_noW.tpr" -n $pep"_maxclust.ndx" -nsteps -1 -o $pep"_maxclust.tpr"
         echo 1 | gmx editconf -f $pep"_maxclust.gro" -princ -c -o $pep"_princ.gro"
         echo 1 | gmx gyrate -f $pep"_princ.gro" -s $pep"_maxclust.tpr" -moi -o $pep"_gyrate.xvg" 
         mois=`tail -n 1 $pep"_gyrate.xvg"`
         nratominclust=`tail -n 1 maxclust.xvg`
         echo $pep $nratominclust $mois >> inertia_trip.txt
       done
   done
done

# cleanup 

rm -f \#*

exit


