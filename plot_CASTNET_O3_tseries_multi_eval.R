# R analysis script used to plot 
# ozone obs in USA

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
source(paste(script.dir, "get_mol_masses.R", sep=""))
source(paste(script.dir, "tracer_var_codes.R", sep=""))

nc1 <- open.ncdf(paste("/scratch/ata27/",mod1.name,"_evaluation_output.nc", sep=""), readunlim=FALSE) 
nc2 <- open.ncdf(paste("/scratch/ata27/",mod2.name,"_evaluation_output.nc", sep=""), readunlim=FALSE) 
nc3 <- open.ncdf(paste("/scratch/ata27/",mod3.name,"_evaluation_output.nc", sep=""), readunlim=FALSE) 

# constants and loop vars
conv <- 1E9
i <- NULL ; j <- NULL

# read the stations and raw data (NOTE THIS IS BIG!)
stations  <- read.csv(paste(obs.dir, "CASTNET/stations.dat", sep=""), header=T)
data      <- read.csv(paste(obs.dir, "CASTNET/ozone_2005.csv", sep=""),  header=T) # remove nrow for all data
data$date <- as.POSIXct(strptime(data$"DATE_TIME", format="%Y-%m-%d %H:%M:%S"))

# at this stage may be good to split that dataframe up so that just have
# a few variables
data <- data.frame(data$date, data$"SITE_ID", data$"OZONE", data$"OZONE_F")

names <- c("DATE", "SITE_ID", "OZONE", "OZONE_F")
names(data) <- names
datat <- format(data["DATE"],"%m")
namest <- c("MONTH")
names(datat) <-namest
data <- cbind(data,datat)

# subset the data according to stations
# there are 87 stations found in the data (I can see)
sites <- unique(data$"SITE_ID")
# [1] ABT147 ACA416 ALC188 ALH157 ANA115 ARE128 ASH135 BBE401 BEL116 BFT142
#[11] BVL130 BWR139 CAD150 CAN407 CAT175 CDR119 CDZ171 CHA467 CHE185 CKT136
#[21] CND125 CNT169 CON186 COW137 CTH110 CVL151 DCP114 DEN417 DEV412 EGB181
#[31] ESP127 EVE419 GAS153 GLR468 GRB411 GRC474 GRS420 GTH161 HOW132 HOX148
#[41] HWF187 IRL141 JOT403 KEF112 KNZ184 KVA428 LAV410 LRL117 LYE145 LYK123
#[51] MAC426 MCK131 MCK231 MEV405 MKG113 MOR409 NCS415 OLY421 OXF122 PAR107
#[61] PED108 PET427 PIN414 PND165 PNF126 PRK134 PSU106 QAK172 ROM206 ROM406
#[71] SAL133 SEK430 SHN418 SND152 SPD111 STK138 SUM156 THR422 UVL124 VIN140
#[81] VOY413 VPI120 WNC429 WSP144 WST109 YEL408 YOS404

# this loop should scan through the combined data and spit out
# a new dataframe for each individual site

# If problem with site (ie OZONE_F doesnt not equal blank then mark as NA)
data$OZONE_F[which(data$OZONE_F!="")]=NA
# remove any data with NA
data1<- data[complete.cases(data),]

for (i in 1:length(sites) ) {
assign(paste(sites[i]), subset(data1, SITE_ID == paste(sites[i]) ) )
}

# Annual mean  ## ATA: Does this need to be a loop??
for (i in 1:length(sites) ) {
Annual<-tapply(data1$OZONE,data1$SITE_ID,mean)}

# Annual mean over all stations
mean(Annual,na.rm=T)
summary(Annual,na.rm=T)

# #######################################################################
# For monthly means 
months <- unique(data$"MONTH")
monthsn=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
for (j in 1:length(months) ) {
assign(paste(monthsn[j]), subset(data1, MONTH == paste(months[j]) ) )
}

JanO3<-mean(Jan$OZONE)
FebO3<-mean(Feb$OZONE)
MarO3<-mean(Mar$OZONE)
AprO3<-mean(Apr$OZONE)
MayO3<-mean(May$OZONE)
JunO3<-mean(Jun$OZONE)
JulO3<-mean(Jul$OZONE)
AugO3<-mean(Aug$OZONE)
SepO3<-mean(Sep$OZONE)
OctO3<-mean(Oct$OZONE)
NovO3<-mean(Nov$OZONE)
DecO3<-mean(Dec$OZONE)

data.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

sd.JanO3<-sd(Jan$OZONE)
sd.FebO3<-sd(Feb$OZONE)
sd.MarO3<-sd(Mar$OZONE)
sd.AprO3<-sd(Apr$OZONE)
sd.MayO3<-sd(May$OZONE)
sd.JunO3<-sd(Jun$OZONE)
sd.JulO3<-sd(Jul$OZONE)
sd.AugO3<-sd(Aug$OZONE)
sd.SepO3<-sd(Sep$OZONE)
sd.OctO3<-sd(Oct$OZONE)
sd.NovO3<-sd(Nov$OZONE)
sd.DecO3<-sd(Dec$OZONE)

