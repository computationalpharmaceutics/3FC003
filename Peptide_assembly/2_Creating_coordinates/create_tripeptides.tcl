package require psfgen
topology top_all36_prot.rtf
pdbalias residue HIS HSD
segment pep {pdb XXX-YYY-ZZZ_aa.pdb}
coordpdb XXX-YYY-ZZZ_aa.pdb pep
guesscoord
writepdb XXX-YYY-ZZZ_aa.pdb
exit
