# R script to read and subset the Japanese O3 
# data. 
# Data provided for by Tonakora(?) - check.

# Alex Archibald, CAS, February 2012
# Zadie Stock, CAS, 21 May 2012

# source the obs data
data <- read.csv(paste(obs.dir, "Japan/JPNdata2005.csv", sep=""), header=T)

# loop vars and constants
conv <- 1E9
j <- NULL ; i <- NULL ; k <- NULL

# 12 stations
JanO3<-mean(data$jan,na.rm=TRUE)
FebO3<-mean(data$feb,na.rm=TRUE)
MarO3<-mean(data$mar,na.rm=TRUE)
AprO3<-mean(data$apr,na.rm=TRUE)
MayO3<-mean(data$may,na.rm=TRUE)
JunO3<-mean(data$jun,na.rm=TRUE)
JulO3<-mean(data$jul,na.rm=TRUE)
AugO3<-mean(data$aug,na.rm=TRUE)
SepO3<-mean(data$sep,na.rm=TRUE)
OctO3<-mean(data$oct,na.rm=TRUE)
NovO3<-mean(data$nov,na.rm=TRUE)
DecO3<-mean(data$dec,na.rm=TRUE)

sd.JanO3<-sd(data$jan,na.rm=TRUE)
sd.FebO3<-sd(data$feb,na.rm=TRUE)
sd.MarO3<-sd(data$mar,na.rm=TRUE)
sd.AprO3<-sd(data$apr,na.rm=TRUE)
sd.MayO3<-sd(data$may,na.rm=TRUE)
sd.JunO3<-sd(data$jun,na.rm=TRUE)
sd.JulO3<-sd(data$jul,na.rm=TRUE)
sd.AugO3<-sd(data$aug,na.rm=TRUE)
sd.SepO3<-sd(data$sep,na.rm=TRUE)
sd.OctO3<-sd(data$oct,na.rm=TRUE)
sd.NovO3<-sd(data$nov,na.rm=TRUE)
sd.DecO3<-sd(data$dec,na.rm=TRUE)

# combine the obs into one data frame
data.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3) # mean
sd.data.months<-abind(sd.JanO3,sd.FebO3,sd.MarO3,sd.AprO3,sd.MayO3,sd.JunO3,sd.JulO3,sd.AugO3,sd.SepO3,sd.OctO3,sd.NovO3,sd.DecO3) # standard deviation

# Determine the grid boxes to use
Lat <- data$Latitude
Lon <- data$Longitude
dlat <- (get.var.ncdf(nc1, "latitude")[2] - get.var.ncdf(nc1, "latitude")[1])
dlon <- (get.var.ncdf(nc1, "longitude")[2] - get.var.ncdf(nc1, "longitude")[1])
gLat = (round (  ((Lat +90)/dlat)  ))+1 
gLon <- ifelse ( Lon<0, (round( (Lon+360)/dlon))+1, (round (Lon/dlon) )+1  )
gLon <- ifelse ( gLon>length(get.var.ncdf(nc1, "longitude")),1,gLon) # wrap values around

# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")
times <- c(1,2,3,4,5,6,7,8,9,10,11,12)

# select model data
mod <- array(0.0,dim=c(length(gLat),length(times))) # create empty array to fill with data
for (j in 1:length(times) ){
for (i in 1:length(gLat) ) {
mod[i,j] <- get.var.ncdf(nc1, o3.code, start=c(gLon[i],gLat[i],1,times[j]), count=c(1,1,1,1) )*(conv/mm.o3) } }

# combine the model data into one dataframe
JanO3<-mean(mod[,1],na.rm=TRUE)
FebO3<-mean(mod[,2],na.rm=TRUE)
MarO3<-mean(mod[,3],na.rm=TRUE)
AprO3<-mean(mod[,4],na.rm=TRUE)
MayO3<-mean(mod[,5],na.rm=TRUE)
JunO3<-mean(mod[,6],na.rm=TRUE)
JulO3<-mean(mod[,7],na.rm=TRUE)
AugO3<-mean(mod[,8],na.rm=TRUE)
SepO3<-mean(mod[,9],na.rm=TRUE)
OctO3<-mean(mod[,10],na.rm=TRUE)
NovO3<-mean(mod[,11],na.rm=TRUE)
DecO3<-mean(mod[,12],na.rm=TRUE)

mod.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

# calc the sd
JanO3<-sd(mod[,1],na.rm=TRUE)
FebO3<-sd(mod[,2],na.rm=TRUE)
MarO3<-sd(mod[,3],na.rm=TRUE)
AprO3<-sd(mod[,4],na.rm=TRUE)
MayO3<-sd(mod[,5],na.rm=TRUE)
JunO3<-sd(mod[,6],na.rm=TRUE)
JulO3<-sd(mod[,7],na.rm=TRUE)
AugO3<-sd(mod[,8],na.rm=TRUE)
SepO3<-sd(mod[,9],na.rm=TRUE)
OctO3<-sd(mod[,10],na.rm=TRUE)
NovO3<-sd(mod[,11],na.rm=TRUE)
DecO3<-sd(mod[,12],na.rm=TRUE)

mod.sd<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

# calc stats
# correlation
cor.r <- cor(data.months,mod.months,use="pairwise.complete.obs",method="pearson")

#Mean bias error in %
M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=mod.months[k]-(data.months[k]) }
MBE=(sum(M)/12)/(sum(data.months)/12)*100

# ###############################################################################################
pdf(file=paste(out.dir, mod1.name, "_JPN_O3_comparison.pdf", sep=""),width=8,height=7,paper="special",
onefile=FALSE,pointsize=14)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.4,0.6,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:6, 3, 2, byrow = TRUE))

#par(mfrow=c(1,2))

plot(data.months,col="Black",xlab="Month of 2005", lwd=4, ylab="Ozone (ppbv)",type="o",ylim=c(0,80), xaxt="n")
arrows( 1:12, ((data.months)-(sd.data.months)),  1:12, ((data.months)+(sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,mod.months,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((mod.months)-(mod.sd)),  1:12, ((mod.months)+(mod.sd)), length = 0.0, code =2, col="red" )
title(main="Japan stations (24-45N), (123,145E)",cex.main=0.9)
legend("topleft",c("JPN (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 12"),box.lty=0,cex=0.9)
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.r)," MBE = ", sprintf("%1.3g", MBE), "%", sep="")), cex=0.9)
grid()

barplot( (mod.months - (data.months)), col="red", names.arg=monthNames, las=1, ylim=c(-20,20), xlab="Month of 2005", ylab=expression( paste(Delta, " Ozone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()


dev.off()