sd.data.months<-abind(JanO3,FebO3,MarO3,AprO3,MayO3,JunO3,JulO3,AugO3,SepO3,OctO3,NovO3,DecO3)

# ######################################################
# Read in model data and stations lat/lon to compare

stations <- data.frame(stations$"SITE_ID", stations$"LATITUDE",stations$"LONGITUDE")
names_s <- c("SITE_ID", "Lat", "Lon")
names(stations) <- names_s

# Determine the grid boxes to use
Lat <- stations$Lat
Lon <- stations$Lon
dlat <- (get.var.ncdf(nc1, "latitude")[2] - get.var.ncdf(nc1, "latitude")[1])
dlon <- (get.var.ncdf(nc1, "longitude")[2] - get.var.ncdf(nc1, "longitude")[1])
gLat = (round (  ((Lat +90)/dlat)  ))+1 
gLon <- ifelse ( Lon<0, (round( (Lon+360)/dlon))+1, (round (Lon/dlon) )+1  )
gLon <- ifelse ( gLon>length(get.var.ncdf(nc1, "longitude")),1,gLon) # wrap values around

# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")
times=c(1,2,3,4,5,6,7,8,9,10,11,12)

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

mod_yr <- array(0.0,dim=c(length(gLat)))
for (i in 1:length(gLat) ) {
mod_yr[i] <- get.var.ncdf(nc1, o3.code, start=c(gLon[i],gLat[i],1,1), count=c(1,1,1,1))*(conv/mm.o3)}

# 132 stations/model o3, need to reduce to the 87 obs
stat<-data.frame(stations$SITE_ID)
namesS<-c("site")
names(stat)<-namesS
mod_yr.stations<-cbind(mod_yr,stat)
mod_yr.stations1<-mod_yr.stations

#check which stations do not have obs data
#for (i in 1:length(sites)){
#print(sites[i])
#mod_yr.stations$site[grep(paste(sites[i]), mod_yr.stations$site, ignore=T)] <-"NA"
#}

#In model remove these rows (stations in model that there are no obs for)
#rem=45, 132-45=87 stations
rem<-c(48,68,72,85,86,88,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,119,120,121,122,123,124,125,126,127,128,132)

for (i in 1:length(rem)){
mod_yr.stations1$mod_yr[rem[i]]<-NA
}
Amod<- mod_yr.stations1$mod_yr[complete.cases(mod_yr.stations1$mod_yr)]

for (j in 1:length(times)){
for (i in 1:length(rem)){
mod1[rem[i],j]<-NA
mod2[rem[i],j]<-NA
mod3[rem[i],j]<-NA 
}
}

mod1.months<-colMeans(mod1, na.rm = TRUE)
mod1.sd    <- apply(mod1, c(2), sd, na.rm=T)
mod2.months<-colMeans(mod2, na.rm = TRUE)
mod2.sd    <- apply(mod3, c(2), sd, na.rm=T)
mod3.months<-colMeans(mod3, na.rm = TRUE)
mod3.sd    <- apply(mod3, c(2), sd, na.rm=T)

# calc some stats
# Pearson correlations
cor.1 <- cor(data.months,mod1.months,use="pairwise.complete.obs",method="pearson")
cor.2 <- cor(data.months,mod2.months,use="pairwise.complete.obs",method="pearson")
cor.3 <- cor(data.months,mod3.months,use="pairwise.complete.obs",method="pearson")

#Mean Bias
mod1.bias <- mean(mod1.months)-mean(data.months)
mod2.bias <- mean(mod2.months)-mean(data.months)
mod3.bias <- mean(mod3.months)-mean(data.months)

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
pdf(file=paste(out.dir, mod1.name, "_", mod2.name, "_", mod3.name, "_CASTNET_O3_comparison.pdf", sep=""),width=8,height=6,paper="special",
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
title(main="All EPA CASTNET stations 2005",cex.main=0.9)
legend("topleft",c("EPA CASTNET obs (2005)",mod1.type,mod2.type,mod3.type),col=c("black","red","blue","green"),lty=c(1,1,1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 87"),box.lty=0,cex=0.9)
legend(1,5, c(paste("r = ",sprintf("%1.3g", cor.1)," MBE = ", sprintf("%1.3g", MBE.1), "%", sep="")), bty="n", cex=0.9, text.col="red")
legend(1,10, c(paste("r = ",sprintf("%1.3g", cor.2)," MBE = ", sprintf("%1.3g", MBE.2), "%", sep="")), bty="n", cex=0.9, text.col="blue")
legend(1,15, c(paste("r = ",sprintf("%1.3g", cor.3)," MBE = ", sprintf("%1.3g", MBE.3), "%", sep="")), bty="n", cex=0.9, text.col="green")
grid()

dev.off()



