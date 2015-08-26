# R Script to plot model vs SHADOZ data 
# in a similar style to that shown in the
# MACC ECMWF analysis (i.e. bias as a 
# function of z and time)

# Alex Archibald, June 2012

# constants and vars
conv <- 1E9

# import the saved pressure interpolated model o3 data
nc0 <- open.ncdf(paste(paste(obs.dir, "", mod1.name, "/", mod1.name, "_pres_interp_ozone.nc",sep=""))

lon <- get.var.ncdf(nc0, "longitude")
lat <- get.var.ncdf(nc0, "latitude")
lev <- get.var.ncdf(nc0, "pressure")
time <- get.var.ncdf(nc0, "time")

# source the station info and the saved pres-interplated 
# monthly mean aggregated observations
station.info <- read.csv(paste(obs.dir, "shadoz/station.names", sep=""))
ascen <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/ascen.dat", sep=""))))
cotonou <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/cotonou.dat", sep=""))))
fiji <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/fiji.dat", sep=""))))
java <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/java.dat", sep=""))))
kuala <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/kuala.dat", sep=""))))
natal <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/natal.dat", sep=""))))
reunion <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/reunion.dat", sep=""))))
reunion[reunion>1E2] <- NA
samoa <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/samoa.dat", sep=""))))
sancr <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/sancr.dat", sep=""))))
heredia <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/heredia.dat", sep=""))))
hilo <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/hilo.dat", sep=""))))
malindi <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/malindi.dat", sep=""))))
nairobi <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/nairobi.dat", sep=""))))
irene <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/irene.dat", sep=""))))

# extract data from model
# convert the obs lon array to work -180,180 to 0-360
station.info$Lon <- ifelse(station.info$Lon < 0, station.info$Lon+360, station.info$Lon)
for (i in 1:length(station.info$name) ) {
first.lat <- station.info$Lat[i]
first.lon <- station.info$Lon[i]
location  <- trim(as.character(station.info$name[i]))
source("get_model_shadoz.R")
}

# create a nice log scale for the y axis.
# This transfrmation was taken from the skewty.R function from the ozone sonde package
log.z <-  132.18199999999999 - 44.061 * log10(lev)

monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")
# the y axis labels get a bit crowded so here is a cut down set:
y.labs <- c(900,800,700,500,250,125)

# calculate the absolute difference (ppbv)
# NOTE that the obs run from 900-10hPa and the model from 1000-10hPa (skip the first 
# few rows of the model)
ascen.diff   <- ascen.mod[,5:32]-(ascen*1E3)
cotonou.diff <- cotonou.mod[,5:32]-(cotonou*1E3)
fiji.diff    <- fiji.mod[,5:32]-(fiji*1E3)
java.diff    <- java.mod[,5:32]-(java*1E3)
kuala.diff   <- kuala.mod[,5:32]-(kuala*1E3)
natal.diff   <- natal.mod[,5:32]-(natal*1E3)
reunion.diff <- reunion.mod[,5:32]-(reunion*1E3)
samoa.diff   <- samoa.mod[,5:32]-(samoa*1E3)
sancr.diff   <- sancr.mod[,5:32]-(sancr*1E3)
heredia.diff <- heredia.mod[,5:32]-(heredia*1E3)
hilo.diff    <- hilo.mod[,5:32]-(hilo*1E3)
malindi.diff <- malindi.mod[,5:32]-(malindi*1E3)
nairobi.diff <- nairobi.mod[,5:32]-(nairobi*1E3)
irene.diff   <- irene.mod[,5:32]-(irene*1E3)

# plot params
plot.breaks <- seq(-60,60,20)

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_shadoz_o3_bias_ts.pdf", sep=""),width=6,height=10,paper="special",onefile=TRUE,pointsize=10)

par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
     omi=c(0.3,0.3,0.3,0.2), # global margins in inches (bottom, left, top, right)
     mai=c(0.05,0.05,0.01,0.1)) # subplot margins in inches (bottom, left, top, right)
layout(matrix(1:15, 5, 3, byrow = TRUE))


plot(1:10, xaxt="n", yaxt="n", xlab="", ylab="", col="white", axes=FALSE)
#map("world", add=T, col="gray", fill=T)
par(xpd=NA)
color.legend(8,1,9,10,legend=plot.breaks, rect.col=ecmwf.cols(12), gradient="y", align="lt")
mtext(paste(mod1.name, "SHADOZ comparison", sep=" "), outer = TRUE )
par(xpd=F)

# overplot the data 
image(1:12, log.z[5:26], hilo.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE, las=2)
grid()

