# R Script to plot model surface O3 range (max - min)
# compared to obs

# Alex Archibald, September 2013

# extract/define variables
source((paste(script.dir, "get_model_dims.R", sep=""))
hgt    hgt*1E-3
conv   <- 1E9 # ppb conversion

# read in the surface O3 obs
in.dir <- paste(obs.dir, "CMDL/srfo3/o3/monthly", sep="")

# set the option to extract data: 
# option 1 = seasonal cycle
# option 2 = (multi) annual mean
# option 3 = range (max - min) of (mean) monthly mean 
option <- 3
source(paste(script.dir, "get_gaw_surface_o3.R", sep=""))

# Subset the locations to remove high altitude sites
srf.o3 <- subset(srf.o3, alt < 1500.)

# ###################################################################################################################################
# set axis'
axis_y <- seq(-90,90,15)
axis_x <- seq(-180,180,45)

midlon <- which(lon>=180.0)[1]
maxlon <- length(lon)
dellon <- lon[2]-lon[1]
lon2   <- seq(-180,(180-dellon), dellon)

# calc the range (max - min) of srf o3 values
o3.srf.max <- apply( (get.var.ncdf(nc1, o3.code)*conv/mm.o3)[,,1,], c(1,2), max)
o3.srf.min <- apply( (get.var.ncdf(nc1, o3.code)*conv/mm.o3)[,,1,], c(1,2), min)
o3.srf.range <- o3.srf.max - o3.srf.min

o3.srf <- abind(o3.srf.range[midlon:maxlon,], o3.srf.range[1:midlon-1,], along=1)

# set plotting params
breaks <- c(0,0.5,1,1.5,2,2.5,3,4,8,12,16,20,24,28,32,36,50,60)
breaks2 <- c(0,1,8,16,32,50)
cols <- o3.col.cols(length(breaks-1) )

# calculate the MBE between obs and model
mod.mbe <- NULL
for (i in 1:nrow(srf.o3)){
  mod.lon <- find.lon(srf.o3$lon[i])
  mod.lat <- find.lat(srf.o3$lat[i])
  mod.mbe[i] <- mbe(o3.srf[mod.lon, mod.lat], srf.o3$O3.range[i])  
}
# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_Ozone_Surface_range.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
par(mar=c(4,4,3,5))
filled.contour3(lon2, lat, o3.srf, ylab="Latitude (degrees)", xlab="Longtitude (degrees)", 
               main=paste("Surface Ozone (max-min)",mod1.name,sep=" "),  
               col=cols,
               levels=breaks,
key.title = title("(ppb)"),
plot.axes= {
contour(lon2, lat, o3.srf, add=T, lty=1, lwd=0.7, drawlabels= TRUE, 
        levels=breaks2, cex=0.5)
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, axis_y, labels=TRUE, tick=TRUE)
map("world", add=T)
# add points to map
col.idx <- NULL
for(i in 1:nrow(srf.o3)) {
  col.idx[i] <- getColor(srf.o3$O3.range[i], cols, breaks)
  points(srf.o3$lon[i], srf.o3$lat[i], cex=1.2, pch=21, col="black", bg=col.idx[i])
}
grid() } )
par(xpd=T)
text(-60,95, paste("Min =",sprintf("%1.3g", min(o3.srf) ), " Mean =", sprintf("%1.3g", mean(o3.srf) ), 
                   " Max =", sprintf("%1.3g", max(o3.srf) ), " MBE =", sprintf("%1.3g", mean(mod.mbe, na.rm=T)), "%", sep=" ") )
text((195+((215-195)/2)), 95, "(ppb)")
par(xpd=F)

par(xpd=NA)
color.legend(195,-90,215,90,
             legend=breaks, rect.col=cols, gradient="y", align="rt")
par(xpd=F)


dev.off()

# ###################################################################################################################################
