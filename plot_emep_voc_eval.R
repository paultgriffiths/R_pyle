# R script to compare observed VOC mixing ratios
# with model values. Obs are from the EMEP network
# and are in pptv.

# Alex Archibald, Cambridge, Oct 2012

# source scripts to read in list of EMEP station locations
source(paste(obs.dir, "EMEP/read_stations.R", sep=""))

# open the obs
emep.hc <- read.table(paste(obs.dir, "EMEP/data/voc_hc_mon.dat", sep=""), header=F, na.strings="-9999.990")
names(emep.hc) <- c("code", "species", "method", "year", "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")

emep.voc<- read.table(paste(obs.dir, "EMEP/data/voc_cn_mon.dat", sep=""), header=F, na.strings="-9999.990")
names(emep.voc) <-c("code", "species", "method", "year", "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec") 

# loop vars and constants
conv <- 1E9
mol.air <- 22.414E-3 # m3 mole-1
j <- NULL ; i <- NULL ; k <- NULL
lat.n <- 70; lat.c <- 50; lat.s <- 30

# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")
times <- c(1,2,3,4,5,6,7,8,9,10,11,12)

# merge the 133 stations
hc.data <- merge(stations, emep.hc, by="code")
voc.data<- merge(stations, emep.voc, by="code")

# ########################################################################################
# subset the data for individual species  
data     <- hc.data[hc.data$species%in%"ethane",]
voc.code <- ethane.code
voc.mm   <- mm.c2h6
cal.fac  <- 1000.0 # convert pptv to ppbv

# source script to extract data
source("get_emep_voc.R")

# set output data
ethane.obs.n <- n.data.months
ethane.obs.c <- c.data.months
ethane.obs.sd.n <- n.sd.data.months
ethane.obs.sd.c <- c.sd.data.months

ethane.mod.n <- n.mod.months
ethane.mod.c <- c.mod.months
ethane.mod.sd.n <- n.sd.mod.months
ethane.mod.sd.c <- c.sd.mod.months

ethane.cor.r.n <- cor.r.n
ethane.cor.r.c <- cor.r.c
ethane.MBE.n <- MBE.n
ethane.MBE.c <- MBE.c

# ########################################################################################
# subset the data for individual species  
data     <- hc.data[hc.data$species%in%"propane",]
voc.code <- propane.code
voc.mm   <- mm.c2h6
cal.fac  <- 1000.0 # convert pptv to ppbv

# source script to extract data
source(paste(script.dir, "get_emep_voc.R"), sep="")

# set output data
propane.obs.n <- n.data.months
propane.obs.c <- c.data.months
propane.obs.sd.n <- n.sd.data.months
propane.obs.sd.c <- c.sd.data.months

propane.mod.n <- n.mod.months
propane.mod.c <- c.mod.months
propane.mod.sd.n <- n.sd.mod.months
propane.mod.sd.c <- c.sd.mod.months

propane.cor.r.n <- cor.r.n
propane.cor.r.c <- cor.r.c
propane.MBE.n <- MBE.n
propane.MBE.c <- MBE.c

# ########################################################################################
# subset the data for individual species  
data     <- hc.data[hc.data$species%in%"isoprene",]
voc.code <- isoprene.code
voc.mm   <- mm.c5h8
cal.fac  <- 1000.0 # convert pptv to ppbv

# source script to extract data
source(paste(script.dir, "get_emep_voc.R"), sep="")

# set output data
isoprene.obs.n <- n.data.months
isoprene.obs.c <- c.data.months
isoprene.obs.sd.n <- n.sd.data.months
isoprene.obs.sd.c <- c.sd.data.months

isoprene.mod.n <- n.mod.months
isoprene.mod.c <- c.mod.months
isoprene.mod.sd.n <- n.sd.mod.months
isoprene.mod.sd.c <- c.sd.mod.months

isoprene.cor.r.n <- cor.r.n
isoprene.cor.r.c <- cor.r.c
isoprene.MBE.n <- MBE.n
isoprene.MBE.c <- MBE.c

# ########################################################################################
# subset the data for individual species  
data     <- voc.data[voc.data$species%in%"methanal",]
voc.code <- hcho.code
voc.mm   <- mm.hcho
cal.fac  <- (1/conv)*(30.0E6/mol.air) # convert ug/m3 to ppbv

# source script to extract data
source(paste(script.dir, "get_emep_voc.R"), sep="")

