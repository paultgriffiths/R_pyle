# R script to plot model Ethane/Propane versus observations
# ATA, CAS July 2012

# constants
conv <- 1E9 # ppb

# calc the model spacing
del.lon <- get.var.ncdf(nc1, "longitude")[2] - get.var.ncdf(nc1, "longitude")[1]
del.lat <- get.var.ncdf(nc1, "latitude")[2] - get.var.ncdf(nc1, "latitude")[1]

# open measurments
obs <- paste(obs.dir, "CMDL/c2h6/flask/event/", sep="")
alt.c2 <- paste(obs,"alt","_01D0_event.c2h6",sep="")
mhd.c2 <- paste(obs,"mhd","_01D0_event.c2h6",sep="")
cpg.c2 <- paste(obs,"cgo","_01D0_event.c2h6",sep="")
spo.c2 <- paste(obs,"spo","_01D0_event.c2h6",sep="")
brw.c2 <- paste(obs,"brw","_01D0_event.c2h6",sep="")
tdf.c2 <- paste(obs,"tdf","_01D0_event.c2h6",sep="")
smo.c2 <- paste(obs,"smo","_01D0_event.c2h6",sep="")
syo.c2 <- paste(obs,"syo","_01D0_event.c2h6",sep="")
bal.c2 <- paste(obs,"bal","_01D0_event.c2h6",sep="")
asc.c2 <- paste(obs,"asc","_01D0_event.c2h6",sep="")
azr.c2 <- paste(obs,"azr","_01D0_event.c2h6",sep="")
psa.c2 <- paste(obs,"psa","_01D0_event.c2h6",sep="")
sum.c2 <- paste(obs,"sum","_01D0_event.c2h6",sep="")
mid.c2 <- paste(obs,"mid","_01D0_event.c2h6",sep="")
lef.c2 <- paste(obs,"lef","_01D0_event.c2h6",sep="")
sey.c2 <- paste(obs,"sey","_01D0_event.c2h6",sep="")
ask.c2 <- paste(obs,"ask","_01D0_event.c2h6",sep="")
eic.c2 <- paste(obs,"eic","_01D0_event.c2h6",sep="")
gmi.c2 <- paste(obs,"gmi","_01D0_event.c2h6",sep="")
hba.c2 <- paste(obs,"hba","_01D0_event.c2h6",sep="")

obs <- paste(obs.dir, "CMDL/c3h8/flask/event/", sep="")
alt.c3 <- paste(obs,"alt","_01D0_event.c3h8",sep="")
mhd.c3 <- paste(obs,"mhd","_01D0_event.c3h8",sep="")
cpg.c3 <- paste(obs,"cgo","_01D0_event.c3h8",sep="")
spo.c3 <- paste(obs,"spo","_01D0_event.c3h8",sep="")
brw.c3 <- paste(obs,"brw","_01D0_event.c3h8",sep="")
tdf.c3 <- paste(obs,"tdf","_01D0_event.c3h8",sep="")
smo.c3 <- paste(obs,"smo","_01D0_event.c3h8",sep="")
syo.c3 <- paste(obs,"syo","_01D0_event.c3h8",sep="")
bal.c3 <- paste(obs,"bal","_01D0_event.c3h8",sep="")
asc.c3 <- paste(obs,"asc","_01D0_event.c3h8",sep="")
azr.c3 <- paste(obs,"azr","_01D0_event.c3h8",sep="")
psa.c3 <- paste(obs,"psa","_01D0_event.c3h8",sep="")
sum.c3 <- paste(obs,"sum","_01D0_event.c3h8",sep="")
mid.c3 <- paste(obs,"mid","_01D0_event.c3h8",sep="")
lef.c3 <- paste(obs,"lef","_01D0_event.c3h8",sep="")
sey.c3 <- paste(obs,"sey","_01D0_event.c3h8",sep="")
ask.c3 <- paste(obs,"ask","_01D0_event.c3h8",sep="")
eic.c3 <- paste(obs,"eic","_01D0_event.c3h8",sep="")
gmi.c3 <- paste(obs,"gmi","_01D0_event.c3h8",sep="")
hba.c3 <- paste(obs,"hba","_01D0_event.c3h8",sep="")


