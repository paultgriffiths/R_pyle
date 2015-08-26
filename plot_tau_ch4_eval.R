# R script to plot and calculate the methane 
# lifetime in the troposphere.

# Alex Archibald, February 2012

# loop vars
i <- NULL; j <- NULL
nav      <- 6.02214179E23 

# extract/define variables
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
time  <- get.var.ncdf(nc1, "t")

# define empty arrays
flux.zm.nrm <- array(NA, dim=c(length(lon), length(lat), length(hgt), length(time)) )

# define model tropopause height on pressure (using scale height from UKCA)
ht     <- get.var.ncdf(nc1, trop.hgt.code)
ht     <- apply(ht, c(2), mean)*1E-3 # km

source(paste(script.dir, "check_model_dims.R", sep=""))

# #####################################################################
# Check to see if a trop. mask and mass exist?
if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source(paste(script.dir, "calc_trop_mask.R", sep="")))
if ( exists("mass") == TRUE) print("Tropospheric Mass exists, carrying on") else (mass <- get.var.ncdf(nc1, air.mass ))

# #####################################################################
# extract the grid box volumes and convert to cm3
vol <- get.var.ncdf(nc5, "vol_theta") * 100 * 100 * 100

# CH4 in kg in troposphere
# check to see if you have methane as a variable or if you 
# have to calculate it based as a constant fraction of air
if (mod1.type=="CheT") { 
ch4 <- get.var.ncdf(nc1, air.mass) * f.ch4 * mask
} else {
print ("Fetching variable methane...")
ch4 <- get.var.ncdf(nc1, ch4.code) * mask

# check the mask structure:
if ( (identical( dim(ch4) , dim (mass) )) == TRUE ) { 
print("Methane and Mass identical dims...")
ch4 <- ch4 * mass 
} else {
# loop over time and multiply by mass (kg)
for (i in 1:length(time) ) {
  ch4[,,,i] <- ch4[,,,i] * mass
}  }
}  # end if mod.type = CheT

# flux is in moles/gridcell/s --> kg/gridcell/s
flux <- get.var.ncdf(nc1, oh.ch4.rxn.code) * 16.0e-3 # kg/mole
flux <- flux *3.0 ## NOTE I made a mistake in my umui job set up so have had to multiply fluxes (here) by three!!

# tau CH4 = sum{CH4(kg)} / sum{OH+CH4(kg/s)}
tau  <- sum(ch4) / sum(flux)

# convert seconds to years
conv <- 60*60*24*30*12 # assumes you supply 12 months of data!

tau.ch4 <- sprintf("%1.3g", tau/conv)

# extract the reaction fluxes to plot as a 
# zonal mean
flux.zm <- get.var.ncdf(nc1, oh.ch4.rxn.code)

# loop over time and multiply by the volumes
for (j in 1:length(time) ) {
  flux.zm.nrm[,,,j] <- ( flux.zm[,,,j] * vol ) #* nav
}

# generate zonal mean in moles/cm^3
flux.zm.nrm <- apply(flux.zm.nrm, c(2,3), mean)

# ################################################################################
# some extra bits and bobs for the plot

# find index of hgt which is greater than 20 km's 
hindex   <- which((hgt)>=20)[1]
# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_tau_ch4.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
image.plot(lat, hgt[1:hindex], 100*(flux.zm.nrm[,1:hindex]/sum(flux.zm.nrm[,1:hindex])), xlab="Latitude (degrees)", ylab="Altitude (km)", 
main=bquote(paste( "", .(mod1.name), ~ "%" ~ CH[4], " + OH flux (moles cm"^-3*"", " s"^-1*"", ")", sep=" ")),
zlim=c(0,0.4), ylim=c(0,21), col=col.cols(43) )
# add tropopause
lines(lat, ht, lwd=2, lty=2)

par(xpd=T)
text(x=-45,y=18, paste("Methane lifetime = ", tau.ch4, " yr", sep="") )
par(xpd=F)

dev.off()

