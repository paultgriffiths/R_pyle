# R Script to plot model.1 vs u ERA data 

# Alex Archibald, February 2012


# ERA data
nc0 <- open.ncdf(paste(obs.dir, "ERA/erai_1989-2010_MM_u.nc", sep=""), readunlim=FALSE)

# extract/define variables
era.lat<- get.var.ncdf(nc0, "lat")
era.lat<- rev(era.lat)
era.lev<- get.var.ncdf(nc0, "lev")*1E-2
era.lev<- rev(era.lev)
era.z  <- get.var.ncdf(nc0, "u")
era.z  <- era.z[rev(1:length(era.lat)),,rev(1:length(era.lev)),]
era.z  <- apply(era.z, c(2,3), mean, na.rm=T)

# model data
lat    <- get.var.ncdf(nc1, "latitude_1")
hgt    <- get.var.ncdf(nc1, "p_1")
ukca   <- get.var.ncdf(nc1, u.code)
ukca.z <- apply(ukca, c(2,3), mean)

# define model tropopause height on pressure (using scale height from UKCA)
#lat.ht <- get.var.ncdf(nc1, "latitude")
#ht     <- get.var.ncdf(nc1, trop.pres.code)
#ht     <- apply(ht, c(2), mean)*1E-2 # (convert to hPa)

# create a nice log scale for the y axis.
# This transfrmation was taken from the skewty.R function from the ozone sonde package
log.z <-  132.18199999999999 - 44.061 * log10(hgt)
log.era <-  132.18199999999999 - 44.061 * log10(era.lev)

# ###################################################################################################################################
# find the index of the tropopause-ish level (100 hPa)
bot    <- which(hgt==1000.0)
trop   <- which(hgt==10.0)

# set axis'
axis_x <- seq(from=-90, to=90, by=15)

# the y axis labels get a bit crowded so here is a cut down set:
y.labs <- c(1000,700,500,250,150,100,70,50,30,20,10)

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"-ERA_Zonal_Winds.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
filled.contour(lat, log.z, ukca.z, ylab="Altitude (hPa)", xlab="Latitude (degrees)", main=paste(mod1.name, "vs ERA","Zonal Wind", sep=" "), 
zlim=c(-40,40), col=heat.cols(16), xaxt="n", yaxt="n",key.title = title("m/s"),
plot.axes= {
# plot ERA data over the top
contour(era.lat, log.era, era.z, method = "edge", lwd=0.7, labcex = 1, col = "black", add = TRUE, lty=1, levels=seq(0,40,5)) #positive
contour(era.lat, log.era, era.z, method = "edge", lwd=0.7, labcex = 1, col = "black", add = TRUE, lty=2, levels=seq(-40,0,5)) #negative
#lines(lat.ht, ht, lwd=2, lty=2)
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, log.z, labels=FALSE, tick=TRUE)
axis(side=2, log.z[c(1,4,6,9,11:17)], labels=sprintf("%1g", y.labs), tick=TRUE)
grid() } )

par(xpd=T)
text(-60,90, paste("Min =",sprintf("%1.3g", min(ukca.z[,bot:trop],  na.rm=T ) ), "Mean =", sprintf("%1.3g", mean(ukca.z[,bot:trop],  na.rm=T ) ), "Max =", sprintf("%1.3g", max(ukca.z[,bot:trop],  na.rm=T ) ), sep=" ") )
text(15,90, paste("Min =",sprintf("%1.3g", min(era.z[,bot:trop],  na.rm=T ) ), "Mean =", sprintf("%1.3g", mean(era.z[,bot:trop],  na.rm=T ) ), "Max =", sprintf("%1.3g", max(era.z[,bot:trop],  na.rm=T ) ), sep=" "), col="red" )
par(xpd=F)

dev.off()

# ###################################################################################################################################
