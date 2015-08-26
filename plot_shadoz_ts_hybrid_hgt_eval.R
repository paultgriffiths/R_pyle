# R Script to plot model vs SHADOZ data 
# in a similar style to that shown in the
# MACC ECMWF analysis (i.e. bias as a 
# function of z and time)

# Here we use data that has been re-grided on to 
# model hybrid_ht (AT L60!!)

# Alex Archibald, June 2012

# constants and vars
conv <- 1E9

# extract variables
lon <- get.var.ncdf(nc1, "longitude")
lat <- get.var.ncdf(nc1, "latitude")
lev <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
time <- get.var.ncdf(nc1, "t")
o3  <- get.var.ncdf(nc1, o3.code)*(conv/mm.o3)

# source the station info and the saved pres-interplated 
# monthly mean aggregated observations
station.info <- read.csv(paste(obs.dir, "shadoz/station.names", sep=""))
ascen <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/ascen_hgt.dat", sep=""))))*1E3
cotonou <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/cotonou_hgt.dat", sep=""))))*1E3
fiji <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/fiji_hgt.dat", sep=""))))*1E3
java <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/java_hgt.dat", sep=""))))*1E3
kuala <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/kuala_hgt.dat", sep=""))))*1E3
natal <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/natal_hgt.dat", sep=""))))*1E3
reunion <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/reunion_hgt.dat", sep=""))))*1E3
samoa <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/samoa_hgt.dat", sep=""))))*1E3
sancr <- t(data.matrix(read.csv(paste(obs.dir, "shadoz/sancr_hgt.dat", sep=""))))*1E3


# extract data from model
for (i in 1:length(station.info$name) ) {
first.lat <- station.info$Lat[i]
first.lon <- station.info$Lon[i]
location  <- trim(as.character(station.info$name[i]))
source("get_model_shadoz.R")
}


# set labels for the x axis
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

# calculate the absolute difference (ppbv)
ascen.diff <- (ascen.mod[,1:25]-((ascen[,1:25])))
cotonou.diff <- (cotonou.mod[,1:25]-((cotonou[,1:25])))
fiji.diff <- (fiji.mod[,1:25]-((fiji[,1:25])))
java.diff <- (java.mod[,1:25]-((java[,1:25])))
kuala.diff <- (kuala.mod[,1:25]-((kuala[,1:25])))
natal.diff <- (natal.mod[,1:25]-((natal[,1:25])))
reunion.diff <- (reunion.mod[,1:25]-((reunion[,1:25])))
samoa.diff <- (samoa.mod[,1:25]-((samoa[,1:25])))
sancr.diff <- (sancr.mod[,1:25]-((sancr[,1:25])))

# calculate the relative difference: mod-obs/obs
ascen.rdiff <- 100*((ascen.mod[,1:25]-((ascen[,1:25])))/((ascen[,1:25])))
cotonou.rdiff <- 100*((cotonou.mod[,1:25]-((cotonou[,1:25])))/((cotonou[,1:25])))
fiji.rdiff <- 100*((fiji.mod[,1:25]-((fiji[,1:25])))/((fiji[,1:25])))
java.rdiff <- 100*((java.mod[,1:25]-((java[,1:25])))/((java[,1:25])))
kuala.rdiff <- 100*((kuala.mod[,1:25]-((kuala[,1:25])))/((kuala[,1:25])))
natal.rdiff <- 100*((natal.mod[,1:25]-((natal[,1:25])))/((natal[,1:25])))
reunion.rdiff <- 100*((reunion.mod[,1:25]-((reunion[,1:25])))/((reunion[,1:25])))
samoa.rdiff <- 100*((samoa.mod[,1:25]-((samoa[,1:25])))/((samoa[,1:25])))
sancr.rdiff <- 100*((sancr.mod[,1:25]-((sancr[,1:25])))/((sancr[,1:25])))

