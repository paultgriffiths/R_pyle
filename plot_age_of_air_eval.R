# R script to plot and calculate the zonal 
# mean age of air.

# Alex Archibald, March 2012


# define constants and conv. factors
conv.factor <- 60*60*24*30*12 # assumes a 360 day calendar
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")
time  <- get.var.ncdf(nc1, "t")

aoa.nc  <- open.ncdf(paste(obs.dir, "MIPAS/MIPAS_AGE_OF_AIR_2002-2010.nc",sep=""), readunlim=F)
aoa     <- get.var.ncdf(aoa.nc, "AGE")
aoa.lat <- rev(get.var.ncdf(aoa.nc, "lat"))
aoa.alt <- get.var.ncdf(aoa.nc, "altitude")

# The MIPAS data is for 2002-2010 and is already monthly 
# averaged zonal means. Here we combine those into 
# one average and reorder the array.
aoa.m   <- apply(aoa, c(2,1), mean, na.rm=T)
aoa.m   <- aoa.m[rev(1:length(aoa.lat)),]
aoa.std <- apply(aoa, c(2,1), sd, na.rm=T)
aoa.std <- aoa.std[rev(1:length(aoa.lat)),]

# define model tropopause height on pressure (using scale height from UKCA)
#ht     <- get.var.ncdf(nc1, "ht")
#ht     <- apply(ht, c(2), mean)*1E-3 # km

age   <- get.var.ncdf(nc1, age.air) # *3.0 ## NOTE I made a mistake in my umui job set up so have had to multiply fluxes (here) by three!!
age   <- (apply(age, c(2,3), mean))/conv.factor

# The model AoA is set such that the value of air at the tropopause 
# is 0.0 years. Therefore, we bias subtract the obs to account for this
aoa.m <- aoa.m - mean(aoa.m[16:20,13:18])

# Subset the model and obs for the CCMVal plots
trop.mean.ukca  <- apply(age[tail(which(lat<= -10.0),1):which(lat>= 10.0)[1],], c(2), mean)
trop.mean.mipas <- apply(aoa.m[tail(which(aoa.lat<= -10.0),1):which(aoa.lat>= 10.0)[1],], c(2), mean)
trop.stdev.mipas<- apply(aoa.std[tail(which(aoa.lat<= -10.0),1):which(aoa.lat>= 10.0)[1],], c(2), mean)

midlat.mean.ukca  <- apply(age[tail(which(lat<= 35.0),1):which(lat>= 45.0)[1],], c(2), mean)
midlat.mean.mipas <- apply(aoa.m[tail(which(aoa.lat<= 35.0),1):which(aoa.lat>= 45.0)[1],], c(2), mean)
midlat.stdev.mipas<- apply(aoa.std[tail(which(aoa.lat<= 35.0),1):which(aoa.lat>= 45.0)[1],], c(2), mean)

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_age_of_air_ccmval.pdf", sep=""),width=6,height=7,paper="special",onefile=TRUE,pointsize=12)
par(mfrow=c(2,2))
par(oma=c(0,0,1,0)) 
par(mgp = c(2, 1, 0))

# plot the data 
plot(trop.mean.ukca, hgt/1000, xlab="Mean age (years)", ylab="Altitude (km)", 
xlim=c(0,7), ylim=c(16,34), col="red", type="l", lwd=2.0, main="Tropical Mean Age Profile" ) 
# add the obs
lines(trop.mean.mipas, aoa.alt, lwd=2, type="o", pch=15)
arrows( (trop.mean.mipas-trop.stdev.mipas), aoa.alt, (trop.mean.mipas+trop.stdev.mipas), aoa.alt, length=0.0, code=2 )
grid()

title(main=paste(mod1.name,"mean age of air", sep=" "), outer=T, col.main="black")

# plot the data 
plot(midlat.mean.ukca, hgt/1000, xlab="Mean age (years)", ylab="Altitude (km)", 
xlim=c(0,7), ylim=c(16,34), col="red", type="l", lwd=2.0, main="Midlatitude Mean Age Profile" ) 
# add the obs
lines(midlat.mean.mipas, aoa.alt, lwd=2, type="o", pch=15)
arrows( (midlat.mean.mipas-midlat.stdev.mipas), aoa.alt, (midlat.mean.mipas+midlat.stdev.mipas), aoa.alt, length=0.0, code=2 )
grid()

# plot the data 
plot( (midlat.mean.ukca-trop.mean.ukca), hgt/1000, xlab="Mean age gradient (years)", ylab="Altitude (km)", 
xlim=c(0,3.5), ylim=c(16,34), col="red", type="l", lwd=2.0, main="Trop-Midlat Mean Age Gradient Profile" ) 
# add the obs
lines( (midlat.mean.mipas-trop.mean.mipas), aoa.alt, lwd=2, type="o", pch=15)
grid()
legend("bottomright", c(mod1.name, expression(SF[6]) ), lwd=c(1,1), col=c("red", "black"), pch=c(0,15), bty="n", cex=0.85)

# plot the data 
plot(lat, age[,which(hgt>=2.3E4)[1]], xlab="Latitude (degrees)", ylab="Mean age (years)", 
xlim=c(-90,90), ylim=c(0,6), col="red", type="l", lwd=2.0, main="Mean Age, 23km (~50hPa)" ) 
# add the obs
lines(aoa.lat, aoa.m[,23], lwd=2, type="o", pch=15)
arrows( aoa.lat, (aoa.m[,23]-aoa.std[,23]), aoa.lat, (aoa.m[,23]+aoa.std[,23]), length=0.0, code=2 )
grid()

dev.off()
