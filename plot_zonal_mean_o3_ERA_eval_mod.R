# R Script to plot model.1 vs MLS o3 data 

# Alex Archibald, July 2012

# call the interpolate zm function and pass in the variable (var) to 
# be interpolated and the values (pres) to interpolate onto
var <- o3.code
conv <- 1E6

# define pressure levels to interpolate onto NOTE these are in hPa!!
pres <- c(1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,
500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10,7,5,3,2,1,
0.7,0.5,0.3,0.2,0.1)

# extract the MLS Obs
#nc0 <- open.ncdf(paste(obs.dir, "UARS/uars_clim.nc", sep=""), readunlim=FALSE)
#mls.o3 <- get.var.ncdf(nc0, "tr03") # this is the setting component
#mls.o3 <- apply(mls.o3, c(1,2), mean)

# extract/define variables
lat    <- get.var.ncdf(nc1, "latitude")
#mls.lat<- get.var.ncdf(nc0, "latitude")
#hgt    <- get.var.ncdf(nc0, "z")

# check to see if the model is on the same grid as the obs (currently N48)
if (length(lat) != 73 ) {
source(paste(script.dir, "interpolate_zm_n96_eval.R", sep=""))
} else {
source(paste(script.dir, "interpolate_zm_eval.R", sep=""))
}

# define model tropopause height on pressure (using scale height from UKCA)
ht     <- get.var.ncdf(nc1, trop.pres.code)
ht     <- apply(ht, c(2), mean)*1E-2 # (convert to hPa)

# set the plotting field to the interpolated field
o3.zm <- newvv*(conv/mm.o3) #apply(newvv, c(1,2), mean)*(conv/mm.o3)
#rm(newvv)
#rm(var)

# create a nice log scale for the y axis.
# This transfrmation was taken from the skewty.R function from the ozone sonde package
log.z <-  132.18199999999999 - 44.061 * log10(pres)
log.ht<-  132.18199999999999 - 44.061 * log10(ht)
#mls.hgt<- 132.18199999999999 - 44.061 * log10(hgt)
# ###################################################################################################################################
# set axis'
axis_x <- seq(from=-90, to=90, by=15)

# the y axis labels get a bit crowded so here is a cut down set:
y.labs <- c(1000,700,500,250,150,100,70,50,30,20,10,7,5,3,2,1,0.7,0.5,0.3,0.2,0.1)

# set limits for plots and data
zmin <- 0.0
zmax <- 12.0
o3.zm[o3.zm>=zmax] <- zmax
o3.zm[o3.zm<=zmin] <- zmin

col.scale <- colorRampPalette(brewer.pal(9,"Reds"))
# ###################################################################################################################################
time <- seq(1:12)
# loop and plot
i <- NULL
for (i in 1:12) {
    if(i < 10) {  png(file=paste(out.dir,"Plot_00", i, ".png", sep=""), 
                    height=600, width=900, units="px", bg="white", pointsize=12)
  }    
  if(i >= 10) if(i < 100) {  png(file=paste(out.dir,"Plot_0", i, ".png", sep=""), 
                                height=600, width=900, units="px", bg="white", pointsize=12)
  }
  filled.contour(lat, log.z, o3.zm[,,i], ylab="Altitude (hPa)", xlab="Latitude (degrees)", 
                 main=bquote(paste( "HALOE - ", .(mod1.name), ~ O[3], " comparison", sep=" ")), 
                 zlim=c(zmin,11), col=col.scale(22),
                 xaxt="n", yaxt="n",key.title = title("ppm"),
                 ylim=c(log.z[1],log.z[42]), plot.axes= {
                   contour(lat, log.z, o3.zm[,,i], method = "edge", labcex = 1, col = "gray", cex=0.7, add = TRUE, lty=1, levels=seq(0.5,11.5,1)) 
                   #contour(mls.lat, mls.hgt, mls.o3, method = "edge", labcex = 1, col = "black", add = TRUE, lty=1, levels=seq(0.5,11.5,1)) # obs
                   lines(lat, log.ht, lwd=2, lty=2)
                   axis(side=1, axis_x, labels=TRUE, tick=TRUE)
                   axis(side=2, log.z, labels=FALSE, tick=TRUE)
                   axis(side=2, log.z[c(1,12,16,21,25,27:42)],   labels=sprintf("%1g", y.labs), tick=TRUE)
                   grid() } )
  
  par(xpd=T)
  text(-70,180, paste("Min =",sprintf("%1.3g", min(o3.zm[,,i], na.rm=T) ), "Max =", sprintf("%1.3g", max(o3.zm[,,i], na.rm=T) ), "Month = ", i, sep=" ") )
  par(xpd=F)
  
  
  dev.off()
}


