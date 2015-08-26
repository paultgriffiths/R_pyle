# R script to plot and calculate the NOx lifetime
# in the troposphere.

# Alex Archibald, March 2012


# define constants and conv. factors
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")
time  <- get.var.ncdf(nc1, "t")
# convert seconds to hours
conv  <- 60*60

source(paste(script.dir, "check_model_dims.R", sep=""))

# extract the NOx 
no      <- get.var.ncdf(nc1,no.code) # kg/kg no
no2     <- get.var.ncdf(nc1,no2.code) # kg/kg no2
nox     <- no2 # +no2

# Check to see if a trop. mask and mass exist?
if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source("calc_trop_mask.R"))
if ( exists("mass") == TRUE) print("Tropospheric Mass exists, carrying on") else (mass <- get.var.ncdf(nc1,air.mass) )

# mask out troposphere and convert to mass of NOx (kg) 
nox <- (nox * mass * mask) / 46.0e-3

loss <- get.var.ncdf(nc1, oh.no2.code) 

# COMMENT OUT THE FOLLOWING -- Now using OH + NO2 flux rather than actual loss of NOy..
# extract NOx loss terms (NOTE these are actually Ox loss but are ~ NOx loss)
# 2d array
#l1.9 <- get.var.ncdf(nc1,noy.dd.code)
# 3d noy wet dep
#l1.10 <- get.var.ncdf(nc1,noy.wd.code)

# lifetime is [NOx]/loss of NOx
tau     <- sum(nox) / sum(loss) 
tau.nox <- sprintf("%1.3g", tau/conv)

# grid the data for plotting:
nox.burd <- apply(nox,c(1,2,3),sum)
nox.loss <- apply(loss, c(1,2,3), sum)
#nox.ddep <- apply(l1.9*38.0e-3, c(1,2), sum)
#nox.wdep <- apply(l1.10*38.0e-3, c(1,2), sum)

tau.map <- nox.burd[,,1]/nox.loss[,,1] #(nox.ddep+nox.wdep)
tau.map <- tau.map/conv
tau.map[tau.map>quantile(tau.map, 0.9)] <- quantile(tau.map, 0.9)
# ###################################################################################################################################

# find the index for the mid longitude in the array
midlon <- which(lon>=180.0)[1]
maxlon <- length(lon)
dellon <- lon[2]-lon[1]

# reform array - makes it look nicer on map
tau.map <- abind(tau.map[midlon:maxlon,], tau.map[1:midlon-1,], along=1)

pdf(file=paste(out.dir,mod1.name,"_NOx_lifetime.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)
# overplot the data 
image.plot(seq(-180,(180-dellon),dellon), lat, tau.map, xlab="Latitude (degrees)", ylab="Latitude (degrees)", 
main=paste("UKCA",mod1.name, sep=" "), 
xlim=c(30,60), ylim=c(10,40), zlim=c(0,72), 
col=tau.cols(23) )
map("world", add=T)

par(xpd=T)
text(x=-150,y=95, paste("Mean lifetime = ", tau.nox, " hours", sep="") ) 
text(x=110,y=95, expression(paste("Trop. ", NO[x], " lifetime (hours)", sep="") ), font=2)

par(xpd=F)

dev.off()