par(xpd=NA)
legend("bottomleft", c("Hilo [1/98-12/09]", paste("Mean bias =", sprintf("%1.3g", mean(hilo.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2 )
par(xpd=F)

image(1:12, log.z[5:26], kuala.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE, las=2)
grid()

par(xpd=T)
legend("bottomleft", c("Kuala Lumpur [1/98-12/09]", paste("Mean bias =", sprintf("%1.3g", mean(kuala.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], heredia.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE, las=2)
grid()

par(xpd=T)
legend("bottomleft", c("Heredia [7/05-12/11]", paste("Mean bias =", sprintf("%1.3g", mean(heredia.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], nairobi.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Nairobi [1/98-11/9]", paste("Mean bias =", sprintf("%1.3g", mean(nairobi.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], java.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Java [1/98-11/09]", paste("Mean bias =", sprintf("%1.3g", mean(java.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], sancr.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE, las=2)
grid()

par(xpd=T)
legend("bottomleft", c("San Cristobal [1/98-10/08]", paste("Mean bias =", sprintf("%1.3g", mean(sancr.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], malindi.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Malinidi [3/99-1/06]", paste("Mean bias =", sprintf("%1.3g", mean(malindi.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], reunion.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Reunion [1/98-12/09]", paste("Mean bias =", sprintf("%1.3g", mean(reunion.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], samoa.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE, las=2)
grid()

par(xpd=T)
legend("bottomleft", c("Samoa [1/98-12/09]", paste("Mean bias =", sprintf("%1.3g", mean(samoa.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], natal.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Natal [1/98-12/09]", paste("Mean bias =", sprintf("%1.3g", mean(natal.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], irene.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
#axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Irene [1/98-2/08]", paste("Mean bias =", sprintf("%1.3g", mean(irene.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], fiji.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE, las=2)
grid()

par(xpd=T)
legend("bottomleft", c("Fiji [1/98-7/08]", paste("Mean bias =", sprintf("%1.3g", mean(fiji.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

image(1:12, log.z[5:26], cotonou.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Cotonou [1/05-1/07]", paste("Mean bias =", sprintf("%1.3g", mean(cotonou.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)


image(1:12, log.z[5:26], ascen.diff[,1:22], ylab="Altitude (hPa)", xlab="", zlim=c(-60,60), col=ecmwf.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
#axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
legend("bottomleft", c("Ascension [1/98-12/09]", paste("Mean bias =", sprintf("%1.3g", mean(ascen.diff[,1:22], na.rm=T )), "ppbv", sep=" ")), bty="n", cex=1.2)
par(xpd=F)

dev.off()

# ###################################################################################################################################
plot.breaks <- seq(0,120,20)

pdf(file=paste(out.dir,mod1.name,"_shadoz_o3_ts.pdf", sep=""),width=9,height=6,paper="special",onefile=TRUE,pointsize=10)

par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
     omi=c(0.3,0.3,0.3,0.5), # global margins in inches (bottom, left, top, right)
     mai=c(0.3,0.3,0.5,0.1)) # subplot margins in inches (bottom, left, top, right)
layout(matrix(1:15, 3, 5, byrow = TRUE))


# overplot the data 
image(1:12, log.z[5:26], ascen.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Ascension",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(ascen.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], kuala.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Kuala",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(kuala.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], heredia.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Heredia",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(heredia.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], java.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Java",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(java.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], sancr.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("SanCristobal",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(sancr.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], cotonou.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Cotonou",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(cotonou.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)


image(1:12, log.z[5:26], fiji.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Fiji",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(fiji.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)


image(1:12, log.z[5:26], natal.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Natal",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(natal.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], nairobi.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Nairobi",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(nairobi.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], hilo.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Hilo",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(hilo.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], reunion.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Reunion",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(reunion.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], samoa.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Samoa",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(samoa.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], malindi.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Malindi",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(malindi.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

image(1:12, log.z[5:26], irene.mod[,5:26], ylab="Altitude (hPa)", xlab="Month", main=paste("Irene",mod1.name,sep=" "), zlim=c(0,120), col=col.cols(12), xaxt="n", yaxt="n" )
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
axis(side=2, log.z[5:26], labels=FALSE, tick=TRUE, tck=0.03)
axis(side=2, log.z[c(5,9,12,16,21,26)],   labels=sprintf("%1g", y.labs), tick=TRUE)
grid()

par(xpd=T)
text(7,43, paste("Mean =", sprintf("%1.3g", mean(irene.mod[,5:26], na.rm=T ), "ppbv", sep=" ")), cex=1.0, col="black")
par(xpd=F)

plot(1:10, xaxt="n", yaxt="n", xlab="", ylab="", col="white", axes=FALSE)
par(xpd=NA)
color.legend(1,1,3,10,legend=plot.breaks, rect.col=col.cols(12), gradient="y", align="rb")
par(xpd=F)

dev.off()

