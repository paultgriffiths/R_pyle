# convert TR gas input to mixing ratios of 
# MeBr, CFCl3 and CF2Cl2

source(paste(script.dir, "get_mol_masses.R", sep=""))

conv <- 1E12

MeBr <- 2.91550E-11*(conv/mm.mebr)
MeCl <- 9.58800E-10*(conv/mm.mecl)
CH2Br2 <- 1.80186E-11*(conv/mm.ch2br2)
H2 <- 3.45280E-08*(conv/mm.h2)
N2 <- 0.75468*(conv/mm.n2)
CFC114 <- 1.00500E-10*(conv/mm.cf2clcf2cl)	# (CF2Cl)2
CFC115 <- 4.65550E-11*(conv/mm.cf2clcf3)	# C2F5Cl
CCl4 <- 5.25350E-10*(conv/mm.ccl4)		# CCl4
MeCCl3 <- 2.30050E-10*(conv/mm.meccl3)		# CH3CCl3
HCFC141b <- 4.81400E-11*(conv/mm.mecfcl2)	# CH3CFCl2
HCFC142b <- 4.01300E-11*(conv/mm.mecf2cl)	# CH3CF2Cl
H1211 <- 2.29050E-11*(conv/mm.cf2clbr)		# CF2ClBr
H1202 <- 3.55200E-13*(conv/mm.cf2br2)		# CF2Br2
H1301 <- 1.39200E-11*(conv/mm.cf3br)		# CF3Br
H2402 <- 3.71150E-12*(conv/mm.cf2brcf2br)	# (CF2Br)2

# values from UMUI
CFC11 <- 1.247e-09*(conv/mm.cfcl3)		# CFCl3
CFC12 <- 2.248e-09*(conv/mm.cf2cl2)		# CF2Cl2
CFC113<- 5.325e-10*(conv/mm.cf2clcfcl2)		# CF2ClCFCl2
HCFC22<-4.172e-10*(conv/mm.chf2cl)		# CHF2Cl

cfcl3  <- sum(CFC11+MeCl+CCl4+MeCCl3+HCFC141b+HCFC142b+H1211)
cf2cl2 <- sum(CFC12+CFC113+CFC114+CFC115+HCFC22) 
ch3br  <- sum(MeBr+H1211+H1202+H1301+H2402) # Add CH2Br2?

# From Morgenstern et al., 2009
# CFCl3  <- CFCl3, CCl4, CH3Cl, CH3CCl3, CH3CFCl2, CH3CF2Cl, CF2ClBr
# CF2Cl2 <- CF2Cl2, CF2ClCFCl2, (CF2Cl)2, C2F5Cl, CHF2Cl
# CH3Br  <- CH3Br, CF2ClBr, CF3Br, (CF2Br)2, CF2Br2