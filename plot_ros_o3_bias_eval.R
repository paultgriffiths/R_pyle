# R script to plot the difference between the model
# ozone filed and the radiation climatology

# Alex Archibald, CAS, July 2012

# define path to the climatology
nc0 <- open.ncdf(paste(obs.dir, "Rosenlof/ros_o3_clim.nc", sep=""))

# extract vars
lon    <- get.var.ncdf(nc1, "longitude")
lat    <- get.var.ncdf(nc1, "latitude")
hgt    <- get.var.ncdf(nc1, "hybrid_ht")*1E-3 # km
time   <- get.var.ncdf(nc1, "t")

ros    <- apply(get.var.ncdf(nc0, "O3"), c(1,2), mean)
ukca   <- apply(get.var.ncdf(nc1,  o3.code), c(2,3), mean)
ht     <- get.var.ncdf(nc1, trop.hgt.code)
ht     <- apply(ht, c(2), mean)*1E-3 # km

# calculate the % change relative to the climatology
diff <- 100.0*( (ukca-ros) / ros)

# set limits for plotting
diff2 <- diff
diff2[diff2>100.0] <- 100.0
diff2[diff2<-100.0] <- -100.0

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_O3_Bias_Rosenlof.pdf", sep=""),width=6,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
image.plot(lat, hgt, diff2, zlim=c(-100,100), ylim=c(0,60), xlab="Latitude (degrees)", 
ylab="Altitude (km)", col=heat.cols(23), main=paste("% difference:",mod1.name, "to Rosenlof",sep=" "), horizontal=TRUE )
lines(lat, ht, lwd=2, lty=2)
par(xpd=T)
text(-45,61.5, paste("Min =",sprintf("%1.3g", min(diff[,1:60]) ), "Mean =", sprintf("%1.3g", mean(diff[,1:60]) ), "Max =", sprintf("%1.3g", max(diff[,1:60]) ), sep=" ") )
par(xpd=F)

dev.off()