# ------------------------------------------------------------------------------------------------- 
# Create data frames (note removing miss vals from obs...)
alt.c2h6.o = read.table(alt.c2, header=F)
alt.c2h6.o[alt.c2h6.o==-999.99]<-NA
alt.c3h8.o = read.table(alt.c3, header=F)
alt.c3h8.o[alt.c3h8.o==-999.99]<-NA
mhd.c2h6.o = read.table(mhd.c2, header=F)
mhd.c2h6.o[mhd.c2h6.o==-999.99]<-NA
mhd.c3h8.o = read.table(mhd.c3, header=F)
mhd.c3h8.o[mhd.c3h8.o==-999.99]<-NA
cpg.c2h6.o = read.table(cpg.c2, header=F)
cpg.c2h6.o[cpg.c2h6.o==-999.99]<-NA
cpg.c3h8.o = read.table(cpg.c3, header=F)
cpg.c3h8.o[cpg.c3h8.o==-999.99]<-NA
spo.c2h6.o = read.table(spo.c2, header=F)
spo.c2h6.o[spo.c2h6.o==-999.99]<-NA
spo.c3h8.o = read.table(spo.c3, header=F)
spo.c3h8.o[spo.c3h8.o==-999.99]<-NA
brw.c2h6.o = read.table(brw.c2, header=F)
brw.c2h6.o[brw.c2h6.o==-999.99]<-NA
brw.c3h8.o = read.table(brw.c3, header=F)
brw.c3h8.o[brw.c3h8.o==-999.99]<-NA
tdf.c2h6.o = read.table(tdf.c2, header=F)
tdf.c2h6.o[tdf.c2h6.o==-999.99]<-NA
tdf.c3h8.o = read.table(tdf.c3, header=F)
tdf.c3h8.o[tdf.c3h8.o==-999.99]<-NA
smo.c2h6.o = read.table(smo.c2, header=F)
smo.c2h6.o[smo.c2h6.o==-999.99]<-NA
smo.c3h8.o = read.table(smo.c3, header=F)
smo.c3h8.o[smo.c3h8.o==-999.99]<-NA
syo.c2h6.o = read.table(syo.c2, header=F)
syo.c2h6.o[syo.c2h6.o==-999.99]<-NA
syo.c3h8.o = read.table(syo.c3, header=F)
syo.c3h8.o[syo.c3h8.o==-999.99]<-NA
bal.c2h6.o = read.table(bal.c2, header=F)
bal.c2h6.o[bal.c2h6.o==-999.99]<-NA
bal.c3h8.o = read.table(bal.c3, header=F)
bal.c3h8.o[bal.c3h8.o==-999.99]<-NA
asc.c2h6.o = read.table(asc.c2, header=F)
asc.c2h6.o[asc.c2h6.o==-999.99]<-NA
asc.c3h8.o = read.table(asc.c3, header=F)
asc.c3h8.o[asc.c3h8.o==-999.99]<-NA
azr.c2h6.o = read.table(azr.c2, header=F)
azr.c2h6.o[azr.c2h6.o==-999.99]<-NA
azr.c3h8.o = read.table(azr.c3, header=F)
azr.c3h8.o[azr.c3h8.o==-999.99]<-NA
psa.c2h6.o = read.table(psa.c2, header=F)
psa.c2h6.o[psa.c2h6.o==-999.99]<-NA
psa.c3h8.o = read.table(psa.c3, header=F)
psa.c3h8.o[psa.c3h8.o==-999.99]<-NA
sum.c2h6.o = read.table(sum.c2, header=F)
sum.c2h6.o[sum.c2h6.o==-999.99]<-NA
sum.c3h8.o = read.table(sum.c3, header=F)
sum.c3h8.o[sum.c3h8.o==-999.99]<-NA
mid.c2h6.o = read.table(mid.c2, header=F)
mid.c2h6.o[mid.c2h6.o==-999.99]<-NA
mid.c3h8.o = read.table(mid.c3, header=F)
mid.c3h8.o[mid.c3h8.o==-999.99]<-NA
lef.c2h6.o = read.table(lef.c2, header=F)
lef.c2h6.o[lef.c2h6.o==-999.99]<-NA
lef.c3h8.o = read.table(lef.c3, header=F)
lef.c3h8.o[lef.c3h8.o==-999.99]<-NA
sey.c2h6.o = read.table(sey.c2, header=F)
sey.c2h6.o[sey.c2h6.o==-999.99]<-NA
sey.c3h8.o = read.table(sey.c3, header=F)
sey.c3h8.o[sey.c3h8.o==-999.99]<-NA
ask.c2h6.o = read.table(ask.c2, header=F)
ask.c2h6.o[ask.c2h6.o==-999.99]<-NA
ask.c3h8.o = read.table(ask.c3, header=F)
ask.c3h8.o[ask.c3h8.o==-999.99]<-NA
eic.c2h6.o = read.table(eic.c2, header=F)
eic.c2h6.o[eic.c2h6.o==-999.99]<-NA
eic.c3h8.o = read.table(eic.c3, header=F)
eic.c3h8.o[eic.c3h8.o==-999.99]<-NA
gmi.c2h6.o = read.table(gmi.c2, header=F)
gmi.c2h6.o[gmi.c2h6.o==-999.99]<-NA
gmi.c3h8.o = read.table(gmi.c3, header=F)
gmi.c3h8.o[gmi.c3h8.o==-999.99]<-NA
hba.c2h6.o = read.table(hba.c2, header=F)
hba.c2h6.o[hba.c2h6.o==-999.99]<-NA
hba.c3h8.o = read.table(hba.c3, header=F)
hba.c3h8.o[hba.c3h8.o==-999.99]<-NA

# functions to calculate the model grid box from the observation lat,lon
find.lon <- function (x) {
ifelse ( x<0, (round( ((x+360)/del.lon)-0.5))+1, (round( ((x/del.lon)-0.5) ))+1  )[1] }

find.lat <- function (y) {
round (  (((y +90)/del.lat)  )+1)[1] }

altLat <- find.lat(alt.c2h6.o$V19)
altLon <- find.lon(alt.c2h6.o$V20)
mhdLat <- find.lat(mhd.c2h6.o$V19)
mhdLon <- find.lon(mhd.c2h6.o$V20)
cpgLat <- find.lat(cpg.c2h6.o$V19)
cpgLon <- find.lon(cpg.c2h6.o$V20)
spoLat <- find.lat(spo.c2h6.o$V19)
spoLon <- find.lon(spo.c2h6.o$V20)
brwLat <- find.lat(brw.c2h6.o$V19)
brwLon <- find.lon(brw.c2h6.o$V20)
tdfLat <- find.lat(tdf.c2h6.o$V19)
tdfLon <- find.lon(tdf.c2h6.o$V20)
smoLat <- find.lat(smo.c2h6.o$V19)
smoLon <- find.lon(smo.c2h6.o$V20)
syoLat <- find.lat(syo.c2h6.o$V19)
syoLon <- find.lon(syo.c2h6.o$V20)
balLat <- find.lat(bal.c2h6.o$V19)
balLon <- find.lon(bal.c2h6.o$V20)
ascLat <- find.lat(asc.c2h6.o$V19)
ascLon <- find.lon(asc.c2h6.o$V20)
azrLat <- find.lat(azr.c2h6.o$V19)
azrLon <- find.lon(azr.c2h6.o$V20)
psaLat <- find.lat(psa.c2h6.o$V19)
psaLon <- find.lon(psa.c2h6.o$V20)
sumLat <- find.lat(sum.c2h6.o$V19)
sumLon <- find.lon(sum.c2h6.o$V20)
midLat <- find.lat(mid.c2h6.o$V19)
midLon <- find.lon(mid.c2h6.o$V20)
lefLat <- find.lat(lef.c2h6.o$V19)
lefLon <- find.lon(lef.c2h6.o$V20)
seyLat <- find.lat(sey.c2h6.o$V19)
seyLon <- find.lon(sey.c2h6.o$V20)
askLat <- find.lat(ask.c2h6.o$V19)
askLon <- find.lon(ask.c2h6.o$V20)
eicLat <- find.lat(eic.c2h6.o$V19)
eicLon <- find.lon(eic.c2h6.o$V20)
gmiLat <- find.lat(gmi.c2h6.o$V19)
gmiLon <- find.lon(gmi.c2h6.o$V20)
hbaLat <- find.lat(hba.c2h6.o$V19)
hbaLon <- find.lon(hba.c2h6.o$V20)