# set output data
hcho.obs.n <- n.data.months
hcho.obs.c <- c.data.months
hcho.obs.sd.n <- n.sd.data.months
hcho.obs.sd.c <- c.sd.data.months

hcho.mod.n <- n.mod.months
hcho.mod.c <- c.mod.months
hcho.mod.sd.n <- n.sd.mod.months
hcho.mod.sd.c <- c.sd.mod.months

hcho.cor.r.n <- cor.r.n
hcho.cor.r.c <- cor.r.c
hcho.MBE.n <- MBE.n
hcho.MBE.c <- MBE.c

# ########################################################################################
# subset the data for individual species  
data     <- voc.data[voc.data$species%in%"ethanal",]
voc.code <- mecho.code
voc.mm   <- mm.mecho
cal.fac  <- (1/conv)*(44E6/mol.air) # convert ug/m3 to ppbv

# source script to extract data
source(paste(script.dir, "get_emep_voc.R"), sep="")

# set output data
mecho.obs.n <- n.data.months
mecho.obs.c <- c.data.months
mecho.obs.sd.n <- n.sd.data.months
mecho.obs.sd.c <- c.sd.data.months

mecho.mod.n <- n.mod.months
mecho.mod.c <- c.mod.months
mecho.mod.sd.n <- n.sd.mod.months
mecho.mod.sd.c <- c.sd.mod.months

mecho.cor.r.n <- cor.r.n
mecho.cor.r.c <- cor.r.c
mecho.MBE.n <- MBE.n
mecho.MBE.c <- MBE.c

# ########################################################################################
# subset the data for individual species  
data     <- voc.data[voc.data$species%in%"propanone",]
voc.code <- acetone.code
voc.mm   <- mm.me2co
cal.fac  <- (1/conv)*(58E6/mol.air) # convert ug/m3 to ppbv

# source script to extract data
source(paste(script.dir, "get_emep_voc.R"), sep="")

# set output data
me2co.obs.n <- n.data.months
me2co.obs.c <- c.data.months
me2co.obs.sd.n <- n.sd.data.months
me2co.obs.sd.c <- c.sd.data.months

me2co.mod.n <- n.mod.months
me2co.mod.c <- c.mod.months
me2co.mod.sd.n <- n.sd.mod.months
me2co.mod.sd.c <- c.sd.mod.months

me2co.cor.r.n <- cor.r.n
me2co.cor.r.c <- cor.r.c
me2co.MBE.n <- MBE.n
me2co.MBE.c <- MBE.c

# ###############################################################################################
pdf(file=paste(out.dir, mod1.name, "_EMEP_VOC_comparison.pdf", sep=""),width=8,height=7,paper="special",
onefile=TRUE,pointsize=14)

#  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
#       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
#       mai=c(0.4,0.6,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
#  layout(matrix(1:6, 6, 2, byrow = TRUE))

par(mfrow=c(2,2))

