# R Script to plot O3 net tendency 
# in the style of Joeckel et al., 2006 ACP

# Alex Archibald, July 2012

# call the interpolate zm function and pass in the variable (var) to 
# be interpolated and the values (pres) to interpolate onto
var  <- o3.net.code
conv <- 1E6
nav  <- 6.02214179E23

source(paste(script.dir, "check_model_dims.R", sep=""))
source(paste(script.dir, "Filled.contour3.R", sep=""))
source(paste(script.dir, "Filled.legend.R", sep=""))

# extract/define variables
lon    <- get.var.ncdf(nc1, "longitude")
lat    <- get.var.ncdf(nc1, "latitude")
hgt    <- get.var.ncdf(nc1, "hybrid_ht")
time   <- get.var.ncdf(nc1, "t")

# define empty arrays 
net.o3.std <- array(NA, dim=c(length(lon), length(lat), length(hgt), length(time)) )

# define pressure levels to interpolate onto NOTE these are in hPa!!
pres <- c(1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,
500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10,7,5,3,2,1,
0.7,0.5,0.3,0.2,0.1)

# need to perform a series of manipulations on the model data before
# doing the pressure interpolation
net.o3 <- get.var.ncdf(nc1, o3.net.code)
# convert from moles/gridbox/s -> molecules/cm3/s
for (i in 1:length(time) ) {
net.o3.std[,,,i] <- ( net.o3[,,,i]/vol) }
net.o3.std <- net.o3.std*nav
net.o3.std <- net.o3.std/1E6

# copy this array to pass it into the interpolation script
into.interp <- net.o3.std

# check to see if the model is on the same grid as the obs (currently N48)
if (length(lat) != 73 ) {
source(paste(script.dir, "interpolate_zm_n96_eval.R", sep=""))
} else {
source(paste(script.dir, "interpolate_zm_alt_eval.R", sep=""))
}

# set the plotting field to the interpolated field
#o3.zm <- apply(newvv, c(1,2), mean)/1E6
o3.zm <- newvv/1E6
rm(newvv)
rm(var)

# create a nice log scale for the y axis.
# This transfrmation was taken from the skewty.R function from the ozone sonde package
log.z <-  132.18199999999999 - 44.061 * log10(pres)
# ###################################################################################################################################
# set axis'
axis_x <- seq(from=-90, to=90, by=20)

# the y axis labels get a bit crowded so here is a cut down set:
y.labs <- c(1000,700,500,250,150,100,70,50,30,20,10,7,5,3,2,1,0.7,0.5,0.3,0.2,0.1)
y.labs2 <- c(150,100,50,10,5,1,0.5,0.1)

# set limits for plots and data
zmin <- -1.0
zmax <- 1.0
o3.zm.raw <- o3.zm
o3.zm[o3.zm>=zmax] <- zmax
o3.zm[o3.zm<=zmin] <- zmin

# set plotting colors
col.cols  <- colorRampPalette(c("purple", "blue", "green", "yellow", "red", "darkred"))

# set levels to plot contors at
levs_1 = c(-1.0,-0.50,-0.2,-0.1,-0.05,-0.02,0,0.02,0.05,0.1,0.2,0.5,1)
l_lev_1<- (length(levs_1)-1)
cbar <- col.cols
cols <- cbar(13)

#
# Custom axis producing even spacing of levels
customAxis <- function() {
  n <- length(levs_1)
  # Generate even spacing over y-scale range
  y <- seq(min(levs_1), max(levs_1), length.out=n)
  # Draw main key with rectangles
  # (using same colours as in main plot)
  rect(0, y[1:(n-1)], 1, y[2:n], 
  col=cols)
  # Draw key axis
  # NOTE: labels do not correspond to "real" y-locations
  axis(4, at=y, labels=levs_1)
}

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_Net_Chemical_O3_Zonal_mean.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

#plot.new() is necessary if using the modified versions of filled.contour
plot.new()

#I am organizing where the plots appear on the page using the "plt" argument in "par()"
par(new = "TRUE",plt = c(0.1,0.4,0.60,0.95),las = 1,cex.axis = 1)

#Top left plot:
filled.contour3(lat, log.z[25:42], o3.zm[,25:42,6], 
color=col.cols, 
levels=levs_1,
ylab="Altitude (hPa)", xlab="", 
main="", 
zlim=c(-1,1), 
xaxt="n", yaxt="n",
ylim=c(log.z[25],log.z[42]), plot.axes= {
contour(lat, log.z[25:42], o3.zm[,25:42,6], method = "edge", labcex = 1, col = "gray", cex=0.7, add = TRUE, lty=1, levels=levs_1) 
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, log.z[25:42], tick=TRUE, labels=FALSE)
axis(side=2, log.z[c(25,27,29,32,34,37,39,42)],   labels=sprintf("%1g", y.labs2), tick=TRUE) } )

