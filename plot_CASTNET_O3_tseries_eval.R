# R script to read and subset the EPA CASTNET 
# data

# Alex Archibald, CAS, February 2012
# zss21 May 2012

# constants and loop vars
conv <- 1E9
i <- NULL ; j <- NULL

# read the stations and raw data (NOTE THIS IS BIG!)
stations  <- read.csv(paste(obs.dir, "CASTNET/stations.dat", sep=""), header=T)
data      <- read.csv(paste(obs.dir, "CASTNET/ozone_2005.csv", sep=""), header=T) # remove nrow for all data
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

# #######################################################################
#~~~~~~~~~~~~~~~~~~~Split stations into regions ~~~~~~~~~~~~~~~~~~~~~~~~~

# append lat and long to data month arrays
#Region1: all 87 stations : data.months,mod.months
#Region2: NE 37-63N -90--64E sfc    #39 stations : RegionNE
#Region3: SE 18-36N -90--64E sfc    #15 stations : RegionSE
#Region4: west 18-63N -155--91E sfc #33 stations : RegionW

RegionNE<-rbind(ABT147,STK138,ALH157,BVL130,SAL133,VIN140,CKT136,MAC426,MCK131,MCK231,BWR139,BEL116,ASH135,HOW132,ACA416,ANA115,HOX148,UVL124,WST109,WSP144,CAT175,CTH110,HWF187,DCP114,QAK172,OXF122,EGB181,ARE128,KEF112,PSU106,MKG113,LRL117,PED108,VPI120,PRK134,CDR119,PAR107,LYK123,LYE145)

RegionSE<-rbind(SND152,SUM156,EVE419,IRL141,GAS153,CDZ171,CVL151,COW137,PNF126,CND125,BFT142,SPD111,GRS420,ESP127,SHN418)

RegionW<-rbind(DEN417,CAD150,GRC474,PET427,CHA467,YOS404,LAV410,PIN414,JOT403,SEK430,MEV405,ROM406,GTH161,ROM206,KNZ184,VOY413,GLR468,THR422,GRB411,CHE185,WNC429,BBE401,ALC188,CAN407,MOR409,CNT169,YEL408,PND165,KVA428,CON186,DEV412,OLY421,NCS415)

#~~~~~~~~~~~~~Average NE stations~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NE_months <- unique(RegionNE$"MONTH")
monthsNE=c("JanNE","FebNE","MarNE","AprNE","MayNE","JunNE","JulNE","AugNE","SepNE","OctNE","NovNE","DecNE")
for (i in 1:length(NE_months) ) {
assign(paste(monthsNE[i]), subset(RegionNE, MONTH == paste(NE_months[i]) ) )
}

n.JanO3<-mean(JanNE$OZONE)
n.FebO3<-mean(FebNE$OZONE)
n.MarO3<-mean(MarNE$OZONE)
n.AprO3<-mean(AprNE$OZONE)
n.MayO3<-mean(MayNE$OZONE)
n.JunO3<-mean(JunNE$OZONE)
n.JulO3<-mean(JulNE$OZONE)
n.AugO3<-mean(AugNE$OZONE)
n.SepO3<-mean(SepNE$OZONE)
n.OctO3<-mean(OctNE$OZONE)
n.NovO3<-mean(NovNE$OZONE)
n.DecO3<-mean(DecNE$OZONE)

n.sd.JanO3<-sd(JanNE$OZONE)
n.sd.FebO3<-sd(FebNE$OZONE)
n.sd.MarO3<-sd(MarNE$OZONE)
n.sd.AprO3<-sd(AprNE$OZONE)
n.sd.MayO3<-sd(MayNE$OZONE)
n.sd.JunO3<-sd(JunNE$OZONE)
n.sd.JulO3<-sd(JulNE$OZONE)
n.sd.AugO3<-sd(AugNE$OZONE)
n.sd.SepO3<-sd(SepNE$OZONE)
n.sd.OctO3<-sd(OctNE$OZONE)
n.sd.NovO3<-sd(NovNE$OZONE)
n.sd.DecO3<-sd(DecNE$OZONE)

# combine the obs into one data frame
n.data.months<-abind(n.JanO3,n.FebO3,n.MarO3,n.AprO3,n.MayO3,n.JunO3,n.JulO3,n.AugO3,n.SepO3,n.OctO3,n.NovO3,n.DecO3) # mean
n.sd.data.months<-abind(n.sd.JanO3,n.sd.FebO3,n.sd.MarO3,n.sd.AprO3,n.sd.MayO3,n.sd.JunO3,n.sd.JulO3,n.sd.AugO3,n.sd.SepO3,n.sd.OctO3,n.sd.NovO3,n.sd.DecO3) # standard deviation

#~~~~~~~~~~~~~Average SE stations~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SE_months <- unique(RegionSE$"MONTH")
monthsSE=c("JanSE","FebSE","MarSE","AprSE","MaySE","JunSE","JulSE","AugSE","SepSE","OctSE","NovSE","DecSE")
for (i in 1:length(SE_months) ) {
assign(paste(monthsSE[i]), subset(RegionSE, MONTH == paste(SE_months[i]) ) )
}

