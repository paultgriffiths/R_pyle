# R script to read in CMDL CO data (compiled a la PJY - THANKS!)
# and overplot model data.

# Alex Archibald, June, 2012


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

# Open station code file
fields <- read.csv(paste(obs.dir, "CMDL/co_station_order.csv"), sep="")

# calc del lon and lats
del.lon <- get.var.ncdf(nc1, "longitude")[2] - get.var.ncdf(nc1, "longitude")[1]
del.lat <- get.var.ncdf(nc1, "latitude")[2] - get.var.ncdf(nc1, "latitude")[1]

# convert "real" lats and longs to model grid boxes
fields$mLat <- (round (  ((fields$Lat +90)/del.lat)  ))+1
fields$mLon <- ifelse ( fields$Lon<0, (round( ((fields$Lon+360)/del.lon)-0.5))+1, (round( ((fields$Lon/del.lon)-0.5) ))+1  )

# use split to convert the fields data frame into a series of data frames split by the
# CMDL code
stations <- split(fields[], fields$Code)

#open measurments
obs <- paste(obs.dir, "CMDL/co/month/", sep="")
alt <- paste(obs,"altmm.co",sep="")
zep <- paste(obs,"zepmm.co",sep="")
mbc <- paste(obs,"mbcmm.co",sep="")
#sum <- paste(obs,"summm.co",sep="")
brw <- paste(obs,"brwmm.co",sep="")
#pal <- paste(obs,"palmm.co",sep="")
stm <- paste(obs,"stmmm.co",sep="")
ice <- paste(obs,"icemm.co",sep="")
bal <- paste(obs,"balmm.co",sep="")
cba <- paste(obs,"cbamm.co",sep="")
#obn <- paste(obs,"obnmm.co",sep="")
mhd <- paste(obs,"mhdmm.co",sep="")
shm <- paste(obs,"shmmm.co",sep="")
#oxk <- paste(obs,"oxkmm.co",sep="")
#opw <- paste(obs,"opwmm.co",sep="")
hun <- paste(obs,"hunmm.co",sep="")
lef <- paste(obs,"lefmm.co",sep="")
cmo <- paste(obs,"cmomm.co",sep="")
#amt <- paste(obs,"amtmm.co",sep="")
kzd <- paste(obs,"kzdmm.co",sep="")
uum <- paste(obs,"uummm.co",sep="")
bsc <- paste(obs,"bscmm.co",sep="")
kzm <- paste(obs,"kzmmm.co",sep="")
#thd <- paste(obs,"thdmm.co",sep="")
nwr <- paste(obs,"nwrmm.co",sep="")
uta <- paste(obs,"utamm.co",sep="")
pta <- paste(obs,"ptamm.co",sep="")
azr <- paste(obs,"azrmm.co",sep="")
#sgp <- paste(obs,"sgpmm.co",sep="")
tap <- paste(obs,"tapmm.co",sep="")
wlg <- paste(obs,"wlgmm.co",sep="")
goz <- paste(obs,"gozmm.co",sep="")
itn <- paste(obs,"itnmm.co",sep="")
bme <- paste(obs,"bmemm.co",sep="")
bmw <- paste(obs,"bmwmm.co",sep="")
#wkt <- paste(obs,"wktmm.co",sep="")
wis <- paste(obs,"wismm.co",sep="")
izo <- paste(obs,"izomm.co",sep="")
mid <- paste(obs,"midmm.co",sep="")
key <- paste(obs,"keymm.co",sep="")
ask <- paste(obs,"askmm.co",sep="")
mlo <- paste(obs,"mlomm.co",sep="")
kum <- paste(obs,"kummm.co",sep="")
gmi <- paste(obs,"gmimm.co",sep="")
rpb <- paste(obs,"rpbmm.co",sep="")
chr <- paste(obs,"chrmm.co",sep="")
mkn <- paste(obs,"mknmm.co",sep="")
#bkt <- paste(obs,"bktmm.co",sep="")
sey <- paste(obs,"seymm.co",sep="")
asc <- paste(obs,"ascmm.co",sep="")
smo <- paste(obs,"smomm.co",sep="")
#nmb <- paste(obs,"nmbmm.co",sep="")
eic <- paste(obs,"eicmm.co",sep="")
cgo <- paste(obs,"cgomm.co",sep="")
crz <- paste(obs,"crzmm.co",sep="")
tdf <- paste(obs,"tdfmm.co",sep="")
psa <- paste(obs,"psamm.co",sep="")
syo <- paste(obs,"syomm.co",sep="")
hba <- paste(obs,"hbamm.co",sep="")
spo <- paste(obs,"spomm.co",sep="")


# extract co from regions using converted grid cell co-ords
alt.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$alt$mLon,stations$alt$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
alt.co = read.table(alt, skip = 36, header=F)

brw.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$brw$mLon,stations$brw$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
brw.co = read.table(brw, skip = 36, header=F)

mhd.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$mhd$mLon,stations$mhd$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
mhd.co = read.table(mhd, skip = 36, header=F)

lef.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$lef$mLon,stations$lef$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
lef.co = read.table(lef, skip = 36, header=F)

