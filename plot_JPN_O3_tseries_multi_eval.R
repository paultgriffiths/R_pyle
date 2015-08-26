# R analysis script used to plot 
# ozone obs in Japan

# Alex Archibald, CAS, August 2011
# zss21 May 2012

# #####################################################################################
library(ncdf)
library(fields)
library(abind)

# set the working directory for output (default to directory of this script)
out.dir <- "/data/ata27/"
obs.dir <- "/home/ata27/Obs/"

# enter name of modelsand some info for legends 
mod1.name <- "xgpal"
mod2.name <- "xgywo"
mod3.name <- "xgywn"

mod1.type <- "CheT"
mod2.type <- "CheS"
mod3.type <- "CheST"

# source a list of the molecular masses used in UKCA for tracers
source("get_mol_masses.R")
source("tracer_var_codes.R")

nc1 <- open.ncdf(paste("/scratch/ata27/",mod1.name,"_evaluation_output.nc", sep=""), readunlim=FALSE) 
nc2 <- open.ncdf(paste("/scratch/ata27/",mod2.name,"_evaluation_output.nc", sep=""), readunlim=FALSE) 
nc3 <- open.ncdf(paste("/scratch/ata27/",mod3.name,"_evaluation_output.nc", sep=""), readunlim=FALSE) 

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
data.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)
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
mod1 <- array(0.0,dim=c(length(gLat),length(times))) # create empty array to fill with data
mod2 <- array(0.0,dim=c(length(gLat),length(times))) # create empty array to fill with data
mod3 <- array(0.0,dim=c(length(gLat),length(times))) # create empty array to fill with data
for (j in 1:length(times) ){
for (i in 1:length(gLat) ) {
mod1[i,j] <- get.var.ncdf(nc1, o3.code, start=c(gLon[i],gLat[i],1,times[j]), count=c(1,1,1,1))*(conv/mm.o3)
mod2[i,j] <- get.var.ncdf(nc2, o3.code, start=c(gLon[i],gLat[i],1,times[j]), count=c(1,1,1,1))*(conv/mm.o3)
mod3[i,j] <- get.var.ncdf(nc3, o3.code, start=c(gLon[i],gLat[i],1,times[j]), count=c(1,1,1,1))*(conv/mm.o3)
}}


# combine the model data into one dataframe
JanO3<-mean(mod1[,1],na.rm=TRUE)
FebO3<-mean(mod1[,2],na.rm=TRUE)
MarO3<-mean(mod1[,3],na.rm=TRUE)
AprO3<-mean(mod1[,4],na.rm=TRUE)
MayO3<-mean(mod1[,5],na.rm=TRUE)
JunO3<-mean(mod1[,6],na.rm=TRUE)
JulO3<-mean(mod1[,7],na.rm=TRUE)
AugO3<-mean(mod1[,8],na.rm=TRUE)
SepO3<-mean(mod1[,9],na.rm=TRUE)
OctO3<-mean(mod1[,10],na.rm=TRUE)
NovO3<-mean(mod1[,11],na.rm=TRUE)
DecO3<-mean(mod1[,12],na.rm=TRUE)

mod1.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

JanO3<-mean(mod2[,1],na.rm=TRUE)
FebO3<-mean(mod2[,2],na.rm=TRUE)
MarO3<-mean(mod2[,3],na.rm=TRUE)
AprO3<-mean(mod2[,4],na.rm=TRUE)
MayO3<-mean(mod2[,5],na.rm=TRUE)
JunO3<-mean(mod2[,6],na.rm=TRUE)
JulO3<-mean(mod2[,7],na.rm=TRUE)
AugO3<-mean(mod2[,8],na.rm=TRUE)
SepO3<-mean(mod2[,9],na.rm=TRUE)
OctO3<-mean(mod2[,10],na.rm=TRUE)
NovO3<-mean(mod2[,11],na.rm=TRUE)
DecO3<-mean(mod2[,12],na.rm=TRUE)

mod2.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

JanO3<-mean(mod3[,1],na.rm=TRUE)
FebO3<-mean(mod3[,2],na.rm=TRUE)
MarO3<-mean(mod3[,3],na.rm=TRUE)
AprO3<-mean(mod3[,4],na.rm=TRUE)
MayO3<-mean(mod3[,5],na.rm=TRUE)
JunO3<-mean(mod3[,6],na.rm=TRUE)
JulO3<-mean(mod3[,7],na.rm=TRUE)
AugO3<-mean(mod3[,8],na.rm=TRUE)
SepO3<-mean(mod3[,9],na.rm=TRUE)
OctO3<-mean(mod3[,10],na.rm=TRUE)
NovO3<-mean(mod3[,11],na.rm=TRUE)
DecO3<-mean(mod3[,12],na.rm=TRUE)

mod3.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

# combine the model data into one dataframe
JanO3<-sd(mod1[,1],na.rm=TRUE)
FebO3<-sd(mod1[,2],na.rm=TRUE)
MarO3<-sd(mod1[,3],na.rm=TRUE)
AprO3<-sd(mod1[,4],na.rm=TRUE)
MayO3<-sd(mod1[,5],na.rm=TRUE)
JunO3<-sd(mod1[,6],na.rm=TRUE)
JulO3<-sd(mod1[,7],na.rm=TRUE)
AugO3<-sd(mod1[,8],na.rm=TRUE)
SepO3<-sd(mod1[,9],na.rm=TRUE)
OctO3<-sd(mod1[,10],na.rm=TRUE)
NovO3<-sd(mod1[,11],na.rm=TRUE)
DecO3<-sd(mod1[,12],na.rm=TRUE)

