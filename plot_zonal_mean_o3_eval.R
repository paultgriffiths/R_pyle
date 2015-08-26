# R Script to plot zonal mean model O3 

# Alex Archibald, May 2012


# extract obs
nc0         <- open.ncdf(paste(obs.dir, "UARS/o3_uars_regrid.nc", sep=""))
uars.lat   <- get.var.ncdf(nc0, "latitude")
uars.hgt   <- get.var.ncdf(nc0, "z")*1E-3
uars.o3    <- get.var.ncdf(nc0, "tr03")
uars.o3    <- apply(uars.o3, c(1,2), mean)

# extract/define variables
lat    <- get.var.ncdf(nc1, "latitude")
hgt    <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
conv   <- 1E6 # ppm

# ###################################################################################################################################
# set axis'
axis_x <- seq(-90,90,15)
axis_y <- seq(0,65,5)

# set limits for plots and data
zmin <- 0.0
zmax <- 12.0
o3.zm <- apply( (get.var.ncdf(nc1, o3.code)*conv/mm.o3), c(2,3), mean)
o3.zm[o3.zm>=zmax] <- zmax
o3.zm[o3.zm<=zmin] <- zmin
# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_Ozone_Zonal_mean.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
filled.contour(lat, hgt, o3.zm, ylab="Altitude (km)", xlab="Latitude (degrees)", main=paste("UARS - UKCA",mod1.name,"Ozone comparison",sep=" "), zlim=c(zmin,11), col=col.cols(22),
key.title = title("ppm"),
ylim=c(0,65), 
plot.axes= {
contour(lat, hgt, o3.zm, method = "edge", labcex = 1, col = "gray", cex=0.7, add = TRUE, lty=1, levels=seq(0,10,1)) 
contour(uars.lat, uars.hgt, uars.o3, method = "edge", labcex = 1, col = "black", add = TRUE, lty=1, levels=seq(0.5,10.5,1)) # obs
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, axis_y, labels=TRUE, tick=TRUE)
grid() } )

par(xpd=T)
text(-70,67, paste("Min =",sprintf("%1.3g", min(o3.zm) ), "Max =", sprintf("%1.3g", max(o3.zm) ), sep=" ") )
par(xpd=F)

dev.off()

# ###################################################################################################################################