# ------------------------------------------------------------------------------------------------- 
# Extract the model data 
alt.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(altLon,altLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
alt.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(altLon,altLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

mhd.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(mhdLon,mhdLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
mhd.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(mhdLon,mhdLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

cpg.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(cpgLon,cpgLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
cpg.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(cpgLon,cpgLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

spo.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(spoLon,spoLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
spo.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(spoLon,spoLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

brw.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(brwLon,brwLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
brw.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(brwLon,brwLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

tdf.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(tdfLon,tdfLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
tdf.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(tdfLon,tdfLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

smo.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(smoLon,smoLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
smo.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(smoLon,smoLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

syo.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(syoLon,syoLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
syo.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(syoLon,syoLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

bal.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(balLon,balLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
bal.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(balLon,balLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

asc.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(ascLon,ascLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
asc.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(ascLon,ascLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

azr.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(azrLon,azrLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
azr.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(azrLon,azrLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

psa.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(psaLon,psaLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
psa.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(psaLon,psaLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

sum.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(sumLon,sumLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
sum.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(sumLon,sumLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

mid.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(midLon,midLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
mid.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(midLon,midLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

lef.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(lefLon,lefLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
lef.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(lefLon,lefLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

sey.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(seyLon,seyLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
sey.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(seyLon,seyLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

ask.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(askLon,askLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
ask.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(askLon,askLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

eic.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(eicLon,eicLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
eic.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(eicLon,eicLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

gmi.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(gmiLon,gmiLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
gmi.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(gmiLon,gmiLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

hba.c2h6 <- get.var.ncdf(nc1,ethane.code,start=c(hbaLon,hbaLat,1,1),count=c(1,1,1,12))*(conv/mm.c2h6)
hba.c3h8 <- get.var.ncdf(nc1,propane.code,start=c(hbaLon,hbaLat,1,1),count=c(1,1,1,12))*(conv/mm.c3h8)

# create medians of obs data
alt.c2h6.o$date <- paste(alt.c2h6.o$V2, alt.c2h6.o$V3, alt.c2h6.o$V4, alt.c2h6.o$V5, alt.c2h6.o$V6, sep="-")
alt.c2h6.o$date <- as.Date(alt.c2h6.o$date, "%Y-%m-%d-%H-%M")
alt.c2h6.o.median <- aggregate(alt.c2h6.o$V10, format(alt.c2h6.o["date"],"%m"), median, na.rm=T)
alt.c2h6.o.sd   <- aggregate(alt.c2h6.o$V10, format(alt.c2h6.o["date"],"%m"), sd, na.rm=T)
alt.c3h8.o$date <- paste(alt.c3h8.o$V2, alt.c3h8.o$V3, alt.c3h8.o$V4, alt.c3h8.o$V5, alt.c3h8.o$V6, sep="-")
alt.c3h8.o$date <- as.Date(alt.c3h8.o$date, "%Y-%m-%d-%H-%M")
alt.c3h8.o.median <- aggregate(alt.c3h8.o$V10, format(alt.c3h8.o["date"],"%m"), median, na.rm=T)
alt.c3h8.o.sd   <- aggregate(alt.c3h8.o$V10, format(alt.c3h8.o["date"],"%m"), sd, na.rm=T)

mhd.c2h6.o$date <- paste(mhd.c2h6.o$V2, mhd.c2h6.o$V3, mhd.c2h6.o$V4, mhd.c2h6.o$V5, mhd.c2h6.o$V6, sep="-")
mhd.c2h6.o$date <- as.Date(mhd.c2h6.o$date, "%Y-%m-%d-%H-%M")
mhd.c2h6.o.median <- aggregate(mhd.c2h6.o$V10, format(mhd.c2h6.o["date"],"%m"), median, na.rm=T)
mhd.c2h6.o.sd   <- aggregate(mhd.c2h6.o$V10, format(mhd.c2h6.o["date"],"%m"), sd, na.rm=T)
mhd.c3h8.o$date <- paste(mhd.c3h8.o$V2, mhd.c3h8.o$V3, mhd.c3h8.o$V4, mhd.c3h8.o$V5, mhd.c3h8.o$V6, sep="-")
mhd.c3h8.o$date <- as.Date(mhd.c3h8.o$date, "%Y-%m-%d-%H-%M")
mhd.c3h8.o.median <- aggregate(mhd.c3h8.o$V10, format(mhd.c3h8.o["date"],"%m"), median, na.rm=T)
mhd.c3h8.o.sd   <- aggregate(mhd.c3h8.o$V10, format(mhd.c3h8.o["date"],"%m"), sd, na.rm=T)

cpg.c2h6.o$date <- paste(cpg.c2h6.o$V2, cpg.c2h6.o$V3, cpg.c2h6.o$V4, cpg.c2h6.o$V5, cpg.c2h6.o$V6, sep="-")
cpg.c2h6.o$date <- as.Date(cpg.c2h6.o$date, "%Y-%m-%d-%H-%M")
cpg.c2h6.o.median <- aggregate(cpg.c2h6.o$V10, format(cpg.c2h6.o["date"],"%m"), median, na.rm=T)
cpg.c2h6.o.sd   <- aggregate(cpg.c2h6.o$V10, format(cpg.c2h6.o["date"],"%m"), sd, na.rm=T)
cpg.c3h8.o$date <- paste(cpg.c3h8.o$V2, cpg.c3h8.o$V3, cpg.c3h8.o$V4, cpg.c3h8.o$V5, cpg.c3h8.o$V6, sep="-")
cpg.c3h8.o$date <- as.Date(cpg.c3h8.o$date, "%Y-%m-%d-%H-%M")
cpg.c3h8.o.median <- aggregate(cpg.c3h8.o$V10, format(cpg.c3h8.o["date"],"%m"), median, na.rm=T)
cpg.c3h8.o.sd   <- aggregate(cpg.c3h8.o$V10, format(cpg.c3h8.o["date"],"%m"), sd, na.rm=T)

spo.c2h6.o$date <- paste(spo.c2h6.o$V2, spo.c2h6.o$V3, spo.c2h6.o$V4, spo.c2h6.o$V5, spo.c2h6.o$V6, sep="-")
spo.c2h6.o$date <- as.Date(spo.c2h6.o$date, "%Y-%m-%d-%H-%M")
spo.c2h6.o.median <- aggregate(spo.c2h6.o$V10, format(spo.c2h6.o["date"],"%m"), median, na.rm=T)
spo.c2h6.o.sd   <- aggregate(spo.c2h6.o$V10, format(spo.c2h6.o["date"],"%m"), sd, na.rm=T)
spo.c3h8.o$date <- paste(spo.c3h8.o$V2, spo.c3h8.o$V3, spo.c3h8.o$V4, spo.c3h8.o$V5, spo.c3h8.o$V6, sep="-")
spo.c3h8.o$date <- as.Date(spo.c3h8.o$date, "%Y-%m-%d-%H-%M")
spo.c3h8.o.median <- aggregate(spo.c3h8.o$V10, format(spo.c3h8.o["date"],"%m"), median, na.rm=T)
spo.c3h8.o.sd   <- aggregate(spo.c3h8.o$V10, format(spo.c3h8.o["date"],"%m"), sd, na.rm=T)

brw.c2h6.o$date <- paste(brw.c2h6.o$V2, brw.c2h6.o$V3, brw.c2h6.o$V4, brw.c2h6.o$V5, brw.c2h6.o$V6, sep="-")
brw.c2h6.o$date <- as.Date(brw.c2h6.o$date, "%Y-%m-%d-%H-%M")
brw.c2h6.o.median <- aggregate(brw.c2h6.o$V10, format(brw.c2h6.o["date"],"%m"), median, na.rm=T)
brw.c2h6.o.sd   <- aggregate(brw.c2h6.o$V10, format(brw.c2h6.o["date"],"%m"), sd, na.rm=T)
brw.c3h8.o$date <- paste(brw.c3h8.o$V2, brw.c3h8.o$V3, brw.c3h8.o$V4, brw.c3h8.o$V5, brw.c3h8.o$V6, sep="-")
brw.c3h8.o$date <- as.Date(brw.c3h8.o$date, "%Y-%m-%d-%H-%M")
brw.c3h8.o.median <- aggregate(brw.c3h8.o$V10, format(brw.c3h8.o["date"],"%m"), median, na.rm=T)
brw.c3h8.o.sd   <- aggregate(brw.c3h8.o$V10, format(brw.c3h8.o["date"],"%m"), sd, na.rm=T)

tdf.c2h6.o$date <- paste(tdf.c2h6.o$V2, tdf.c2h6.o$V3, tdf.c2h6.o$V4, tdf.c2h6.o$V5, tdf.c2h6.o$V6, sep="-")
tdf.c2h6.o$date <- as.Date(tdf.c2h6.o$date, "%Y-%m-%d-%H-%M")
tdf.c2h6.o.median <- aggregate(tdf.c2h6.o$V10, format(tdf.c2h6.o["date"],"%m"), median, na.rm=T)
tdf.c2h6.o.sd   <- aggregate(tdf.c2h6.o$V10, format(tdf.c2h6.o["date"],"%m"), sd, na.rm=T)
tdf.c3h8.o$date <- paste(tdf.c3h8.o$V2, tdf.c3h8.o$V3, tdf.c3h8.o$V4, tdf.c3h8.o$V5, tdf.c3h8.o$V6, sep="-")
tdf.c3h8.o$date <- as.Date(tdf.c3h8.o$date, "%Y-%m-%d-%H-%M")
tdf.c3h8.o.median <- aggregate(tdf.c3h8.o$V10, format(tdf.c3h8.o["date"],"%m"), median, na.rm=T)
tdf.c3h8.o.sd   <- aggregate(tdf.c3h8.o$V10, format(tdf.c3h8.o["date"],"%m"), sd, na.rm=T)

smo.c2h6.o$date <- paste(smo.c2h6.o$V2, smo.c2h6.o$V3, smo.c2h6.o$V4, smo.c2h6.o$V5, smo.c2h6.o$V6, sep="-")
smo.c2h6.o$date <- as.Date(smo.c2h6.o$date, "%Y-%m-%d-%H-%M")
smo.c2h6.o.median <- aggregate(smo.c2h6.o$V10, format(smo.c2h6.o["date"],"%m"), median, na.rm=T)
smo.c2h6.o.sd   <- aggregate(smo.c2h6.o$V10, format(smo.c2h6.o["date"],"%m"), sd, na.rm=T)
smo.c3h8.o$date <- paste(smo.c3h8.o$V2, smo.c3h8.o$V3, smo.c3h8.o$V4, smo.c3h8.o$V5, smo.c3h8.o$V6, sep="-")
smo.c3h8.o$date <- as.Date(smo.c3h8.o$date, "%Y-%m-%d-%H-%M")
smo.c3h8.o.median <- aggregate(smo.c3h8.o$V10, format(smo.c3h8.o["date"],"%m"), median, na.rm=T)
smo.c3h8.o.sd   <- aggregate(smo.c3h8.o$V10, format(smo.c3h8.o["date"],"%m"), sd, na.rm=T)

syo.c2h6.o$date <- paste(syo.c2h6.o$V2, syo.c2h6.o$V3, syo.c2h6.o$V4, syo.c2h6.o$V5, syo.c2h6.o$V6, sep="-")
syo.c2h6.o$date <- as.Date(syo.c2h6.o$date, "%Y-%m-%d-%H-%M")
syo.c2h6.o.median <- aggregate(syo.c2h6.o$V10, format(syo.c2h6.o["date"],"%m"), median, na.rm=T)
syo.c2h6.o.sd   <- aggregate(syo.c2h6.o$V10, format(syo.c2h6.o["date"],"%m"), sd, na.rm=T)
syo.c3h8.o$date <- paste(syo.c3h8.o$V2, syo.c3h8.o$V3, syo.c3h8.o$V4, syo.c3h8.o$V5, syo.c3h8.o$V6, sep="-")
syo.c3h8.o$date <- as.Date(syo.c3h8.o$date, "%Y-%m-%d-%H-%M")
syo.c3h8.o.median <- aggregate(syo.c3h8.o$V10, format(syo.c3h8.o["date"],"%m"), median, na.rm=T)
syo.c3h8.o.sd   <- aggregate(syo.c3h8.o$V10, format(syo.c3h8.o["date"],"%m"), sd, na.rm=T)

bal.c2h6.o$date <- paste(bal.c2h6.o$V2, bal.c2h6.o$V3, bal.c2h6.o$V4, bal.c2h6.o$V5, bal.c2h6.o$V6, sep="-")
bal.c2h6.o$date <- as.Date(bal.c2h6.o$date, "%Y-%m-%d-%H-%M")
bal.c2h6.o.median <- aggregate(bal.c2h6.o$V10, format(bal.c2h6.o["date"],"%m"), median, na.rm=T)
bal.c2h6.o.sd   <- aggregate(bal.c2h6.o$V10, format(bal.c2h6.o["date"],"%m"), sd, na.rm=T)
bal.c3h8.o$date <- paste(bal.c3h8.o$V2, bal.c3h8.o$V3, bal.c3h8.o$V4, bal.c3h8.o$V5, bal.c3h8.o$V6, sep="-")
bal.c3h8.o$date <- as.Date(bal.c3h8.o$date, "%Y-%m-%d-%H-%M")
bal.c3h8.o.median <- aggregate(bal.c3h8.o$V10, format(bal.c3h8.o["date"],"%m"), median, na.rm=T)
bal.c3h8.o.sd   <- aggregate(bal.c3h8.o$V10, format(bal.c3h8.o["date"],"%m"), sd, na.rm=T)

asc.c2h6.o$date <- paste(asc.c2h6.o$V2, asc.c2h6.o$V3, asc.c2h6.o$V4, asc.c2h6.o$V5, asc.c2h6.o$V6, sep="-")
asc.c2h6.o$date <- as.Date(asc.c2h6.o$date, "%Y-%m-%d-%H-%M")
asc.c2h6.o.median <- aggregate(asc.c2h6.o$V10, format(asc.c2h6.o["date"],"%m"), median, na.rm=T)
asc.c2h6.o.sd   <- aggregate(asc.c2h6.o$V10, format(asc.c2h6.o["date"],"%m"), sd, na.rm=T)
asc.c3h8.o$date <- paste(asc.c3h8.o$V2, asc.c3h8.o$V3, asc.c3h8.o$V4, asc.c3h8.o$V5, asc.c3h8.o$V6, sep="-")
asc.c3h8.o$date <- as.Date(asc.c3h8.o$date, "%Y-%m-%d-%H-%M")
asc.c3h8.o.median <- aggregate(asc.c3h8.o$V10, format(asc.c3h8.o["date"],"%m"), median, na.rm=T)
asc.c3h8.o.sd   <- aggregate(asc.c3h8.o$V10, format(asc.c3h8.o["date"],"%m"), sd, na.rm=T)

azr.c2h6.o$date <- paste(azr.c2h6.o$V2, azr.c2h6.o$V3, azr.c2h6.o$V4, azr.c2h6.o$V5, azr.c2h6.o$V6, sep="-")
azr.c2h6.o$date <- as.Date(azr.c2h6.o$date, "%Y-%m-%d-%H-%M")
azr.c2h6.o.median <- aggregate(azr.c2h6.o$V10, format(azr.c2h6.o["date"],"%m"), median, na.rm=T)
azr.c2h6.o.sd   <- aggregate(azr.c2h6.o$V10, format(azr.c2h6.o["date"],"%m"), sd, na.rm=T)
azr.c3h8.o$date <- paste(azr.c3h8.o$V2, azr.c3h8.o$V3, azr.c3h8.o$V4, azr.c3h8.o$V5, azr.c3h8.o$V6, sep="-")
azr.c3h8.o$date <- as.Date(azr.c3h8.o$date, "%Y-%m-%d-%H-%M")
azr.c3h8.o.median <- aggregate(azr.c3h8.o$V10, format(azr.c3h8.o["date"],"%m"), median, na.rm=T)
azr.c3h8.o.sd   <- aggregate(azr.c3h8.o$V10, format(azr.c3h8.o["date"],"%m"), sd, na.rm=T)

psa.c2h6.o$date <- paste(psa.c2h6.o$V2, psa.c2h6.o$V3, psa.c2h6.o$V4, psa.c2h6.o$V5, psa.c2h6.o$V6, sep="-")
psa.c2h6.o$date <- as.Date(psa.c2h6.o$date, "%Y-%m-%d-%H-%M")
psa.c2h6.o.median <- aggregate(psa.c2h6.o$V10, format(psa.c2h6.o["date"],"%m"), median, na.rm=T)
psa.c2h6.o.sd   <- aggregate(psa.c2h6.o$V10, format(psa.c2h6.o["date"],"%m"), sd, na.rm=T)
psa.c3h8.o$date <- paste(psa.c3h8.o$V2, psa.c3h8.o$V3, psa.c3h8.o$V4, psa.c3h8.o$V5, psa.c3h8.o$V6, sep="-")
psa.c3h8.o$date <- as.Date(psa.c3h8.o$date, "%Y-%m-%d-%H-%M")
psa.c3h8.o.median <- aggregate(psa.c3h8.o$V10, format(psa.c3h8.o["date"],"%m"), median, na.rm=T)
psa.c3h8.o.sd   <- aggregate(psa.c3h8.o$V10, format(psa.c3h8.o["date"],"%m"), sd, na.rm=T)

sum.c2h6.o$date <- paste(sum.c2h6.o$V2, sum.c2h6.o$V3, sum.c2h6.o$V4, sum.c2h6.o$V5, sum.c2h6.o$V6, sep="-")
sum.c2h6.o$date <- as.Date(sum.c2h6.o$date, "%Y-%m-%d-%H-%M")
sum.c2h6.o.median <- aggregate(sum.c2h6.o$V10, format(sum.c2h6.o["date"],"%m"), median, na.rm=T)
sum.c2h6.o.sd   <- aggregate(sum.c2h6.o$V10, format(sum.c2h6.o["date"],"%m"), sd, na.rm=T)
sum.c3h8.o$date <- paste(sum.c3h8.o$V2, sum.c3h8.o$V3, sum.c3h8.o$V4, sum.c3h8.o$V5, sum.c3h8.o$V6, sep="-")
sum.c3h8.o$date <- as.Date(sum.c3h8.o$date, "%Y-%m-%d-%H-%M")
sum.c3h8.o.median <- aggregate(sum.c3h8.o$V10, format(sum.c3h8.o["date"],"%m"), median, na.rm=T)
sum.c3h8.o.sd   <- aggregate(sum.c3h8.o$V10, format(sum.c3h8.o["date"],"%m"), sd, na.rm=T)

mid.c2h6.o$date <- paste(mid.c2h6.o$V2, mid.c2h6.o$V3, mid.c2h6.o$V4, mid.c2h6.o$V5, mid.c2h6.o$V6, sep="-")
mid.c2h6.o$date <- as.Date(mid.c2h6.o$date, "%Y-%m-%d-%H-%M")
mid.c2h6.o.median <- aggregate(mid.c2h6.o$V10, format(mid.c2h6.o["date"],"%m"), median, na.rm=T)
mid.c2h6.o.sd   <- aggregate(mid.c2h6.o$V10, format(mid.c2h6.o["date"],"%m"), sd, na.rm=T)
mid.c3h8.o$date <- paste(mid.c3h8.o$V2, mid.c3h8.o$V3, mid.c3h8.o$V4, mid.c3h8.o$V5, mid.c3h8.o$V6, sep="-")
mid.c3h8.o$date <- as.Date(mid.c3h8.o$date, "%Y-%m-%d-%H-%M")
mid.c3h8.o.median <- aggregate(mid.c3h8.o$V10, format(mid.c3h8.o["date"],"%m"), median, na.rm=T)
mid.c3h8.o.sd   <- aggregate(mid.c3h8.o$V10, format(mid.c3h8.o["date"],"%m"), sd, na.rm=T)

lef.c2h6.o$date <- paste(lef.c2h6.o$V2, lef.c2h6.o$V3, lef.c2h6.o$V4, lef.c2h6.o$V5, lef.c2h6.o$V6, sep="-")
lef.c2h6.o$date <- as.Date(lef.c2h6.o$date, "%Y-%m-%d-%H-%M")
lef.c2h6.o.median <- aggregate(lef.c2h6.o$V10, format(lef.c2h6.o["date"],"%m"), median, na.rm=T)
lef.c2h6.o.sd   <- aggregate(lef.c2h6.o$V10, format(lef.c2h6.o["date"],"%m"), sd, na.rm=T)
lef.c3h8.o$date <- paste(lef.c3h8.o$V2, lef.c3h8.o$V3, lef.c3h8.o$V4, lef.c3h8.o$V5, lef.c3h8.o$V6, sep="-")
lef.c3h8.o$date <- as.Date(lef.c3h8.o$date, "%Y-%m-%d-%H-%M")
lef.c3h8.o.median <- aggregate(lef.c3h8.o$V10, format(lef.c3h8.o["date"],"%m"), median, na.rm=T)
lef.c3h8.o.sd   <- aggregate(lef.c3h8.o$V10, format(lef.c3h8.o["date"],"%m"), sd, na.rm=T)

sey.c2h6.o$date <- paste(sey.c2h6.o$V2, sey.c2h6.o$V3, sey.c2h6.o$V4, sey.c2h6.o$V5, sey.c2h6.o$V6, sep="-")
sey.c2h6.o$date <- as.Date(sey.c2h6.o$date, "%Y-%m-%d-%H-%M")
sey.c2h6.o.median <- aggregate(sey.c2h6.o$V10, format(sey.c2h6.o["date"],"%m"), median, na.rm=T)
sey.c2h6.o.sd   <- aggregate(sey.c2h6.o$V10, format(sey.c2h6.o["date"],"%m"), sd, na.rm=T)
sey.c3h8.o$date <- paste(sey.c3h8.o$V2, sey.c3h8.o$V3, sey.c3h8.o$V4, sey.c3h8.o$V5, sey.c3h8.o$V6, sep="-")
sey.c3h8.o$date <- as.Date(sey.c3h8.o$date, "%Y-%m-%d-%H-%M")
sey.c3h8.o.median <- aggregate(sey.c3h8.o$V10, format(sey.c3h8.o["date"],"%m"), median, na.rm=T)
sey.c3h8.o.sd   <- aggregate(sey.c3h8.o$V10, format(sey.c3h8.o["date"],"%m"), sd, na.rm=T)

ask.c2h6.o$date <- paste(ask.c2h6.o$V2, ask.c2h6.o$V3, ask.c2h6.o$V4, ask.c2h6.o$V5, ask.c2h6.o$V6, sep="-")
ask.c2h6.o$date <- as.Date(ask.c2h6.o$date, "%Y-%m-%d-%H-%M")
ask.c2h6.o.median <- aggregate(ask.c2h6.o$V10, format(ask.c2h6.o["date"],"%m"), median, na.rm=T)
ask.c2h6.o.sd   <- aggregate(ask.c2h6.o$V10, format(ask.c2h6.o["date"],"%m"), sd, na.rm=T)
ask.c3h8.o$date <- paste(ask.c3h8.o$V2, ask.c3h8.o$V3, ask.c3h8.o$V4, ask.c3h8.o$V5, ask.c3h8.o$V6, sep="-")
ask.c3h8.o$date <- as.Date(ask.c3h8.o$date, "%Y-%m-%d-%H-%M")
ask.c3h8.o.median <- aggregate(ask.c3h8.o$V10, format(ask.c3h8.o["date"],"%m"), median, na.rm=T)
ask.c3h8.o.sd   <- aggregate(ask.c3h8.o$V10, format(ask.c3h8.o["date"],"%m"), sd, na.rm=T)

eic.c2h6.o$date <- paste(eic.c2h6.o$V2, eic.c2h6.o$V3, eic.c2h6.o$V4, eic.c2h6.o$V5, eic.c2h6.o$V6, sep="-")
eic.c2h6.o$date <- as.Date(eic.c2h6.o$date, "%Y-%m-%d-%H-%M")
eic.c2h6.o.median <- aggregate(eic.c2h6.o$V10, format(eic.c2h6.o["date"],"%m"), median, na.rm=T)
eic.c2h6.o.sd   <- aggregate(eic.c2h6.o$V10, format(eic.c2h6.o["date"],"%m"), sd, na.rm=T)
eic.c3h8.o$date <- paste(eic.c3h8.o$V2, eic.c3h8.o$V3, eic.c3h8.o$V4, eic.c3h8.o$V5, eic.c3h8.o$V6, sep="-")
eic.c3h8.o$date <- as.Date(eic.c3h8.o$date, "%Y-%m-%d-%H-%M")
eic.c3h8.o.median <- aggregate(eic.c3h8.o$V10, format(eic.c3h8.o["date"],"%m"), median, na.rm=T)
eic.c3h8.o.sd   <- aggregate(eic.c3h8.o$V10, format(eic.c3h8.o["date"],"%m"), sd, na.rm=T)

gmi.c2h6.o$date <- paste(gmi.c2h6.o$V2, gmi.c2h6.o$V3, gmi.c2h6.o$V4, gmi.c2h6.o$V5, gmi.c2h6.o$V6, sep="-")
gmi.c2h6.o$date <- as.Date(gmi.c2h6.o$date, "%Y-%m-%d-%H-%M")
gmi.c2h6.o.median <- aggregate(gmi.c2h6.o$V10, format(gmi.c2h6.o["date"],"%m"), median, na.rm=T)
gmi.c2h6.o.sd   <- aggregate(gmi.c2h6.o$V10, format(gmi.c2h6.o["date"],"%m"), sd, na.rm=T)
gmi.c3h8.o$date <- paste(gmi.c3h8.o$V2, gmi.c3h8.o$V3, gmi.c3h8.o$V4, gmi.c3h8.o$V5, gmi.c3h8.o$V6, sep="-")
gmi.c3h8.o$date <- as.Date(gmi.c3h8.o$date, "%Y-%m-%d-%H-%M")
gmi.c3h8.o.median <- aggregate(gmi.c3h8.o$V10, format(gmi.c3h8.o["date"],"%m"), median, na.rm=T)
gmi.c3h8.o.sd   <- aggregate(gmi.c3h8.o$V10, format(gmi.c3h8.o["date"],"%m"), sd, na.rm=T)

hba.c2h6.o$date <- paste(hba.c2h6.o$V2, hba.c2h6.o$V3, hba.c2h6.o$V4, hba.c2h6.o$V5, hba.c2h6.o$V6, sep="-")
hba.c2h6.o$date <- as.Date(hba.c2h6.o$date, "%Y-%m-%d-%H-%M")
hba.c2h6.o.median <- aggregate(hba.c2h6.o$V10, format(hba.c2h6.o["date"],"%m"), median, na.rm=T)
hba.c2h6.o.sd   <- aggregate(hba.c2h6.o$V10, format(hba.c2h6.o["date"],"%m"), sd, na.rm=T)
hba.c3h8.o$date <- paste(hba.c3h8.o$V2, hba.c3h8.o$V3, hba.c3h8.o$V4, hba.c3h8.o$V5, hba.c3h8.o$V6, sep="-")
hba.c3h8.o$date <- as.Date(hba.c3h8.o$date, "%Y-%m-%d-%H-%M")
hba.c3h8.o.median <- aggregate(hba.c3h8.o$V10, format(hba.c3h8.o["date"],"%m"), median, na.rm=T)
hba.c3h8.o.sd   <- aggregate(hba.c3h8.o$V10, format(hba.c3h8.o["date"],"%m"), sd, na.rm=T)

alt.o.median <- log(alt.c3h8.o.median$x / alt.c2h6.o.median$x)
mhd.o.median <- log(mhd.c3h8.o.median$x / mhd.c2h6.o.median$x)
cpg.o.median <- log(cpg.c3h8.o.median$x / cpg.c2h6.o.median$x)
spo.o.median <- log(spo.c3h8.o.median$x / spo.c2h6.o.median$x)
brw.o.median <- log(brw.c3h8.o.median$x / brw.c2h6.o.median$x)
tdf.o.median <- log(tdf.c3h8.o.median$x / tdf.c2h6.o.median$x)
smo.o.median <- log(smo.c3h8.o.median$x / smo.c2h6.o.median$x)
syo.o.median <- log(syo.c3h8.o.median$x / syo.c2h6.o.median$x)
bal.o.median <- log(bal.c3h8.o.median$x / bal.c2h6.o.median$x)
asc.o.median <- log(asc.c3h8.o.median$x / asc.c2h6.o.median$x)
azr.o.median <- log(azr.c3h8.o.median$x / azr.c2h6.o.median$x)
psa.o.median <- log(psa.c3h8.o.median$x / psa.c2h6.o.median$x)
sum.o.median <- log(sum.c3h8.o.median$x / sum.c2h6.o.median$x)
mid.o.median <- log(mid.c3h8.o.median$x / mid.c2h6.o.median$x)
lef.o.median <- log(lef.c3h8.o.median$x / lef.c2h6.o.median$x)
sey.o.median <- log(sey.c3h8.o.median$x / sey.c2h6.o.median$x)
ask.o.median <- log(ask.c3h8.o.median$x / ask.c2h6.o.median$x)
eic.o.median <- log(eic.c3h8.o.median$x / eic.c2h6.o.median$x)
gmi.o.median <- log(gmi.c3h8.o.median$x / gmi.c2h6.o.median$x)
hba.o.median <- log(hba.c3h8.o.median$x / hba.c2h6.o.median$x)

# calc the std. error of the ratio
# formual = sqrt( ((c2h6.sd)^2/(c2h6.median)^2) + ((c3h8.sd)^2/(c3h8.median)^2) ) -- NOT USED
# formula = X * sqrt( ((c2h6.sd/c2h6.median)^2) + ((c3h8.sd/c3h8.median)^2) )
alt.dz <- alt.o.median * sqrt( ((alt.c3h8.o.sd$x/alt.c3h8.o.median$x)^2) + ((alt.c2h6.o.sd$x/alt.c2h6.o.median$x)^2) )
mhd.dz <- mhd.o.median * sqrt( ((mhd.c3h8.o.sd$x/mhd.c3h8.o.median$x)^2) + ((mhd.c2h6.o.sd$x/mhd.c2h6.o.median$x)^2) )
cpg.dz <- cpg.o.median * sqrt( ((cpg.c3h8.o.sd$x/cpg.c3h8.o.median$x)^2) + ((cpg.c2h6.o.sd$x/cpg.c2h6.o.median$x)^2) )
spo.dz <- spo.o.median * sqrt( ((spo.c3h8.o.sd$x/spo.c3h8.o.median$x)^2) + ((spo.c2h6.o.sd$x/spo.c2h6.o.median$x)^2) )
brw.dz <- brw.o.median * sqrt( ((brw.c3h8.o.sd$x/brw.c3h8.o.median$x)^2) + ((brw.c2h6.o.sd$x/brw.c2h6.o.median$x)^2) )
tdf.dz <- tdf.o.median * sqrt( ((tdf.c3h8.o.sd$x/tdf.c3h8.o.median$x)^2) + ((tdf.c2h6.o.sd$x/tdf.c2h6.o.median$x)^2) )
smo.dz <- smo.o.median * sqrt( ((smo.c3h8.o.sd$x/smo.c3h8.o.median$x)^2) + ((smo.c2h6.o.sd$x/smo.c2h6.o.median$x)^2) )
syo.dz <- syo.o.median * sqrt( ((syo.c3h8.o.sd$x/syo.c3h8.o.median$x)^2) + ((syo.c2h6.o.sd$x/syo.c2h6.o.median$x)^2) )
bal.dz <- bal.o.median * sqrt( ((bal.c3h8.o.sd$x/bal.c3h8.o.median$x)^2) + ((bal.c2h6.o.sd$x/bal.c2h6.o.median$x)^2) )
asc.dz <- asc.o.median * sqrt( ((asc.c3h8.o.sd$x/asc.c3h8.o.median$x)^2) + ((asc.c2h6.o.sd$x/asc.c2h6.o.median$x)^2) )
azr.dz <- azr.o.median * sqrt( ((azr.c3h8.o.sd$x/azr.c3h8.o.median$x)^2) + ((azr.c2h6.o.sd$x/azr.c2h6.o.median$x)^2) )
psa.dz <- psa.o.median * sqrt( ((psa.c3h8.o.sd$x/psa.c3h8.o.median$x)^2) + ((psa.c2h6.o.sd$x/psa.c2h6.o.median$x)^2) )
sum.dz <- sum.o.median * sqrt( ((sum.c3h8.o.sd$x/sum.c3h8.o.median$x)^2) + ((sum.c2h6.o.sd$x/sum.c2h6.o.median$x)^2) )
mid.dz <- mid.o.median * sqrt( ((mid.c3h8.o.sd$x/mid.c3h8.o.median$x)^2) + ((mid.c2h6.o.sd$x/mid.c2h6.o.median$x)^2) )
lef.dz <- lef.o.median * sqrt( ((lef.c3h8.o.sd$x/lef.c3h8.o.median$x)^2) + ((lef.c2h6.o.sd$x/lef.c2h6.o.median$x)^2) )
sey.dz <- sey.o.median * sqrt( ((sey.c3h8.o.sd$x/sey.c3h8.o.median$x)^2) + ((sey.c2h6.o.sd$x/sey.c2h6.o.median$x)^2) )
ask.dz <- ask.o.median * sqrt( ((ask.c3h8.o.sd$x/ask.c3h8.o.median$x)^2) + ((ask.c2h6.o.sd$x/ask.c2h6.o.median$x)^2) )
eic.dz <- eic.o.median * sqrt( ((eic.c3h8.o.sd$x/eic.c3h8.o.median$x)^2) + ((eic.c2h6.o.sd$x/eic.c2h6.o.median$x)^2) )
gmi.dz <- gmi.o.median * sqrt( ((gmi.c3h8.o.sd$x/gmi.c3h8.o.median$x)^2) + ((gmi.c2h6.o.sd$x/gmi.c2h6.o.median$x)^2) )
hba.dz <- hba.o.median * sqrt( ((hba.c3h8.o.sd$x/hba.c3h8.o.median$x)^2) + ((hba.c2h6.o.sd$x/hba.c2h6.o.median$x)^2) )


monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")
# ######################################################
pdf(file=paste(out.dir, mod1.name, "_CMDL_ethane_propane_comparison.pdf", sep=""),width=17,height=14,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mgp = c(2, 1, 0), # control the label positions
       mai=c(0.6,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:20, 4, 5, byrow = TRUE))

plot(1:12, alt.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = "Alert 82N 62W")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((alt.o.median)-(alt.dz)),  1:12, ((alt.o.median)+(alt.dz)), length = 0.0, code =2 )
lines(log(alt.c3h8/alt.c2h6), col="red", lty=1, lwd=2)
legend("topleft", mod1.name, lwd=1, col="red", bty="n")

plot(1:12, sum.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n", 
ylim=c(-8,4),
main = paste("Summit ",as.integer(sum.c2h6.o$V19[1]),"N ", as.integer(abs(sum.c2h6.o$V20[1])), "W", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((sum.o.median)-(sum.dz)),  1:12, ((sum.o.median)+(sum.dz)), length = 0.0, code =2 )
lines(log(sum.c3h8/sum.c2h6), col="red", lty=1, lwd=3)

plot(1:12, brw.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n", 
ylim=c(-8,4),
main = "Barrow 71N 157E")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((brw.o.median)-(brw.dz)),  1:12, ((brw.o.median)+(brw.dz)), length = 0.0, code =2 )
lines(log(brw.c3h8/brw.c2h6), col="red", lty=1, lwd=3)

plot(1:12, bal.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Baltic Sea ",as.integer(bal.c2h6.o$V19[1]),"N ", as.integer(bal.c2h6.o$V20[1]), "E", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((bal.o.median)-(bal.dz)),  1:12, ((bal.o.median)+(bal.dz)), length = 0.0, code =2 )
lines(log(bal.c3h8/bal.c2h6), col="red", lty=1, lwd=2)

plot(1:12, mhd.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = "Mace Head 53N 9W")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((mhd.o.median)-(mhd.dz)),  1:12, ((mhd.o.median)+(mhd.dz)), length = 0.0, code =2 )
lines(log(mhd.c3h8/mhd.c2h6), col="red", lty=1, lwd=3)

plot(1:12, lef.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n", 
ylim=c(-8,4),
main = paste("Park Falls ",as.integer(lef.c2h6.o$V19[1]),"N ", as.integer(abs(lef.c2h6.o$V20[1])), "W", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((lef.o.median)-(lef.dz)),  1:12, ((lef.o.median)+(lef.dz)), length = 0.0, code =2 )
lines(log(lef.c3h8/lef.c2h6), col="red", lty=1, lwd=3)

plot(1:12, azr.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Azores ",as.integer(azr.c2h6.o$V19[1]),"N ", as.integer(abs(azr.c2h6.o$V20[1])), "W", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((azr.o.median)-(azr.dz)),  1:12, ((azr.o.median)+(azr.dz)), length = 0.0, code =2 )
lines(log(azr.c3h8/azr.c2h6), col="red", lty=1, lwd=3)

plot(1:12, mid.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Midway ",as.integer(mid.c2h6.o$V19[1]),"N ", as.integer(abs(mid.c2h6.o$V20[1])), "W", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((mid.o.median)-(mid.dz)),  1:12, ((mid.o.median)+(mid.dz)), length = 0.0, code =2 )
lines(log(mid.c3h8/mid.c2h6), col="red", lty=1, lwd=3)

plot(1:12, ask.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Assekrem ",as.integer(abs(ask.c2h6.o$V19[1])),"N ", as.integer(ask.c2h6.o$V20[1]), "E", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((ask.o.median)-(ask.dz)),  1:12, ((ask.o.median)+(ask.dz)), length = 0.0, code =2 )
lines(log(ask.c3h8/ask.c2h6), col="red", lty=1, lwd=3)

plot(1:12, gmi.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Mariani Isl. ",as.integer(abs(gmi.c2h6.o$V19[1])),"S ", as.integer(gmi.c2h6.o$V20[1]), "E", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((gmi.o.median)-(gmi.dz)),  1:12, ((gmi.o.median)+(gmi.dz)), length = 0.0, code =2 )
lines(log(gmi.c3h8/gmi.c2h6), col="red", lty=1, lwd=3)

plot(1:12, sey.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Seycheles ",as.integer(abs(sey.c2h6.o$V19[1])),"S ", as.integer(sey.c2h6.o$V20[1]), "E", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((sey.o.median)-(sey.dz)),  1:12, ((sey.o.median)+(sey.dz)), length = 0.0, code =2 )
lines(log(sey.c3h8/sey.c2h6), col="red", lty=1, lwd=3)

plot(1:12, asc.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Ascension Is. ",as.integer(abs(asc.c2h6.o$V19[1])),"S ", as.integer(abs(asc.c2h6.o$V20[1])), "W", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((asc.o.median)-(asc.dz)),  1:12, ((asc.o.median)+(asc.dz)), length = 0.0, code =2 )
lines(log(asc.c3h8/asc.c2h6), col="red", lty=1, lwd=3)

plot(1:12, smo.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n", 
ylim=c(-8,4),
main = "Samoa 14S 170W")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((smo.o.median)-(smo.dz)),  1:12, ((smo.o.median)+(smo.dz)), length = 0.0, code =2 )
lines(log(smo.c3h8/smo.c2h6), col="red", lty=1, lwd=3)

plot(1:12, eic.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Easter Isl. ",as.integer(abs(eic.c2h6.o$V19[1])),"S ", as.integer(eic.c2h6.o$V20[1]), "E", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((eic.o.median)-(eic.dz)),  1:12, ((eic.o.median)+(eic.dz)), length = 0.0, code =2 )
lines(log(eic.c3h8/eic.c2h6), col="red", lty=1, lwd=3)

plot(1:12, cpg.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = "Cape Grim 41S 144E")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((cpg.o.median)-(cpg.dz)),  1:12, ((cpg.o.median)+(cpg.dz)), length = 0.0, code =2 )
lines(log(cpg.c3h8/cpg.c2h6), col="red", lty=1, lwd=3)

plot(1:12, tdf.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = "Tierra Del Fuego 55S 68W")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((tdf.o.median)-(tdf.dz)),  1:12, ((tdf.o.median)+(tdf.dz)), length = 0.0, code =2 )
lines(log(tdf.c3h8/tdf.c2h6), col="red", lty=1, lwd=3)

plot(1:12, psa.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Palmer Station ",as.integer(abs(psa.c2h6.o$V19[1])),"S ", as.integer(abs(psa.c2h6.o$V20[1])), "W", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((psa.o.median)-(psa.dz)),  1:12, ((psa.o.median)+(psa.dz)), length = 0.0, code =2 )
lines(log(psa.c3h8/psa.c2h6), col="red", lty=1, lwd=3)

plot(1:12, syo.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = "Syowa Station 69S 40E")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((syo.o.median)-(syo.dz)),  1:12, ((syo.o.median)+(syo.dz)), length = 0.0, code =2 )
lines(log(syo.c3h8/syo.c2h6), col="red", lty=1, lwd=3)

plot(1:12, hba.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = paste("Halley Bay ",as.integer(abs(hba.c2h6.o$V19[1])),"S ", as.integer(hba.c2h6.o$V20[1]), "E", sep="") )
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((hba.o.median)-(hba.dz)),  1:12, ((hba.o.median)+(hba.dz)), length = 0.0, code =2 )
lines(log(hba.c3h8/hba.c2h6), col="red", lty=1, lwd=3)

plot(1:12, spo.o.median, xlab="", ylab="log([Propane]/[Ethane])", type="l", lwd=2, xaxt="n",
ylim=c(-8,4),
main = "South Pole 90S 25W")
grid()
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
arrows( 1:12, ((spo.o.median)-(spo.dz)),  1:12, ((spo.o.median)+(spo.dz)), length = 0.0, code =2 )
lines(log(spo.c3h8/spo.c2h6), col="red", lty=1, lwd=3)

dev.off()