mod1.sd<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

JanO3<-sd(mod2[,1],na.rm=TRUE)
FebO3<-sd(mod2[,2],na.rm=TRUE)
MarO3<-sd(mod2[,3],na.rm=TRUE)
AprO3<-sd(mod2[,4],na.rm=TRUE)
MayO3<-sd(mod2[,5],na.rm=TRUE)
JunO3<-sd(mod2[,6],na.rm=TRUE)
JulO3<-sd(mod2[,7],na.rm=TRUE)
AugO3<-sd(mod2[,8],na.rm=TRUE)
SepO3<-sd(mod2[,9],na.rm=TRUE)
OctO3<-sd(mod2[,10],na.rm=TRUE)
NovO3<-sd(mod2[,11],na.rm=TRUE)
DecO3<-sd(mod2[,12],na.rm=TRUE)

mod2.sd<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

JanO3<-sd(mod3[,1],na.rm=TRUE)
FebO3<-sd(mod3[,2],na.rm=TRUE)
MarO3<-sd(mod3[,3],na.rm=TRUE)
AprO3<-sd(mod3[,4],na.rm=TRUE)
MayO3<-sd(mod3[,5],na.rm=TRUE)
JunO3<-sd(mod3[,6],na.rm=TRUE)
JulO3<-sd(mod3[,7],na.rm=TRUE)
AugO3<-sd(mod3[,8],na.rm=TRUE)
SepO3<-sd(mod3[,9],na.rm=TRUE)
OctO3<-sd(mod3[,10],na.rm=TRUE)
NovO3<-sd(mod3[,11],na.rm=TRUE)
DecO3<-sd(mod3[,12],na.rm=TRUE)

mod3.sd<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

# calc stats
# correlation
cor.1 <- cor(data.months,mod1.months,use="pairwise.complete.obs",method="pearson")
cor.2 <- cor(data.months,mod1.months,use="pairwise.complete.obs",method="pearson")
cor.3 <- cor(data.months,mod1.months,use="pairwise.complete.obs",method="pearson")

#Mean bias error in %
M1 <- array(0,dim=c(length(times)))
M2 <- array(0,dim=c(length(times)))
M3 <- array(0,dim=c(length(times)))

for (i in 1:length(times)){
M1[i] <- mod1.months[i]-data.months[i] 
M2[i] <- mod2.months[i]-data.months[i] 
M3[i] <- mod3.months[i]-data.months[i] }

MBE.1 <- (sum(M1)/12)/(sum(data.months)/12)*100
MBE.2 <- (sum(M2)/12)/(sum(data.months)/12)*100
MBE.3 <- (sum(M3)/12)/(sum(data.months)/12)*100

# ###############################################################################################
pdf(file=paste(out.dir,  mod1.name, "_", mod2.name, "_", mod3.name, "_JPN_O3_comparison.pdf", sep=""),width=8,height=6,paper="special",
onefile=FALSE,pointsize=14)

plot(data.months,col="Black",xlab="Month of 2005", lwd=4, ylab="Ozone (ppb)",type="l",ylim=c(0,80), xaxt="n")
#arrows( 1:12, ((data.months)-(sd.data.months)),  1:12, ((data.months)+(sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,mod1.months,type="l",col="red",lwd=4,lty=1)
arrows( 1:12, ((mod1.months)-(mod1.sd)),  1:12, ((mod1.months)+(mod1.sd)), length = 0.0, code =2, col="red" )
lines(times,mod2.months,type="l",col="blue",lwd=4,lty=1)
arrows( 1:12, ((mod2.months)-(mod2.sd)),  1:12, ((mod2.months)+(mod2.sd)), length = 0.0, code =2, col="blue" )
lines(times,mod3.months,type="l",col="green",lwd=4,lty=1)
arrows( 1:12, ((mod3.months)-(mod3.sd)),  1:12, ((mod3.months)+(mod3.sd)), length = 0.0, code =2, col="green" )
title(main="Japan stations 2005",cex.main=0.9)
legend("topleft",c("JPN obs (2005)",mod1.type,mod2.type,mod3.type),col=c("black","red","blue","green"),lty=c(1,1,1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 12"),box.lty=0,cex=0.9)
legend(1,5, c(paste("r = ",sprintf("%1.3g", cor.1)," MBE = ", sprintf("%1.3g", MBE.1), "%", sep="")), bty="n", cex=0.9, text.col="red")
legend(1,10, c(paste("r = ",sprintf("%1.3g", cor.2)," MBE = ", sprintf("%1.3g", MBE.2), "%", sep="")), bty="n", cex=0.9, text.col="blue")
legend(1,15, c(paste("r = ",sprintf("%1.3g", cor.3)," MBE = ", sprintf("%1.3g", MBE.3), "%", sep="")), bty="n", cex=0.9, text.col="green")
grid()

dev.off()