plot(ethane.obs.n,col="Black",xlab="", lwd=4, ylab="Ethane (ppbv)",type="o",ylim=c(0,4), xaxt="n", main="North Europe (50-70N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((ethane.obs.n)-(ethane.obs.sd.n)),  1:12, ((ethane.obs.n)+(ethane.obs.sd.n)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,ethane.mod.n,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((ethane.mod.n)-(ethane.mod.sd.n)),  1:12, ((ethane.mod.n)+(ethane.mod.sd.n)), length = 0.0, code =2, col="red" )
legend("topleft",c("EMEP (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 8"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", ethane.cor.r.n)," MBE = ", sprintf("%1.3g", ethane.MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (ethane.mod.n - (ethane.obs.n)), col="red", names.arg=monthNames, las=1, ylim=c(-0.5,2.0), xlab="", ylab=expression( paste(Delta, " Ethane (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(ethane.obs.c,col="Black",xlab="", lwd=4, ylab="Ethane (ppbv)",type="o",ylim=c(0,4), xaxt="n", main="Central Europe (30-50N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((ethane.obs.c)-(ethane.obs.sd.c)),  1:12, ((ethane.obs.c)+(ethane.obs.sd.c)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,ethane.mod.c,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((ethane.mod.c)-(ethane.mod.sd.c)),  1:12, ((ethane.mod.c)+(ethane.mod.sd.c)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 10"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", ethane.cor.r.c)," MBE = ", sprintf("%1.3g", ethane.MBE.c), "%", sep="")), cex=0.9)
grid()

barplot( (ethane.mod.c - (ethane.obs.c)), col="red", names.arg=monthNames, las=1, ylim=c(-0.5,2.0), xlab="", ylab=expression( paste(Delta, " Ethane (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(propane.obs.n,col="Black",xlab="", lwd=4, ylab="Propane (ppbv)",type="o",ylim=c(0,1.5), xaxt="n", main="North Europe (50-70N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((propane.obs.n)-(propane.obs.sd.n)),  1:12, ((propane.obs.n)+(propane.obs.sd.n)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,propane.mod.n,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((propane.mod.n)-(propane.mod.sd.n)),  1:12, ((propane.mod.n)+(propane.mod.sd.n)), length = 0.0, code =2, col="red" )
legend("topleft",c("EMEP (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 8"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", propane.cor.r.n)," MBE = ", sprintf("%1.3g", propane.MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (propane.mod.n - (propane.obs.n)), col="red", names.arg=monthNames, las=1, ylim=c(-0.6,0.6), xlab="", ylab=expression( paste(Delta, " Propane (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(propane.obs.c,col="Black",xlab="", lwd=4, ylab="Propane (ppbv)",type="o",ylim=c(0,1.5), xaxt="n", main="Central Europe (30-50N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((propane.obs.c)-(propane.obs.sd.c)),  1:12, ((propane.obs.c)+(propane.obs.sd.c)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,propane.mod.c,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((propane.mod.c)-(propane.mod.sd.c)),  1:12, ((propane.mod.c)+(propane.mod.sd.c)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 10"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", propane.cor.r.c)," MBE = ", sprintf("%1.3g", propane.MBE.c), "%", sep="")), cex=0.9)
grid()

barplot( (propane.mod.c - (propane.obs.c)), col="red", names.arg=monthNames, las=1, ylim=c(-0.6,0.6), xlab="", ylab=expression( paste(Delta, " Propane (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(isoprene.obs.n,col="Black",xlab="", lwd=4, ylab="Isoprene (ppbv)",type="o",ylim=c(0,1), xaxt="n", main="North Europe (50-70N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((isoprene.obs.n)-(isoprene.obs.sd.n)),  1:12, ((isoprene.obs.n)+(isoprene.obs.sd.n)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,isoprene.mod.n,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((isoprene.mod.n)-(isoprene.mod.sd.n)),  1:12, ((isoprene.mod.n)+(isoprene.mod.sd.n)), length = 0.0, code =2, col="red" )
legend("topleft",c("EMEP (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 8"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", isoprene.cor.r.n)," MBE = ", sprintf("%1.3g", isoprene.MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (isoprene.mod.n - (isoprene.obs.n)), col="red", names.arg=monthNames, las=1, ylim=c(-0.5,0.5), xlab="", ylab=expression( paste(Delta, " Isoprene (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(isoprene.obs.c,col="Black",xlab="", lwd=4, ylab="Isoprene (ppbv)",type="o",ylim=c(0,1.0), xaxt="n", main="Central Europe (30-50N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((isoprene.obs.c)-(isoprene.obs.sd.c)),  1:12, ((isoprene.obs.c)+(isoprene.obs.sd.c)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,isoprene.mod.c,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((isoprene.mod.c)-(isoprene.mod.sd.c)),  1:12, ((isoprene.mod.c)+(isoprene.mod.sd.c)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 10"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", isoprene.cor.r.c)," MBE = ", sprintf("%1.3g", isoprene.MBE.c), "%", sep="")), cex=0.9)
grid()

barplot( (isoprene.mod.c - (isoprene.obs.c)), col="red", names.arg=monthNames, las=1, ylim=c(-0.2,0.2), xlab="", ylab=expression( paste(Delta, " Isoprene (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(hcho.obs.n,col="Black",xlab="", lwd=4, ylab="HCHO (ppbv)",type="o",ylim=c(0,2.0), xaxt="n", main="North Europe (50-70N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((hcho.obs.n)-(hcho.obs.sd.n)),  1:12, ((hcho.obs.n)+(hcho.obs.sd.n)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,hcho.mod.n,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((hcho.mod.n)-(hcho.mod.sd.n)),  1:12, ((hcho.mod.n)+(hcho.mod.sd.n)), length = 0.0, code =2, col="red" )
legend("topleft",c("EMEP (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 8"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", hcho.cor.r.n)," MBE = ", sprintf("%1.3g", hcho.MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (hcho.mod.n - (hcho.obs.n)), col="red", names.arg=monthNames, las=1, ylim=c(-0.8,0.8), xlab="", ylab=expression( paste(Delta, " HCHO (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(hcho.obs.c,col="Black",xlab="", lwd=4, ylab="HCHO (ppbv)",type="o",ylim=c(0,2.0), xaxt="n", main="Central Europe (30-50N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((hcho.obs.c)-(hcho.obs.sd.c)),  1:12, ((hcho.obs.c)+(hcho.obs.sd.c)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,hcho.mod.c,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((hcho.mod.c)-(hcho.mod.sd.c)),  1:12, ((hcho.mod.c)+(hcho.mod.sd.c)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 10"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", hcho.cor.r.c)," MBE = ", sprintf("%1.3g", hcho.MBE.c), "%", sep="")), cex=0.9)
grid()

barplot( (hcho.mod.c - (hcho.obs.c)), col="red", names.arg=monthNames, las=1, ylim=c(-0.8,0.8), xlab="", ylab=expression( paste(Delta, " HCHO (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(mecho.obs.n,col="Black",xlab="", lwd=4, ylab="MeCHO (ppbv)",type="o",ylim=c(0,1.0), xaxt="n", main="North Europe (50-70N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((mecho.obs.n)-(mecho.obs.sd.n)),  1:12, ((mecho.obs.n)+(mecho.obs.sd.n)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,mecho.mod.n,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((mecho.mod.n)-(mecho.mod.sd.n)),  1:12, ((mecho.mod.n)+(mecho.mod.sd.n)), length = 0.0, code =2, col="red" )
legend("topleft",c("EMEP (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 8"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", mecho.cor.r.n)," MBE = ", sprintf("%1.3g", mecho.MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (mecho.mod.n - (mecho.obs.n)), col="red", names.arg=monthNames, las=1, ylim=c(-0.5,0.5), xlab="", ylab=expression( paste(Delta, " MeCHO (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(mecho.obs.c,col="Black",xlab="", lwd=4, ylab="MeCHO (ppbv)",type="o",ylim=c(0,1.0), xaxt="n", main="Central Europe (30-50N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((mecho.obs.c)-(mecho.obs.sd.c)),  1:12, ((mecho.obs.c)+(mecho.obs.sd.c)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,mecho.mod.c,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((mecho.mod.c)-(mecho.mod.sd.c)),  1:12, ((mecho.mod.c)+(mecho.mod.sd.c)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 10"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", mecho.cor.r.c)," MBE = ", sprintf("%1.3g", mecho.MBE.c), "%", sep="")), cex=0.9)
grid()

barplot( (mecho.mod.c - (mecho.obs.c)), col="red", names.arg=monthNames, las=1, ylim=c(-0.5,0.5), xlab="", ylab=expression( paste(Delta, " MeCHO (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(me2co.obs.n,col="Black",xlab="", lwd=4, ylab="Acetone (ppbv)",type="o",ylim=c(0,2.0), xaxt="n", main="North Europe (50-70N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((me2co.obs.n)-(me2co.obs.sd.n)),  1:12, ((me2co.obs.n)+(me2co.obs.sd.n)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,me2co.mod.n,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((me2co.mod.n)-(me2co.mod.sd.n)),  1:12, ((me2co.mod.n)+(me2co.mod.sd.n)), length = 0.0, code =2, col="red" )
legend("topleft",c("EMEP (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 8"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", me2co.cor.r.n)," MBE = ", sprintf("%1.3g", me2co.MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (me2co.mod.n - (me2co.obs.n)), col="red", names.arg=monthNames, las=1, ylim=c(-0.5,0.5), xlab="", ylab=expression( paste(Delta, " Acetone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(me2co.obs.c,col="Black",xlab="", lwd=4, ylab="Acetone (ppbv)",type="o",ylim=c(0,2.0), xaxt="n", main="Central Europe (30-50N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((me2co.obs.c)-(me2co.obs.sd.c)),  1:12, ((me2co.obs.c)+(me2co.obs.sd.c)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,me2co.mod.c,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((me2co.mod.c)-(me2co.mod.sd.c)),  1:12, ((me2co.mod.c)+(me2co.mod.sd.c)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 10"),box.lty=0,cex=0.9)
text(6,0.10, c(paste("r = ",sprintf("%1.3g", me2co.cor.r.c)," MBE = ", sprintf("%1.3g", me2co.MBE.c), "%", sep="")), cex=0.9)
grid()

barplot( (me2co.mod.c - (me2co.obs.c)), col="red", names.arg=monthNames, las=1, ylim=c(-0.5,0.5), xlab="", ylab=expression( paste(Delta, " Acetone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

dev.off()