nwr.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$nwr$mLon,stations$nwr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
nwr.co = read.table(nwr, skip = 36, header=F)

tap.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$tap$mLon,stations$tap$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
tap.co = read.table(tap, skip = 36, header=F)

goz.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$goz$mLon,stations$goz$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
goz.co = read.table(goz, skip = 36, header=F)

key.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$key$mLon,stations$key$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
key.co = read.table(key, skip = 36, header=F)

mlo.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$mlo$mLon,stations$mlo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
mlo.co = read.table(mlo, skip = 36, header=F)

rpb.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$rpb$mLon,stations$rpb$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
rpb.co = read.table(rpb, skip = 36, header=F)

chr.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$chr$mLon,stations$chr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
chr.co = read.table(chr, skip = 36, header=F)

asc.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$asc$mLon,stations$asc$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
asc.co = read.table(asc, skip = 36, header=F)

smo.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$smo$mLon,stations$smo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
smo.co = read.table(smo, skip = 36, header=F)

eic.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$eic$mLon,stations$eic$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
eic.co = read.table(eic, skip = 36, header=F)

cgo.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$cgo$mLon,stations$cgo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
cgo.co = read.table(cgo, skip = 36, header=F)

crz.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$crz$mLon,stations$crz$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
crz.co = read.table(crz, skip = 36, header=F)

syo.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$syo$mLon,stations$syo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
syo.co = read.table(syo, skip = 36, header=F)