# set max and min
#ascen.diff[ascen.diff>100] <- 100
#ascen.diff[ascen.diff<-100] <- -100
#cotonou.diff[cotonou.diff>100] <- 100
#cotonou.diff[cotonou.diff<-100] <- -100
#fiji.diff[fiji.diff>100] <- 100
#fiji.diff[fiji.diff<-100] <- -100
#java.diff[java.diff>100] <- 100
#java.diff[java.diff<-100] <- -100
#kuala.diff[kuala.diff>100] <- 100
#kuala.diff[kuala.diff<-100] <- -100
#natal.diff[natal.diff>100] <- 100
#natal.diff[natal.diff<-100] <- -100
#reunion.diff[reunion.diff>100] <- 100
#reunion.diff[reunion.diff<-100] <- -100
#samoa.diff[samoa.diff>100] <- 100
#samoa.diff[samoa.diff<-100] <- -100
#sancr.diff[sancr.diff>100] <- 100
#sancr.diff[sancr.diff<-100] <- -100

# plot params
plot.breaks <- seq(-60,60,10)

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_shadoz_o3_bias_ts.pdf", sep=""),width=21,height=32,paper="special",onefile=TRUE,pointsize=32)

#  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
#       omi=c(0,0,0.3,2.5), # global margins in inches (bottom, left, top, right)
#       mai=c(0.7,1.5,0.5,0.6)) # subplot margins in inches (bottom, left, top, right)
#  layout(matrix(1:9, 3, 3, byrow = TRUE))

par(mfrow=c(3,3))
par(oma=c(0,0,1,0)) 
par(mgp = c(2, 0.6, 0))
par(mar=c(5,4,4,4))
par(omi=c(0,0,0.3,2))

# overplot the data 
image(1:12, lev[1:25], ascen.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Ascension bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(ascen.mod-(ascen*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
par(xpd=F)

image(1:12, lev[1:25], cotonou.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Cotonou bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(cotonou.mod-(cotonou*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
par(xpd=F)


image(1:12, lev[1:25], fiji.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Fiji bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(fiji.mod-(fiji*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
text(12,13.5, expression(paste(Delta,"O"[3], (ppbv), sep=" ") ) )
color.legend(17,0,21,13,legend=plot.breaks, rect.col=ecmwf.cols(13), gradient="y")
par(xpd=F)

image(1:12, lev[1:25], java.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Java bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(java.mod-(java*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
par(xpd=F)

image(1:12, lev[1:25], kuala.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Kuala bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(kuala.mod-(kuala*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
par(xpd=F)

image(1:12, lev[1:25], natal.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Natal bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(natal.mod-(natal*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
text(12,13.5, expression(paste(Delta,"O"[3], (ppbv), sep=" ") ) )
color.legend(17,0,21,13,legend=plot.breaks, rect.col=ecmwf.cols(13), gradient="y")
par(xpd=F)

image(1:12, lev[1:25], reunion.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Reunion bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(reunion.mod-(reunion*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
par(xpd=F)

image(1:12, lev[1:25], samoa.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("Samoa bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(samoa.mod-(samoa*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
par(xpd=F)


image(1:12, lev[1:25], sancr.diff[,1:25], ylab="Altitude (km)", xlab="Month", main=paste("SanCristobal bias",mod1.name,sep=" "), zlim=c(-60,60), col=ecmwf.cols(13), xaxt="n")
axis(side=1, 1:12, labels=monthNames, tick=TRUE)
grid()

par(xpd=T)
# text(7,56, paste("Max bias =", sprintf("%1.3g", max(sancr.mod-(sancr*1E3)) ), "ppb", sep=" "), cex=1.0, col="black")
text(12,13.5, expression(paste(Delta,"O"[3], (ppbv), sep=" ") ) )
color.legend(17,0,21,13,legend=plot.breaks, rect.col=ecmwf.cols(13), gradient="y")
par(xpd=F)



dev.off()
