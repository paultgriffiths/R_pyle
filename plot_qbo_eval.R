# R Script to plot model zonal winds
# for QBO analysis

# Alex Archibald, June 2012

# constants and vars
conv <- 1E9

# enter name of model run and some info for legends 
mod1.name <- "xgywk"

# give locations of netcdf files for input
nc1 <- open.ncdf(paste("/data/ata27/",mod1.name,"/",mod1.name,"_winds.nc", sep=""), readunlim=FALSE) 

# set the working directory for output (default to directory of this script)
out.dir <- paste("/data/ata27/",mod1.name,"/",sep="")

lat <- get.var.ncdf(nc1, "latitude")
lon <- get.var.ncdf(nc1, "longitude")
ht  <- get.var.ncdf(nc1, "p")
time<- get.var.ncdf(nc1, "t")

first.lat <- tail(which(lat<=-2),1)
last.lat  <- which(lat>=2)[1]
d.lat     <- last.lat - first.lat 

winds <- get.var.ncdf(nc1, "u", start=c(1,first.lat,1,1), count=c(length(lon),d.lat,17,length(time)) )
wind.m <- apply(winds, c(4,3), mean)

axis.x <-  seq(as.POSIXct("2000-01-01 00:00:00 UTC"), by = "3 mon", length=length(time)/3.0 )

log.z <-  132.18199999999999 - 44.061 * log10(ht)     # This transfrmation was taken from the
                     				   # skewty.R function from the ozone sonde package

# plotting colors
col.cols = colorRampPalette(c("purple", "pink", "blue","lightblue", "green", "yellow", "orange", "red"))

# ###################################################################################################################################
# plot data
pdf(file=paste(out.dir, mod1.name, "_qbo.pdf", sep=""),width=8,height=5,paper="special",onefile=TRUE,pointsize=10)

# overplot the data 
filled.contour(1:length(time), log.z[11:17], wind.m[,11:17], xaxt="n", yaxt="n",
color = col.cols, zlim=c(-70,20),
ylab="Altitude (hPa)", xlab="Date",
plot.title=title(main=paste(mod1.name, " zonal mean zonal eq. u", sep="") ),
key.title = title(main="m/s"),
plot.axes= {
    axis(side=1, seq(1,length(time),3), labels=axis.x, tick=TRUE)
    axis(side=2, log.z, labels=sprintf("%1g", ht),tick=TRUE)
    abline(v=seq(from=1, to=length(time), by=12), lty=2, lwd=2, col="gray") # add annual strips
    })

dev.off()
