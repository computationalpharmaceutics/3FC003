set filelist [glob TYR-???-TYR_eq.gro]
foreach file $filelist {
mol new $file
mol modcolor 0 top {colorID 1}
mol modstyle 0 top VDW
mol modselect 0 top "not resname W and name BB" 
set sel1 [atomselect top "not resname W and name BB"]
$sel1 set radius 1.9
mol addrep top
mol modselect 1 top "resname PHE and not name BB or resname TRP and not name BB or resname HIS and not name BB or resname TYR and not name BB"
mol modcolor 1 top {colorID 8}
mol modstyle 1 top VDW
set sel2 [atomselect top "resname PHE and not name BB or resname TRP and not name BB or resname HIS and not name BB or resname TYR and not name BB"]
$sel2 set radius 1.5
mol addrep top
mol modcolor 2 top {colorID 8}
mol modstyle 2 top VDW
mol modselect 2 top "not resname W and not name BB and not resname PHE TRP HIS TYR" 
mol addrep top
mol modselect 3 top "resname W and within 5 of not resname W"
mol modcolor 3 top {colorID 0}
mol modstyle 3 top VDW
mol off top}