par(xpd=NA)
text(0,182, paste("Min =",sprintf("%1.3g", min(o3.zm.raw[,25:42,6], na.rm=T) ), "Max =", sprintf("%1.3g", max(o3.zm.raw[,25:42,6], na.rm=T) ), sep=" ") )

#Top right plot:
par(new = "TRUE",plt = c(0.5,0.8,0.60,0.95),las = 1,cex.axis = 1)
filled.contour3(lat, log.z[25:42], o3.zm[,25:42,8], 
color=col.cols, 
levels=levs_1,
ylab="", xlab="", 
main="", 
zlim=c(-1,1), 
xaxt="n", yaxt="n",
ylim=c(log.z[25],log.z[42]), plot.axes= {
contour(lat, log.z[25:42], o3.zm[,25:42,8], method = "edge", labcex = 1, col = "gray", cex=0.7, add = TRUE, lty=1, levels=levs_1) 
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, log.z[25:42], tick=TRUE, labels=FALSE)
axis(side=2, log.z[c(25,27,29,32,34,37,39,42)],   labels=sprintf("%1g", y.labs2), tick=TRUE) } )

par(xpd=NA)
text(0,182, paste("Min =",sprintf("%1.3g", min(o3.zm.raw[,25:42,8], na.rm=T) ), "Max =", sprintf("%1.3g", max(o3.zm.raw[,25:42,8], na.rm=T) ), sep=" ") )

#Bottom left plot:
par(new = "TRUE",plt = c(0.1,0.4,0.15,0.5),las = 1,cex.axis = 1)
filled.contour3(lat, log.z[25:42], o3.zm[,25:42,12], 
color=col.cols, 
levels=levs_1,
ylab="Altitude (hPa)", xlab="Latitude (degrees)", 
main="", 
zlim=c(-1,1), 
xaxt="n", yaxt="n",
ylim=c(log.z[25],log.z[42]), plot.axes= {
contour(lat, log.z[25:42], o3.zm[,25:42,12], method = "edge", labcex = 1, col = "gray", cex=0.7, add = TRUE, lty=1, levels=levs_1) 
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, log.z[25:42], tick=TRUE, labels=FALSE)
axis(side=2, log.z[c(25,27,29,32,34,37,39,42)],   labels=sprintf("%1g", y.labs2), tick=TRUE) } )

par(xpd=NA)
text(0,182, paste("Min =",sprintf("%1.3g", min(o3.zm.raw[,25:42,12], na.rm=T) ), "Max =", sprintf("%1.3g", max(o3.zm.raw[,25:42,12], na.rm=T) ), sep=" ") )

#Bottom right plot:
par(new = "TRUE",plt = c(0.5,0.8,0.15,0.5),las = 1,cex.axis = 1)
filled.contour3(lat, log.z[25:42], o3.zm[,25:42,2], 
color=col.cols, 
levels=levs_1,
ylab="", xlab="Latitude (degrees)", 
main="", 
zlim=c(-1,1), 
xaxt="n", yaxt="n",
ylim=c(log.z[25],log.z[42]), plot.axes= {
contour(lat, log.z[25:42], o3.zm[,25:42,2], method = "edge", labcex = 1, col = "gray", cex=0.7, add = TRUE, lty=1, levels=levs_1) 
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, log.z[25:42], tick=TRUE, labels=FALSE)
axis(side=2, log.z[c(25,27,29,32,34,37,39,42)],   labels=sprintf("%1g", y.labs2), tick=TRUE) } )

par(xpd=NA)
text(0,182, paste("Min =",sprintf("%1.3g", min(o3.zm.raw[,25:42,2], na.rm=T) ), "Max =", sprintf("%1.3g", max(o3.zm.raw[,25:42,2], na.rm=T) ), sep=" ") )

par(xpd = NA)
#Add a legend:
par(new = "TRUE",plt = c(0.85,0.9,0.25,0.85),las = 1,cex.axis = 1)
filled.legend(lat,log.z[25:42],o3.zm,color = col.cols,key.axis=customAxis(),
xlab = "",ylab = "",xlim = "",ylim = "",zlim = c(zmin,zmax) )
text(0.5,1.2,mod1.name)

dev.off()
