# R Script to calculate the tropospheric hcho column using
# tropopause mask.

# Alex Archibald, February 2012

# OMI trop HCHO column in 10^15 molecules/cm2
nc0 <- open.ncdf(paste(obs.dir, "OMI/HCHO/OMI_HCHO_2005_N48_2.nc", sep=""), readunlim=FALSE)

# extract vars
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")
time  <- get.var.ncdf(nc1, "t")

# define constants and loop vars and arrays
nav      <- 6.02214179E23 
mmr.hcho <- 30.0e-3 # in kg
hcho.col <- array(NA, dim=c(length(lon),length(lat),length(time)) ) 
m <- NULL

source(paste(script.dir, "check_model_dims.R", sep=""))

hcho    <- get.var.ncdf(nc1,hcho.code) # kg/kg hcho
trophgt <- get.var.ncdf(nc1,"ht")
omi.hcho<- get.var.ncdf(nc0, "OMI_HCHO") # OMI trop HCHO in molecules cm-2 (E15)
sat.lat <- get.var.ncdf(nc0, "latitude")

# #####################################################################
# Check to see if a trop. mask and mass exist?
if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source(paste(script.dir, "calc_trop_mask.R", sep="")))
if ( exists("mass") == TRUE) print("Tropospheric Mass exists, carrying on") else (mass <- get.var.ncdf(nc1,air.mass) )
# Start calculate column ############################################################################################################
# mask out troposphere and convert to molecules 
# n.molecules = NA(molecules/mol) * mass(g) / mmr(g/mol) )
hcho.mass <- (hcho * mass * mask)

# convert to molecules 
hcho.mol <- nav * (hcho.mass/mmr.hcho) 

# HCHO column = sum in vertical (kg)
hcho.mol <- apply(hcho.mol,c(1,2,4),sum)

# loop over each month
# divide by area (molecules/m2) 
for (m in 1:length(time)) {
  hcho.col[,,m] <- (hcho.mol[,,m] /  gb.sa[,])
} 

# apply zonal mean
hcho.col <- apply(hcho.col, c(1,2), mean) / (100 * 100 * 1E15) 
omi.hcho <- apply(omi.hcho, c(1,2), mean, na.rm=T)

# End calculate column #############################################################################################################

# set axis'
axis_x <- seq(from=-180, to=180, by=30)
axis_y <- seq(from=-90, to=90, by=15)

zlim   <- seq(0,20,1)
nlevels<- 21
levels <- pretty(zlim, nlevels)

# set all high values to 20 for plots
hcho.raw <- hcho.col
hcho.col[hcho.col>20]<-20.0
omi.hcho[omi.hcho<0.]<-NA

# find the index for the mid latitude in the array
midlon   <- which(lon>=180.0)[1]
maxlon   <- length(lon)
dellon   <- lon[2]-lon[1]
hcho.col <- abind(hcho.col[midlon:maxlon,], hcho.col[1:midlon-1,], along=1)
# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_Trop_HCHO_col.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
filled.contour(seq(-180,(180-dellon),dellon), lat, hcho.col, ylab="Latitude (degrees)", xlab="Longitude (degrees)", main=paste(mod1.name, "tropospheric HCHO column", sep=" "), 
zlim=c(0,20), col=col.cols(length(levels)-1), xaxt="n",nlevels=nlevels, 
plot.axes= {
#contour(1:12, lat, hcho.col, method = "edge", labcex = 1, col = "black", add = TRUE, lty=1, levels=seq(0,70,5))
#contour(lon, lat, hcho.col, method = "edge", labcex = 1, col = "black", add = TRUE, lty=1, lwd=1, levels=seq(0,20,1))
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, axis_y, labels=TRUE, tick=TRUE)
map("world", add=T)
grid() } )

par(xpd=T)
text(-120,95, paste("Min =",sprintf("%1.3g", min(hcho.raw) ), "Mean =", sprintf("%1.3g", mean(hcho.raw) ), "Max =", sprintf("%1.3g", max(hcho.raw) ), sep=" ") )
text(x=70,y=95, expression(paste("10"^"15", " (molecules cm"^"-2",")", sep="") ), font=2)
par(xpd=F)

dev.off()