spo.mod1 = (get.var.ncdf(nc1,co.code,start=c(stations$spo$mLon,stations$spo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
spo.co = read.table(spo, skip = 36, header=F)

# extract co from regions using converted grid cell co-ords
alt.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$alt$mLon,stations$alt$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
brw.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$brw$mLon,stations$brw$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
mhd.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$mhd$mLon,stations$mhd$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
lef.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$lef$mLon,stations$lef$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
nwr.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$nwr$mLon,stations$nwr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
tap.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$tap$mLon,stations$tap$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
goz.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$goz$mLon,stations$goz$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
key.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$key$mLon,stations$key$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
mlo.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$mlo$mLon,stations$mlo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
rpb.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$rpb$mLon,stations$rpb$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
chr.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$chr$mLon,stations$chr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
asc.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$asc$mLon,stations$asc$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
smo.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$smo$mLon,stations$smo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
eic.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$eic$mLon,stations$eic$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
cgo.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$cgo$mLon,stations$cgo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
crz.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$crz$mLon,stations$crz$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
syo.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$syo$mLon,stations$syo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
spo.mod2 = (get.var.ncdf(nc2,co.code,start=c(stations$spo$mLon,stations$spo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)

# extract co from regions using converted grid cell co-ords
alt.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$alt$mLon,stations$alt$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
brw.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$brw$mLon,stations$brw$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
mhd.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$mhd$mLon,stations$mhd$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
lef.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$lef$mLon,stations$lef$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
nwr.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$nwr$mLon,stations$nwr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
tap.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$tap$mLon,stations$tap$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
goz.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$goz$mLon,stations$goz$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
key.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$key$mLon,stations$key$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
mlo.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$mlo$mLon,stations$mlo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
rpb.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$rpb$mLon,stations$rpb$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
chr.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$chr$mLon,stations$chr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
asc.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$asc$mLon,stations$asc$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
smo.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$smo$mLon,stations$smo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
eic.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$eic$mLon,stations$eic$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
cgo.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$cgo$mLon,stations$cgo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
crz.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$crz$mLon,stations$crz$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
syo.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$syo$mLon,stations$syo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)
spo.mod3 = (get.var.ncdf(nc3,co.code,start=c(stations$spo$mLon,stations$spo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.co)

#convert time format in obs to something R likes..
#create a monthly mean climatology from all data (not need at LEAST 12 months of data..)
alt.co$date = paste(alt.co$V2, alt.co$V3, 01)
alt.co$date = as.POSIXct(strptime(alt.co$date, format = "%Y %m %d"))
alt.mean = aggregate(alt.co["V4"], format(alt.co["date"], "%m"), mean, na.rm=T) 
alt.sdev = aggregate(alt.co["V4"], format(alt.co["date"], "%m"), sd, na.rm=T) 
alt.clim = alt.mean$V4
alt.sd = alt.sdev$V4

brw.co$date = paste(brw.co$V2, brw.co$V3, 01)
brw.co$date = as.POSIXct(strptime(brw.co$date, format = "%Y %m %d"))
brw.mean = aggregate(brw.co["V4"], format(brw.co["date"], "%m"), mean, na.rm=T) 
brw.sdev = aggregate(brw.co["V4"], format(brw.co["date"], "%m"), sd, na.rm=T) 
brw.clim = brw.mean$V4
brw.sd = brw.sdev$V4

mhd.co$date = paste(mhd.co$V2, mhd.co$V3, 01)
mhd.co$date = as.POSIXct(strptime(mhd.co$date, format = "%Y %m %d"))
mhd.mean = aggregate(mhd.co["V4"], format(mhd.co["date"], "%m"), mean, na.rm=T) 
mhd.sdev = aggregate(mhd.co["V4"], format(mhd.co["date"], "%m"), sd, na.rm=T) 
mhd.clim = mhd.mean$V4
mhd.sd = mhd.sdev$V4

lef.co$date = paste(lef.co$V2, lef.co$V3, 01)
lef.co$date = as.POSIXct(strptime(lef.co$date, format = "%Y %m %d"))
lef.mean = aggregate(lef.co["V4"], format(lef.co["date"], "%m"), mean, na.rm=T) 
lef.sdev = aggregate(lef.co["V4"], format(lef.co["date"], "%m"), sd, na.rm=T) 
lef.clim = lef.mean$V4
lef.sd = lef.sdev$V4

nwr.co$date = paste(nwr.co$V2, nwr.co$V3, 01)
nwr.co$date = as.POSIXct(strptime(nwr.co$date, format = "%Y %m %d"))
nwr.mean = aggregate(nwr.co["V4"], format(nwr.co["date"], "%m"), mean, na.rm=T) 
nwr.sdev = aggregate(nwr.co["V4"], format(nwr.co["date"], "%m"), sd, na.rm=T) 
nwr.clim = nwr.mean$V4
nwr.sd = nwr.sdev$V4

tap.co$date = paste(tap.co$V2, tap.co$V3, 01)
tap.co$date = as.POSIXct(strptime(tap.co$date, format = "%Y %m %d"))
tap.mean = aggregate(tap.co["V4"], format(tap.co["date"], "%m"), mean, na.rm=T) 
tap.sdev = aggregate(tap.co["V4"], format(tap.co["date"], "%m"), sd, na.rm=T) 
tap.clim = tap.mean$V4
tap.sd = tap.sdev$V4

goz.co$date = paste(goz.co$V2, goz.co$V3, 01)
goz.co$date = as.POSIXct(strptime(goz.co$date, format = "%Y %m %d"))
goz.mean = aggregate(goz.co["V4"], format(goz.co["date"], "%m"), mean, na.rm=T) 
goz.sdev = aggregate(goz.co["V4"], format(goz.co["date"], "%m"), sd, na.rm=T) 
goz.clim = goz.mean$V4
goz.sd = goz.sdev$V4

key.co$date = paste(key.co$V2, key.co$V3, 01)
key.co$date = as.POSIXct(strptime(key.co$date, format = "%Y %m %d"))
key.mean = aggregate(key.co["V4"], format(key.co["date"], "%m"), mean, na.rm=T) 
key.sdev = aggregate(key.co["V4"], format(key.co["date"], "%m"), sd, na.rm=T) 
key.clim = key.mean$V4
key.sd = key.sdev$V4

mlo.co$date = paste(mlo.co$V2, mlo.co$V3, 01)
mlo.co$date = as.POSIXct(strptime(mlo.co$date, format = "%Y %m %d"))
mlo.mean = aggregate(mlo.co["V4"], format(mlo.co["date"], "%m"), mean, na.rm=T) 
mlo.sdev = aggregate(mlo.co["V4"], format(mlo.co["date"], "%m"), sd, na.rm=T) 
mlo.clim = mlo.mean$V4
mlo.sd = mlo.sdev$V4

rpb.co$date = paste(rpb.co$V2, rpb.co$V3, 01)
rpb.co$date = as.POSIXct(strptime(rpb.co$date, format = "%Y %m %d"))
rpb.mean = aggregate(rpb.co["V4"], format(rpb.co["date"], "%m"), mean, na.rm=T) 
rpb.sdev = aggregate(rpb.co["V4"], format(rpb.co["date"], "%m"), sd, na.rm=T) 
rpb.clim = rpb.mean$V4
rpb.sd = rpb.sdev$V4

chr.co$date = paste(chr.co$V2, chr.co$V3, 01)
chr.co$date = as.POSIXct(strptime(chr.co$date, format = "%Y %m %d"))
chr.mean = aggregate(chr.co["V4"], format(chr.co["date"], "%m"), mean, na.rm=T) 
chr.sdev = aggregate(chr.co["V4"], format(chr.co["date"], "%m"), sd, na.rm=T) 
chr.clim = chr.mean$V4
chr.sd = chr.sdev$V4

asc.co$date = paste(asc.co$V2, asc.co$V3, 01)
asc.co$date = as.POSIXct(strptime(asc.co$date, format = "%Y %m %d"))
asc.mean = aggregate(asc.co["V4"], format(asc.co["date"], "%m"), mean, na.rm=T) 
asc.sdev = aggregate(asc.co["V4"], format(asc.co["date"], "%m"), sd, na.rm=T) 
asc.clim = asc.mean$V4
asc.sd = asc.sdev$V4

smo.co$date = paste(smo.co$V2, smo.co$V3, 01)
smo.co$date = as.POSIXct(strptime(smo.co$date, format = "%Y %m %d"))
smo.mean = aggregate(smo.co["V4"], format(smo.co["date"], "%m"), mean, na.rm=T) 
smo.sdev = aggregate(smo.co["V4"], format(smo.co["date"], "%m"), sd, na.rm=T) 
smo.clim = smo.mean$V4
smo.sd = smo.sdev$V4

eic.co$date = paste(eic.co$V2, eic.co$V3, 01)
eic.co$date = as.POSIXct(strptime(eic.co$date, format = "%Y %m %d"))
eic.mean = aggregate(eic.co["V4"], format(eic.co["date"], "%m"), mean, na.rm=T) 
eic.sdev = aggregate(eic.co["V4"], format(eic.co["date"], "%m"), sd, na.rm=T) 
eic.clim = eic.mean$V4
eic.sd = eic.sdev$V4

cgo.co$date = paste(cgo.co$V2, cgo.co$V3, 01)
cgo.co$date = as.POSIXct(strptime(cgo.co$date, format = "%Y %m %d"))
cgo.mean = aggregate(cgo.co["V4"], format(cgo.co["date"], "%m"), mean, na.rm=T) 
cgo.sdev = aggregate(cgo.co["V4"], format(cgo.co["date"], "%m"), sd, na.rm=T) 
cgo.clim = cgo.mean$V4
cgo.sd = cgo.sdev$V4

crz.co$date = paste(crz.co$V2, crz.co$V3, 01)
crz.co$date = as.POSIXct(strptime(crz.co$date, format = "%Y %m %d"))
crz.mean = aggregate(crz.co["V4"], format(crz.co["date"], "%m"), mean, na.rm=T) 
crz.sdev = aggregate(crz.co["V4"], format(crz.co["date"], "%m"), sd, na.rm=T) 
crz.clim = crz.mean$V4
crz.sd = crz.sdev$V4

syo.co$date = paste(syo.co$V2, syo.co$V3, 01)
syo.co$date = as.POSIXct(strptime(syo.co$date, format = "%Y %m %d"))
syo.mean = aggregate(syo.co["V4"], format(syo.co["date"], "%m"), mean, na.rm=T) 
syo.sdev = aggregate(syo.co["V4"], format(syo.co["date"], "%m"), sd, na.rm=T) 
syo.clim = syo.mean$V4
syo.sd = syo.sdev$V4

spo.co$date = paste(spo.co$V2, spo.co$V3, 01)
spo.co$date = as.POSIXct(strptime(spo.co$date, format = "%Y %m %d"))
spo.mean = aggregate(spo.co["V4"], format(spo.co["date"], "%m"), mean, na.rm=T) 
spo.sdev = aggregate(spo.co["V4"], format(spo.co["date"], "%m"), sd, na.rm=T) 
spo.clim = spo.mean$V4
spo.sd = spo.sdev$V4


# calc stats
# correlation
mod1.cor.alt <- cor(alt.clim,alt.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.brw <- cor(brw.clim,brw.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.mhd <- cor(mhd.clim,mhd.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.lef <- cor(lef.clim,lef.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.nwr <- cor(nwr.clim,nwr.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.tap <- cor(tap.clim,tap.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.goz <- cor(goz.clim,goz.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.key <- cor(key.clim,key.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.mlo <- cor(mlo.clim,mlo.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.rpb <- cor(rpb.clim,rpb.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.chr <- cor(chr.clim,chr.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.asc <- cor(asc.clim,asc.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.smo <- cor(smo.clim,smo.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.eic <- cor(eic.clim,eic.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.cgo <- cor(cgo.clim,cgo.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.crz <- cor(crz.clim,crz.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.syo <- cor(syo.clim,syo.mod1,use="pairwise.complete.obs",method="pearson")
mod1.cor.spo <- cor(spo.clim,spo.mod1,use="pairwise.complete.obs",method="pearson")
mod2.cor.alt <- cor(alt.clim,alt.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.brw <- cor(brw.clim,brw.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.mhd <- cor(mhd.clim,mhd.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.lef <- cor(lef.clim,lef.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.nwr <- cor(nwr.clim,nwr.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.tap <- cor(tap.clim,tap.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.goz <- cor(goz.clim,goz.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.key <- cor(key.clim,key.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.mlo <- cor(mlo.clim,mlo.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.rpb <- cor(rpb.clim,rpb.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.chr <- cor(chr.clim,chr.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.asc <- cor(asc.clim,asc.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.smo <- cor(smo.clim,smo.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.eic <- cor(eic.clim,eic.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.cgo <- cor(cgo.clim,cgo.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.crz <- cor(crz.clim,crz.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.syo <- cor(syo.clim,syo.mod2,use="pairwise.complete.obs",method="pearson")
mod2.cor.spo <- cor(spo.clim,spo.mod2,use="pairwise.complete.obs",method="pearson")
mod3.cor.alt <- cor(alt.clim,alt.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.brw <- cor(brw.clim,brw.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.mhd <- cor(mhd.clim,mhd.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.lef <- cor(lef.clim,lef.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.nwr <- cor(nwr.clim,nwr.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.tap <- cor(tap.clim,tap.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.goz <- cor(goz.clim,goz.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.key <- cor(key.clim,key.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.mlo <- cor(mlo.clim,mlo.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.rpb <- cor(rpb.clim,rpb.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.chr <- cor(chr.clim,chr.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.asc <- cor(asc.clim,asc.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.smo <- cor(smo.clim,smo.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.eic <- cor(eic.clim,eic.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.cgo <- cor(cgo.clim,cgo.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.crz <- cor(crz.clim,crz.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.syo <- cor(syo.clim,syo.mod3,use="pairwise.complete.obs",method="pearson")
mod3.cor.spo <- cor(spo.clim,spo.mod3,use="pairwise.complete.obs",method="pearson")

# mean bias error:
M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=alt.mod1[k]-(alt.clim[k]) }
mod1.MBE.alt=(sum(M)/12)/(sum(alt.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=brw.mod1[k]-(brw.clim[k]) }
mod1.MBE.brw=(sum(M)/12)/(sum(brw.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mhd.mod1[k]-(mhd.clim[k]) }
mod1.MBE.mhd=(sum(M)/12)/(sum(mhd.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=lef.mod1[k]-(lef.clim[k]) }
mod1.MBE.lef=(sum(M)/12)/(sum(lef.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=nwr.mod1[k]-(nwr.clim[k]) }
mod1.MBE.nwr=(sum(M)/12)/(sum(nwr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=tap.mod1[k]-(tap.clim[k]) }
mod1.MBE.tap=(sum(M)/12)/(sum(tap.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=goz.mod1[k]-(goz.clim[k]) }
mod1.MBE.goz=(sum(M)/12)/(sum(goz.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=key.mod1[k]-(key.clim[k]) }
mod1.MBE.key=(sum(M)/12)/(sum(key.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mlo.mod1[k]-(mlo.clim[k]) }
mod1.MBE.mlo=(sum(M)/12)/(sum(mlo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=rpb.mod1[k]-(rpb.clim[k]) }
mod1.MBE.rpb=(sum(M)/12)/(sum(rpb.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=chr.mod1[k]-(chr.clim[k]) }
mod1.MBE.chr=(sum(M)/12)/(sum(chr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=asc.mod1[k]-(asc.clim[k]) }
mod1.MBE.asc=(sum(M)/12)/(sum(asc.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=smo.mod1[k]-(smo.clim[k]) }
mod1.MBE.smo=(sum(M)/12)/(sum(smo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=eic.mod1[k]-(eic.clim[k]) }
mod1.MBE.eic=(sum(M)/12)/(sum(eic.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=cgo.mod1[k]-(cgo.clim[k]) }
mod1.MBE.cgo=(sum(M)/12)/(sum(cgo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=crz.mod1[k]-(crz.clim[k]) }
mod1.MBE.crz=(sum(M)/12)/(sum(crz.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=syo.mod1[k]-(syo.clim[k]) }
mod1.MBE.syo=(sum(M)/12)/(sum(syo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=spo.mod1[k]-(spo.clim[k]) }
mod1.MBE.spo=(sum(M)/12)/(sum(spo.clim)/12)*100

# mean bias error:
M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=alt.mod2[k]-(alt.clim[k]) }
mod2.MBE.alt=(sum(M)/12)/(sum(alt.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=brw.mod2[k]-(brw.clim[k]) }
mod2.MBE.brw=(sum(M)/12)/(sum(brw.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mhd.mod2[k]-(mhd.clim[k]) }
mod2.MBE.mhd=(sum(M)/12)/(sum(mhd.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=lef.mod2[k]-(lef.clim[k]) }
mod2.MBE.lef=(sum(M)/12)/(sum(lef.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=nwr.mod2[k]-(nwr.clim[k]) }
mod2.MBE.nwr=(sum(M)/12)/(sum(nwr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=tap.mod2[k]-(tap.clim[k]) }
mod2.MBE.tap=(sum(M)/12)/(sum(tap.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=goz.mod2[k]-(goz.clim[k]) }
mod2.MBE.goz=(sum(M)/12)/(sum(goz.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=key.mod2[k]-(key.clim[k]) }
mod2.MBE.key=(sum(M)/12)/(sum(key.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mlo.mod2[k]-(mlo.clim[k]) }
mod2.MBE.mlo=(sum(M)/12)/(sum(mlo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=rpb.mod2[k]-(rpb.clim[k]) }
mod2.MBE.rpb=(sum(M)/12)/(sum(rpb.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=chr.mod2[k]-(chr.clim[k]) }
mod2.MBE.chr=(sum(M)/12)/(sum(chr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=asc.mod2[k]-(asc.clim[k]) }
mod2.MBE.asc=(sum(M)/12)/(sum(asc.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=smo.mod2[k]-(smo.clim[k]) }
mod2.MBE.smo=(sum(M)/12)/(sum(smo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=eic.mod2[k]-(eic.clim[k]) }
mod2.MBE.eic=(sum(M)/12)/(sum(eic.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=cgo.mod2[k]-(cgo.clim[k]) }
mod2.MBE.cgo=(sum(M)/12)/(sum(cgo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=crz.mod2[k]-(crz.clim[k]) }
mod2.MBE.crz=(sum(M)/12)/(sum(crz.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=syo.mod2[k]-(syo.clim[k]) }
mod2.MBE.syo=(sum(M)/12)/(sum(syo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=spo.mod2[k]-(spo.clim[k]) }
mod2.MBE.spo=(sum(M)/12)/(sum(spo.clim)/12)*100

# mean bias error:
M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=alt.mod3[k]-(alt.clim[k]) }
mod3.MBE.alt=(sum(M)/12)/(sum(alt.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=brw.mod3[k]-(brw.clim[k]) }
mod3.MBE.brw=(sum(M)/12)/(sum(brw.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mhd.mod3[k]-(mhd.clim[k]) }
mod3.MBE.mhd=(sum(M)/12)/(sum(mhd.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=lef.mod3[k]-(lef.clim[k]) }
mod3.MBE.lef=(sum(M)/12)/(sum(lef.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=nwr.mod3[k]-(nwr.clim[k]) }
mod3.MBE.nwr=(sum(M)/12)/(sum(nwr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=tap.mod3[k]-(tap.clim[k]) }
mod3.MBE.tap=(sum(M)/12)/(sum(tap.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=goz.mod3[k]-(goz.clim[k]) }
mod3.MBE.goz=(sum(M)/12)/(sum(goz.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=key.mod3[k]-(key.clim[k]) }
mod3.MBE.key=(sum(M)/12)/(sum(key.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mlo.mod3[k]-(mlo.clim[k]) }
mod3.MBE.mlo=(sum(M)/12)/(sum(mlo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=rpb.mod3[k]-(rpb.clim[k]) }
mod3.MBE.rpb=(sum(M)/12)/(sum(rpb.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=chr.mod3[k]-(chr.clim[k]) }
mod3.MBE.chr=(sum(M)/12)/(sum(chr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=asc.mod3[k]-(asc.clim[k]) }
mod3.MBE.asc=(sum(M)/12)/(sum(asc.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=smo.mod3[k]-(smo.clim[k]) }
mod3.MBE.smo=(sum(M)/12)/(sum(smo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=eic.mod3[k]-(eic.clim[k]) }
mod3.MBE.eic=(sum(M)/12)/(sum(eic.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=cgo.mod3[k]-(cgo.clim[k]) }
mod3.MBE.cgo=(sum(M)/12)/(sum(cgo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=crz.mod3[k]-(crz.clim[k]) }
mod3.MBE.crz=(sum(M)/12)/(sum(crz.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=syo.mod3[k]-(syo.clim[k]) }
mod3.MBE.syo=(sum(M)/12)/(sum(syo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=spo.mod3[k]-(spo.clim[k]) }
mod3.MBE.spo=(sum(M)/12)/(sum(spo.clim)/12)*100


# ==========================================================================================
# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

#plot data
pdf(file=paste(out.dir, mod1.name, "_", mod2.name, "_", mod3.name,  "_CMDL_CO_comparison.pdf", sep=""),width=14,height=21,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.6,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:18, 6, 3, byrow = TRUE))

#plot 
plot(alt.clim,ylim=c(0,200), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Alert (82.4N, 62.5W, 210m)")
arrows( 1:12, ((alt.clim)-2*(alt.sd)),  1:12, ((alt.clim)+2*(alt.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(alt.mod1,type="o",lwd=2.0,col="red")
points(alt.mod2,type="o",lwd=2.0,col="blue")
points(alt.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.alt)," MBE = ", sprintf("%1.3g", mod1.MBE.alt), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.alt)," MBE = ", sprintf("%1.3g", mod2.MBE.alt), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.alt)," MBE = ", sprintf("%1.3g", mod3.MBE.alt), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(brw.clim,ylim=c(0,250), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Barrow (71.3N, 156.6W, 11m)") 
arrows( 1:12, ((brw.clim)-2*(brw.sd)),  1:12, ((brw.clim)+2*(brw.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(brw.mod1,type="o",lwd=2.0,col="red")
points(brw.mod2,type="o",lwd=2.0,col="blue")
points(brw.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.brw)," MBE = ", sprintf("%1.3g", mod1.MBE.brw), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.brw)," MBE = ", sprintf("%1.3g", mod2.MBE.brw), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.brw)," MBE = ", sprintf("%1.3g", mod3.MBE.brw), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(mhd.clim,ylim=c(0,200), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Mace Head (53.3N, 9.9W, 25m)") 
arrows( 1:12, ((mhd.clim)-2*(mhd.sd)),  1:12, ((mhd.clim)+2*(mhd.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mhd.mod1,type="o",lwd=2.0,col="red")
points(mhd.mod2,type="o",lwd=2.0,col="blue")
points(mhd.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.mhd)," MBE = ", sprintf("%1.3g", mod1.MBE.mhd), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.mhd)," MBE = ", sprintf("%1.3g", mod2.MBE.mhd), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.mhd)," MBE = ", sprintf("%1.3g", mod3.MBE.mhd), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(lef.clim,ylim=c(0,350), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Park Falls (45.9N, 90.2W, 472m)") 
arrows( 1:12, ((lef.clim)-2*(lef.sd)),  1:12, ((lef.clim)+2*(lef.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(lef.mod1,type="o",lwd=2.0,col="red")
points(lef.mod2,type="o",lwd=2.0,col="blue")
points(lef.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.lef)," MBE = ", sprintf("%1.3g", mod1.MBE.lef), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.lef)," MBE = ", sprintf("%1.3g", mod2.MBE.lef), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.lef)," MBE = ", sprintf("%1.3g", mod3.MBE.lef), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(nwr.clim,ylim=c(0,200), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Niwot Ridge (40.0N, 105.6W, 3475m)") 
arrows( 1:12, ((nwr.clim)-2*(nwr.sd)),  1:12, ((nwr.clim)+2*(nwr.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(nwr.mod1,type="o",lwd=2.0,col="red")
points(nwr.mod2,type="o",lwd=2.0,col="blue")
points(nwr.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.nwr)," MBE = ", sprintf("%1.3g", mod1.MBE.nwr), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.nwr)," MBE = ", sprintf("%1.3g", mod2.MBE.nwr), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.nwr)," MBE = ", sprintf("%1.3g", mod3.MBE.nwr), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(tap.clim,ylim=c(0,350), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Tae-ahn Peninsula (36.7N, 126.1E, 20m)") 
arrows( 1:12, ((tap.clim)-2*(tap.sd)),  1:12, ((tap.clim)+2*(tap.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(tap.mod1,type="o",lwd=2.0,col="red")
points(tap.mod2,type="o",lwd=2.0,col="blue")
points(tap.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.tap)," MBE = ", sprintf("%1.3g", mod1.MBE.tap), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.tap)," MBE = ", sprintf("%1.3g", mod2.MBE.tap), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.tap)," MBE = ", sprintf("%1.3g", mod3.MBE.tap), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(goz.clim,ylim=c(0,250), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Gozo (36.0N, 14.1E)") 
arrows( 1:12, ((goz.clim)-2*(goz.sd)),  1:12, ((goz.clim)+2*(goz.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(goz.mod1,type="o",lwd=2.0,col="red")
points(goz.mod2,type="o",lwd=2.0,col="blue")
points(goz.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.goz)," MBE = ", sprintf("%1.3g", mod1.MBE.goz), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.goz)," MBE = ", sprintf("%1.3g", mod2.MBE.goz), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.goz)," MBE = ", sprintf("%1.3g", mod3.MBE.goz), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(key.clim,ylim=c(0,200), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Key Biscayne (25.7N, 80.2W, 3m)") 
arrows( 1:12, ((key.clim)-2*(key.sd)),  1:12, ((key.clim)+2*(key.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(key.mod1,type="o",lwd=2.0,col="red")
points(key.mod2,type="o",lwd=2.0,col="blue")
points(key.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.key)," MBE = ", sprintf("%1.3g", mod1.MBE.key), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.key)," MBE = ", sprintf("%1.3g", mod2.MBE.key), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.key)," MBE = ", sprintf("%1.3g", mod3.MBE.key), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(mlo.clim,ylim=c(0,150), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Mauna Loa (19.5N, 155.6W, 3397m)") 
arrows( 1:12, ((mlo.clim)-2*(mlo.sd)),  1:12, ((mlo.clim)+2*(mlo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mlo.mod1,type="o",lwd=2.0,col="red")
points(mlo.mod2,type="o",lwd=2.0,col="blue")
points(mlo.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.mlo)," MBE = ", sprintf("%1.3g", mod1.MBE.mlo), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.mlo)," MBE = ", sprintf("%1.3g", mod2.MBE.mlo), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.mlo)," MBE = ", sprintf("%1.3g", mod3.MBE.mlo), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(rpb.clim,ylim=c(0,150), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Ragged Point (13.2N, 59.4W, 45m)") 
arrows( 1:12, ((rpb.clim)-2*(rpb.sd)),  1:12, ((rpb.clim)+2*(rpb.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(rpb.mod1,type="o",lwd=2.0,col="red")
points(rpb.mod2,type="o",lwd=2.0,col="blue")
points(rpb.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.rpb)," MBE = ", sprintf("%1.3g", mod1.MBE.rpb), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.rpb)," MBE = ", sprintf("%1.3g", mod2.MBE.rpb), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.rpb)," MBE = ", sprintf("%1.3g", mod3.MBE.rpb), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(chr.clim,ylim=c(0,150), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Christmas Island (1.7N, 157.2W, 3m)") 
arrows( 1:12, ((chr.clim)-2*(chr.sd)),  1:12, ((chr.clim)+2*(chr.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(chr.mod1,type="o",lwd=2.0,col="red")
points(chr.mod2,type="o",lwd=2.0,col="blue")
points(chr.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.chr)," MBE = ", sprintf("%1.3g", mod1.MBE.chr), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.chr)," MBE = ", sprintf("%1.3g", mod2.MBE.chr), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.chr)," MBE = ", sprintf("%1.3g", mod3.MBE.chr), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(asc.clim,ylim=c(0,150), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Ascension Island (7.9S, 14.4W, 54m)") 
arrows( 1:12, ((asc.clim)-2*(asc.sd)),  1:12, ((asc.clim)+2*(asc.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(asc.mod1,type="o",lwd=2.0,col="red")
points(asc.mod2,type="o",lwd=2.0,col="blue")
points(asc.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",, c(paste("r = ",sprintf("%1.3g", mod1.cor.asc)," MBE = ", sprintf("%1.3g", mod1.MBE.asc), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.asc)," MBE = ", sprintf("%1.3g", mod2.MBE.asc), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.asc)," MBE = ", sprintf("%1.3g", mod3.MBE.asc), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(smo.clim,ylim=c(0,100), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Samoa (14.2S, 170.5W, 42m)") 
arrows( 1:12, ((smo.clim)-2*(smo.sd)),  1:12, ((smo.clim)+2*(smo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(smo.mod1,type="o",lwd=2.0,col="red")
points(smo.mod2,type="o",lwd=2.0,col="blue")
points(smo.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft", c(paste("r = ",sprintf("%1.3g", mod1.cor.smo)," MBE = ", sprintf("%1.3g", mod1.MBE.smo), "%", sep=""), 
paste("r = ",sprintf("%1.3g", mod2.cor.smo)," MBE = ", sprintf("%1.3g", mod2.MBE.smo), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.smo)," MBE = ", sprintf("%1.3g", mod3.MBE.smo), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(eic.clim,ylim=c(0,100), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Easter Island (27.1S, 109.4W, 50m)") 
arrows( 1:12, ((eic.clim)-2*(eic.sd)),  1:12, ((eic.clim)+2*(eic.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(eic.mod1,type="o",lwd=2.0,col="red")
points(eic.mod2,type="o",lwd=2.0,col="blue")
points(eic.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft", c(paste("r = ",sprintf("%1.3g", mod1.cor.eic)," MBE = ", sprintf("%1.3g", mod1.MBE.eic), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.eic)," MBE = ", sprintf("%1.3g", mod2.MBE.eic), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.eic)," MBE = ", sprintf("%1.3g", mod3.MBE.eic), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(cgo.clim,ylim=c(0,100), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Cape Grim (40.7S, 144.7E, 94m)") 
arrows( 1:12, ((cgo.clim)-2*(cgo.sd)),  1:12, ((cgo.clim)+2*(cgo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(cgo.mod1,type="o",lwd=2.0,col="red")
points(cgo.mod2,type="o",lwd=2.0,col="blue")
points(cgo.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft", c(paste("r = ",sprintf("%1.3g", mod1.cor.cgo)," MBE = ", sprintf("%1.3g", mod1.MBE.cgo), "%", sep=""), 
paste("r = ",sprintf("%1.3g", mod2.cor.cgo)," MBE = ", sprintf("%1.3g", mod2.MBE.cgo), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.cgo)," MBE = ", sprintf("%1.3g", mod3.MBE.cgo), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(crz.clim,ylim=c(0,80), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Crozet Island (46.5S, 51.8E, 120m)") 
arrows( 1:12, ((crz.clim)-2*(crz.sd)),  1:12, ((crz.clim)+2*(crz.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(crz.mod1,type="o",lwd=2.0,col="red")
points(crz.mod2,type="o",lwd=2.0,col="blue")
points(crz.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft", c(paste("r = ",sprintf("%1.3g", mod1.cor.crz)," MBE = ", sprintf("%1.3g", mod1.MBE.crz), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod2.cor.crz)," MBE = ", sprintf("%1.3g", mod2.MBE.crz), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.crz)," MBE = ", sprintf("%1.3g", mod3.MBE.crz), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(syo.clim,ylim=c(0,80), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="Syowa Station (69.0S, 39.6E, 11m)") 
arrows( 1:12, ((syo.clim)-2*(syo.sd)),  1:12, ((syo.clim)+2*(syo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(syo.mod1,type="o",lwd=2.0,col="red")
points(syo.mod2,type="o",lwd=2.0,col="blue")
points(syo.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft",  c(paste("r = ",sprintf("%1.3g", mod1.cor.syo)," MBE = ", sprintf("%1.3g", mod1.MBE.syo), "%", sep=""), 
paste("r = ",sprintf("%1.3g", mod2.cor.syo)," MBE = ", sprintf("%1.3g", mod2.MBE.syo), "%", sep=""),
paste("r = ",sprintf("%1.3g", mod3.cor.syo)," MBE = ", sprintf("%1.3g", mod3.MBE.syo), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )

plot(spo.clim,ylim=c(0,80), ylab="CO (ppbv)", xlab="Month", xaxt="n", type="o", lwd=2.0,  cex.main=0.9, main="South Pole (90.0S, 24.8W, 2810m)") 
arrows( 1:12, ((spo.clim)-2*(spo.sd)),  1:12, ((spo.clim)+2*(spo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(spo.mod1,type="o",lwd=2.0,col="red")
points(spo.mod2,type="o",lwd=2.0,col="blue")
points(spo.mod3,type="o",lwd=2.0,col="green")
grid()
legend("bottomleft", c(paste("r = ",sprintf("%1.3g", mod1.cor.spo)," MBE = ", sprintf("%1.3g", mod1.MBE.spo), "%", sep=""), 
paste("r = ",sprintf("%1.3g", mod2.cor.spo)," MBE = ", sprintf("%1.3g", mod2.MBE.spo), "%", sep=""), 
paste("r = ",sprintf("%1.3g", mod3.cor.spo)," MBE = ", sprintf("%1.3g", mod3.MBE.spo), "%", sep="")), cex=0.6, text.col=c("red","blue","green"), bty="n" )


dev.off()