s.JanO3<-mean(JanSE$OZONE)
s.FebO3<-mean(FebSE$OZONE)
s.MarO3<-mean(MarSE$OZONE)
s.AprO3<-mean(AprSE$OZONE)
s.MayO3<-mean(MaySE$OZONE)
s.JunO3<-mean(JunSE$OZONE)
s.JulO3<-mean(JulSE$OZONE)
s.AugO3<-mean(AugSE$OZONE)
s.SepO3<-mean(SepSE$OZONE)
s.OctO3<-mean(OctSE$OZONE)
s.NovO3<-mean(NovSE$OZONE)
s.DecO3<-mean(DecSE$OZONE)

s.sd.JanO3<-sd(JanSE$OZONE)
s.sd.FebO3<-sd(FebSE$OZONE)
s.sd.MarO3<-sd(MarSE$OZONE)
s.sd.AprO3<-sd(AprSE$OZONE)
s.sd.MayO3<-sd(MaySE$OZONE)
s.sd.JunO3<-sd(JunSE$OZONE)
s.sd.JulO3<-sd(JulSE$OZONE)
s.sd.AugO3<-sd(AugSE$OZONE)
s.sd.SepO3<-sd(SepSE$OZONE)
s.sd.OctO3<-sd(OctSE$OZONE)
s.sd.NovO3<-sd(NovSE$OZONE)
s.sd.DecO3<-sd(DecSE$OZONE)

# combine the obs into one data frame
s.data.months<-abind(s.JanO3,s.FebO3,s.MarO3,s.AprO3,s.MayO3,s.JunO3,s.JulO3,s.AugO3,s.SepO3,s.OctO3,s.NovO3,s.DecO3) # mean
s.sd.data.months<-abind(s.sd.JanO3,s.sd.FebO3,s.sd.MarO3,s.sd.AprO3,s.sd.MayO3,s.sd.JunO3,s.sd.JulO3,s.sd.AugO3,s.sd.SepO3,s.sd.OctO3,s.sd.NovO3,s.sd.DecO3) # standard deviation

#~~~~~~~~~~~~~Average W stations~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
W_months <- unique(RegionW$"MONTH")
monthsW=c("JanW","FebW","MarW","AprW","MayW","JunW","JulW","AugW","SepW","OctW","NovW","DecW")
for (i in 1:length(W_months) ) {
assign(paste(monthsW[i]), subset(RegionW, MONTH == paste(W_months[i]) ) )
}

w.JanO3<-mean(JanW$OZONE)
w.FebO3<-mean(FebW$OZONE)
w.MarO3<-mean(MarW$OZONE)
w.AprO3<-mean(AprW$OZONE)
w.MayO3<-mean(MayW$OZONE)
w.JunO3<-mean(JunW$OZONE)
w.JulO3<-mean(JulW$OZONE)
w.AugO3<-mean(AugW$OZONE)
w.SepO3<-mean(SepW$OZONE)
w.OctO3<-mean(OctW$OZONE)
w.NovO3<-mean(NovW$OZONE)
w.DecO3<-mean(DecW$OZONE)

w.sd.JanO3<-sd(JanW$OZONE)
w.sd.FebO3<-sd(FebW$OZONE)
w.sd.MarO3<-sd(MarW$OZONE)
w.sd.AprO3<-sd(AprW$OZONE)
w.sd.MayO3<-sd(MayW$OZONE)
w.sd.JunO3<-sd(JunW$OZONE)
w.sd.JulO3<-sd(JulW$OZONE)
w.sd.AugO3<-sd(AugW$OZONE)
w.sd.SepO3<-sd(SepW$OZONE)
w.sd.OctO3<-sd(OctW$OZONE)
w.sd.NovO3<-sd(NovW$OZONE)
w.sd.DecO3<-sd(DecW$OZONE)

# combine the obs into one data frame
w.data.months<-abind(w.JanO3,w.FebO3,w.MarO3,w.AprO3,w.MayO3,w.JunO3,w.JulO3,w.AugO3,w.SepO3,w.OctO3,w.NovO3,w.DecO3) # mean
w.sd.data.months<-abind(w.sd.JanO3,w.sd.FebO3,w.sd.MarO3,w.sd.AprO3,w.sd.MayO3,w.sd.JunO3,w.sd.JulO3,w.sd.AugO3,w.sd.SepO3,w.sd.OctO3,w.sd.NovO3,w.sd.DecO3) # standard deviation

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
mod <- array(0.0,dim=c(length(gLat),length(times))) # create empty array to fill with data
for (j in 1:length(times) ){
for (i in 1:length(gLat) ) {
mod[i,j] <- get.var.ncdf(nc1, o3.code, start=c(gLon[i],gLat[i],1,times[j]), count=c(1,1,1,1))*(conv/mm.o3)}}

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
mod[rem[i],j]<-NA
}
}

