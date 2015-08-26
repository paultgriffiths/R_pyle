# R Script to plot zonal mean model HNO3 

# Alex Archibald, July 2012


# extract obs
nc0         <- open.ncdf(paste(obs.dir, "ACE/ACE_vn3.1_2006-2009_zm_combined_extrap.nc", sep=""), readunlim=FALSE)
ace.lat   <- get.var.ncdf(nc0, "latitude")
ace.hgt   <- get.var.ncdf(nc0, "height")
ace.hono2    <- get.var.ncdf(nc0, "HNO3")*1E9
ace.hono2    <- apply(ace.hono2, c(1,2), mean)

# extract/define variables
lat    <- get.var.ncdf(nc1, "latitude")
hgt    <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
conv   <- 1E9 # ppb

# ###################################################################################################################################
# set axis'
axis_x <- seq(-90,90,15)
axis_y <- seq(0,65,5)

# set limits for plots and data
zmin <- 0.0
zmax <- 12.0
hono2.zm <- apply( (get.var.ncdf(nc1, hono2.code)*conv/mm.hono2), c(2,3), mean)
hono2.zm[hono2.zm>=zmax] <- zmax
hono2.zm[hono2.zm<=zmin] <- zmin
# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_HNO3_Zonal_mean.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
filled.contour(lat, hgt, hono2.zm, ylab="Altitude (km)", xlab="Latitude (degrees)", main=paste("ACE - UKCA",mod1.name,"HNO3 comparison",sep=" "), zlim=c(zmin,11), col=col.cols(22),
key.title = title("ppb"),
ylim=c(0,65), 
plot.axes= {
contour(lat, hgt, hono2.zm, method = "edge", labcex = 1, col = "gray", cex=0.7, add = TRUE, lty=1, levels=seq(0,10,1)) 
contour(ace.lat, ace.hgt, ace.hono2, method = "edge", labcex = 1, col = "black", add = TRUE, lty=1, levels=seq(0.5,10.5,1)) # obs
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, axis_y, labels=TRUE, tick=TRUE)
grid() } )

par(xpd=T)
text(-70,67, paste("Min =",sprintf("%1.3g", min(hono2.zm) ), "Max =", sprintf("%1.3g", max(hono2.zm) ), sep=" ") )
par(xpd=F)

dev.off()

# ###################################################################################################################################