mod.months<-colMeans(mod, na.rm = TRUE)

# ######################################################
# ~~~~~~~~~~~~~~~ Select regions for model data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Note 132 stations already reduced to 87
#for (i in 1:length(rem)){
#gLat[rem[i]]<-NA
#gLon[rem[i]]<-NA
#}

# NE 37-63N -90 - -64E
n.mod <- subset(mod, Lon<=-64 & Lon>=-90 & Lat<=63 & Lat>=37)
#NEmod 40 stations

# SE Lat 18-36N -90 - -64E
s.mod <- subset(mod, Lon<=-64 & Lon>=-90 & Lat<=36 & Lat>=18)
#SEmod 14 stations

# W Lat 18-63N -155 - -91E
w.mod <- subset(mod, Lon<=-91 & Lon>=-155 & Lat<=63 & Lat>=18)
#Wmod 32 stations 

n.mod.months<-colMeans(n.mod, na.rm = TRUE)
n.mod.sd <- apply(n.mod, c(2), sd, na.rm=T)
s.mod.months<-colMeans(s.mod, na.rm = TRUE)
s.mod.sd <- apply(s.mod, c(2), sd, na.rm=T)
w.mod.months<-colMeans(w.mod, na.rm = TRUE)
w.mod.sd <- apply(s.mod, c(2), sd, na.rm=T)

# calc stats
# correlation
cor.r.n <- cor(n.data.months,n.mod.months,use="pairwise.complete.obs",method="pearson")
cor.r.w <- cor(w.data.months,w.mod.months,use="pairwise.complete.obs",method="pearson")
cor.r.s <- cor(s.data.months,s.mod.months,use="pairwise.complete.obs",method="pearson")

#Mean bias error in %
M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=n.mod.months[k]-(n.data.months[k]) }
MBE.n=(sum(M)/12)/(sum(n.data.months)/12)*100

M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=w.mod.months[k]-(w.data.months[k]) }
MBE.w=(sum(M)/12)/(sum(w.data.months)/12)*100

M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=s.mod.months[k]-(s.data.months[k]) }
MBE.s=(sum(M)/12)/(sum(s.data.months)/12)*100

# ###############################################################################################
pdf(file=paste(out.dir, mod1.name, "_CASTNET_O3_comparison.pdf", sep=""),width=8,height=7,paper="special",
onefile=FALSE,pointsize=14)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.4,0.6,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:6, 3, 2, byrow = TRUE))

#par(mfrow=c(3,2))

plot(n.data.months,col="Black",xlab="", lwd=4, ylab="Ozone (ppbv)",type="o",ylim=c(0,60), xaxt="n", main="N.East USA (37-63N), (90-64W)",cex.main=0.9)
arrows( 1:12, ((n.data.months)-(n.sd.data.months)),  1:12, ((n.data.months)+(n.sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,n.mod.months,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((n.mod.months)-(n.mod.sd)),  1:12, ((n.mod.months)+(n.mod.sd)), length = 0.0, code =2, col="red" )
legend("topleft",c("EPA CASTNET (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 40"),box.lty=0,cex=0.9)
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.r.n)," MBE = ", sprintf("%1.3g", MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (n.mod.months - (n.data.months)), col="red", names.arg=monthNames, las=1, ylim=c(-20,20), xlab="", ylab=expression( paste(Delta, " Ozone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(w.data.months,col="Black",xlab="", lwd=4, ylab="Ozone (ppbv)",type="o",ylim=c(0,60), xaxt="n", main="W. USA (18-63N), (155-91W)",cex.main=0.9)
arrows( 1:12, ((w.data.months)-(w.sd.data.months)),  1:12, ((w.data.months)+(w.sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,w.mod.months,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((w.mod.months)-(w.mod.sd)),  1:12, ((w.mod.months)+(w.mod.sd)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 32"),box.lty=0,cex=0.9)
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.r.w)," MBE = ", sprintf("%1.3g", MBE.w), "%", sep="")), cex=0.9)
grid()

barplot( (w.mod.months - (w.data.months)), col="red", names.arg=monthNames, las=1, ylim=c(-20,20), xlab="", ylab=expression( paste(Delta, " Ozone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(s.data.months,col="Black",xlab="", lwd=4, ylab="Ozone (ppbv)",type="o",ylim=c(0,60), xaxt="n", main="S.East USA (18-36N), (90-64W)",cex.main=0.9)
arrows( 1:12, ((s.data.months)-(s.sd.data.months)),  1:12, ((s.data.months)+(s.sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,s.mod.months,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((s.mod.months)-(s.mod.sd)),  1:12, ((s.mod.months)+(s.mod.sd)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 14"),box.lty=0,cex=0.9)
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.r.s)," MBE = ", sprintf("%1.3g", MBE.s), "%", sep="")), cex=0.9)
grid()

barplot( (s.mod.months - (s.data.months)), col="red", names.arg=monthNames, las=1, ylim=c(-20,20), xlab="", ylab=expression( paste(Delta, " Ozone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

dev.off()



