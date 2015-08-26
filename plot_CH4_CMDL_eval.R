# R script to read in CMDL CO data (compiled a la PJY - THANKS!)
# and overplot model data.

# Alex Archibald, June, 2012

# constants and loop vars
conv <- 1E9

# Open station code file
fields <- read.csv(paste(obs.dir, "CMDL/co_station_order.csv", sep=""))

# calc del lon and lats
del.lon <- get.var.ncdf(nc1, "longitude")[2] - get.var.ncdf(nc1, "longitude")[1]
del.lat <- get.var.ncdf(nc1, "latitude")[2] - get.var.ncdf(nc1, "latitude")[1]
lon <- get.var.ncdf(nc1, "longitude")
lat <- get.var.ncdf(nc1, "latitude")

# convert "real" lats and longs to model grid boxes
fields$mLat <- (round (  ((fields$Lat +90)/del.lat)  ))+1
fields$mLon <- ifelse ( fields$Lon<0, (round( ((fields$Lon+360)/del.lon)-0.5))+1, (round( ((fields$Lon/del.lon)-0.5) ))+1  )

# use split to convert the fields data frame into a series of data frames split by the
# CMDL code
stations <- split(fields[], fields$Code)

#open measurments
obs <- paste(obs.dir, "CMDL/ch4/month/", sep="")
alt <- paste(obs,"ch4_","alt_surface-flask_1_ccgg_month.txt",sep="")
zep <- paste(obs,"ch4_","zep_surface-flask_1_ccgg_month.txt",sep="")
mbc <- paste(obs,"ch4_","mbc_surface-flask_1_ccgg_month.txt",sep="")
sum <- paste(obs,"ch4_","sum_surface-flask_1_ccgg_month.txt",sep="")
brw <- paste(obs,"ch4_","brw_surface-flask_1_ccgg_month.txt",sep="")
#pal <- paste(obs,"ch4_","pal_surface-flask_1_ccgg_month.txt",sep="")
stm <- paste(obs,"ch4_","stm_surface-flask_1_ccgg_month.txt",sep="")
ice <- paste(obs,"ch4_","ice_surface-flask_1_ccgg_month.txt",sep="")
bal <- paste(obs,"ch4_","bal_surface-flask_1_ccgg_month.txt",sep="")
cba <- paste(obs,"ch4_","cba_surface-flask_1_ccgg_month.txt",sep="")
#obn <- paste(obs,"ch4_","obn_surface-flask_1_ccgg_month.txt",sep="")
mhd <- paste(obs,"ch4_","mhd_surface-flask_1_ccgg_month.txt",sep="")
shm <- paste(obs,"ch4_","shm_surface-flask_1_ccgg_month.txt",sep="")
#oxk <- paste(obs,"ch4_","oxk_surface-flask_1_ccgg_month.txt",sep="")
#opw <- paste(obs,"ch4_","opw_surface-flask_1_ccgg_month.txt",sep="")
hun <- paste(obs,"ch4_","hun_surface-flask_1_ccgg_month.txt",sep="")
#lef <- paste(obs,"ch4_","lef_surface-flask_1_ccgg_month.txt",sep="")
cmo <- paste(obs,"ch4_","cmo_surface-flask_1_ccgg_month.txt",sep="")
#amt <- paste(obs,"ch4_","amt_surface-flask_1_ccgg_month.txt",sep="")
kzd <- paste(obs,"ch4_","kzd_surface-flask_1_ccgg_month.txt",sep="")
uum <- paste(obs,"ch4_","uum_surface-flask_1_ccgg_month.txt",sep="")
bsc <- paste(obs,"ch4_","bsc_surface-flask_1_ccgg_month.txt",sep="")
kzm <- paste(obs,"ch4_","kzm_surface-flask_1_ccgg_month.txt",sep="")
#thd <- paste(obs,"ch4_","thd_surface-flask_1_ccgg_month.txt",sep="")
nwr <- paste(obs,"ch4_","nwr_surface-flask_1_ccgg_month.txt",sep="")
uta <- paste(obs,"ch4_","uta_surface-flask_1_ccgg_month.txt",sep="")
pta <- paste(obs,"ch4_","pta_surface-flask_1_ccgg_month.txt",sep="")
azr <- paste(obs,"ch4_","azr_surface-flask_1_ccgg_month.txt",sep="")
#sgp <- paste(obs,"ch4_","sgp_surface-flask_1_ccgg_month.txt",sep="")
tap <- paste(obs,"ch4_","tap_surface-flask_1_ccgg_month.txt",sep="")
wlg <- paste(obs,"ch4_","wlg_surface-flask_1_ccgg_month.txt",sep="")
goz <- paste(obs,"ch4_","goz_surface-flask_1_ccgg_month.txt",sep="")
itn <- paste(obs,"ch4_","itn_surface-flask_1_ccgg_month.txt",sep="")
bme <- paste(obs,"ch4_","bme_surface-flask_1_ccgg_month.txt",sep="")
bmw <- paste(obs,"ch4_","bmw_surface-flask_1_ccgg_month.txt",sep="")
#wkt <- paste(obs,"ch4_","wkt_surface-flask_1_ccgg_month.txt",sep="")
wis <- paste(obs,"ch4_","wis_surface-flask_1_ccgg_month.txt",sep="")
izo <- paste(obs,"ch4_","izo_surface-flask_1_ccgg_month.txt",sep="")
mid <- paste(obs,"ch4_","mid_surface-flask_1_ccgg_month.txt",sep="")
key <- paste(obs,"ch4_","key_surface-flask_1_ccgg_month.txt",sep="")
ask <- paste(obs,"ch4_","ask_surface-flask_1_ccgg_month.txt",sep="")
mlo <- paste(obs,"ch4_","mlo_surface-flask_1_ccgg_month.txt",sep="")
kum <- paste(obs,"ch4_","kum_surface-flask_1_ccgg_month.txt",sep="")
gmi <- paste(obs,"ch4_","gmi_surface-flask_1_ccgg_month.txt",sep="")
rpb <- paste(obs,"ch4_","rpb_surface-flask_1_ccgg_month.txt",sep="")
chr <- paste(obs,"ch4_","chr_surface-flask_1_ccgg_month.txt",sep="")
mkn <- paste(obs,"ch4_","mkn_surface-flask_1_ccgg_month.txt",sep="")
#bkt <- paste(obs,"ch4_","bkt_surface-flask_1_ccgg_month.txt",sep="")
sey <- paste(obs,"ch4_","sey_surface-flask_1_ccgg_month.txt",sep="")
asc <- paste(obs,"ch4_","asc_surface-flask_1_ccgg_month.txt",sep="")
smo <- paste(obs,"ch4_","smo_surface-flask_1_ccgg_month.txt",sep="")
nmb <- paste(obs,"ch4_","nmb_surface-flask_1_ccgg_month.txt",sep="")
eic <- paste(obs,"ch4_","eic_surface-flask_1_ccgg_month.txt",sep="")
cgo <- paste(obs,"ch4_","cgo_surface-flask_1_ccgg_month.txt",sep="")
crz <- paste(obs,"ch4_","crz_surface-flask_1_ccgg_month.txt",sep="")
tdf <- paste(obs,"ch4_","tdf_surface-flask_1_ccgg_month.txt",sep="")
psa <- paste(obs,"ch4_","psa_surface-flask_1_ccgg_month.txt",sep="")
syo <- paste(obs,"ch4_","syo_surface-flask_1_ccgg_month.txt",sep="")
hba <- paste(obs,"ch4_","hba_surface-flask_1_ccgg_month.txt",sep="")
spo <- paste(obs,"ch4_","spo_surface-flask_1_ccgg_month.txt",sep="")


# extract co from regions using converted grid cell co-ords
alt.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$alt$mLon,stations$alt$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
alt.ch4 = read.table(alt, header=F)

brw.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$brw$mLon,stations$brw$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
brw.ch4 = read.table(brw, header=F)

mhd.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$mhd$mLon,stations$mhd$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
mhd.ch4 = read.table(mhd, header=F)

#lef.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$lef$mLon,stations$lef$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
#lef.ch4 = read.table(lef, header=F)

nwr.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$nwr$mLon,stations$nwr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
nwr.ch4 = read.table(nwr, header=F)

tap.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$tap$mLon,stations$tap$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
tap.ch4 = read.table(tap, header=F)

wlg.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$wlg$mLon,stations$wlg$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
wlg.ch4 = read.table(wlg, header=F)

key.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$key$mLon,stations$key$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
key.ch4 = read.table(key, header=F)

mlo.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$mlo$mLon,stations$mlo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
mlo.ch4 = read.table(mlo, header=F)

rpb.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$rpb$mLon,stations$rpb$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
rpb.ch4 = read.table(rpb, header=F)

chr.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$chr$mLon,stations$chr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
chr.ch4 = read.table(chr, header=F)

asc.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$asc$mLon,stations$asc$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
asc.ch4 = read.table(asc, header=F)

smo.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$smo$mLon,stations$smo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
smo.ch4 = read.table(smo, header=F)

eic.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$eic$mLon,stations$eic$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
eic.ch4 = read.table(eic, header=F)

cgo.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$cgo$mLon,stations$cgo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
cgo.ch4 = read.table(cgo, header=F)

crz.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$crz$mLon,stations$crz$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
crz.ch4 = read.table(crz, header=F)

syo.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$syo$mLon,stations$syo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
syo.ch4 = read.table(syo, header=F)

spo.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$spo$mLon,stations$spo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
spo.ch4 = read.table(spo, header=F)

# convert time format in obs to something R likes..
# create a monthly mean climatology from all data (not need at LEAST 12 months of data..)
# add start and end dates to subset the data
start.date = as.POSIXct("2000-01-01")
end.date = as.POSIXct("2010-01-01")

alt.ch4$date = paste(alt.ch4$V2, alt.ch4$V3, 01)
alt.ch4$date = as.POSIXct(strptime(alt.ch4$date, format = "%Y %m %d"))
alt.ch4 = subset(alt.ch4, date >= start.date & date <= end.date)
alt.mean = aggregate(alt.ch4["V4"], format(alt.ch4["date"], "%m"), mean, na.rm=T) 
alt.sdev = aggregate(alt.ch4["V4"], format(alt.ch4["date"], "%m"), sd, na.rm=T) 
alt.clim = alt.mean$V4
alt.sd = alt.sdev$V4

brw.ch4$date = paste(brw.ch4$V2, brw.ch4$V3, 01)
brw.ch4$date = as.POSIXct(strptime(brw.ch4$date, format = "%Y %m %d"))
brw.ch4 = subset(brw.ch4, date >= start.date & date <= end.date)
brw.mean = aggregate(brw.ch4["V4"], format(brw.ch4["date"], "%m"), mean, na.rm=T) 
brw.sdev = aggregate(brw.ch4["V4"], format(brw.ch4["date"], "%m"), sd, na.rm=T) 
brw.clim = brw.mean$V4
brw.sd = brw.sdev$V4

mhd.ch4$date = paste(mhd.ch4$V2, mhd.ch4$V3, 01)
mhd.ch4$date = as.POSIXct(strptime(mhd.ch4$date, format = "%Y %m %d"))
mhd.ch4 = subset(mhd.ch4, date >= start.date & date <= end.date)
mhd.mean = aggregate(mhd.ch4["V4"], format(mhd.ch4["date"], "%m"), mean, na.rm=T) 
mhd.sdev = aggregate(mhd.ch4["V4"], format(mhd.ch4["date"], "%m"), sd, na.rm=T) 
mhd.clim = mhd.mean$V4
mhd.sd = mhd.sdev$V4

#lef.ch4$date = paste(lef.ch4$V2, lef.ch4$V3, 01)
#lef.ch4$date = as.POSIXct(strptime(lef.ch4$date, format = "%Y %m %d"))
#lef.mean = aggregate(lef.ch4["V4"], format(lef.ch4["date"], "%m"), mean, na.rm=T) 
#lef.sdev = aggregate(lef.ch4["V4"], format(lef.ch4["date"], "%m"), sd, na.rm=T) 
#lef.clim = lef.mean$V4
#lef.sd = lef.sdev$V4

nwr.ch4$date = paste(nwr.ch4$V2, nwr.ch4$V3, 01)
nwr.ch4$date = as.POSIXct(strptime(nwr.ch4$date, format = "%Y %m %d"))
nwr.ch4 = subset(nwr.ch4, date >= start.date & date <= end.date)
nwr.mean = aggregate(nwr.ch4["V4"], format(nwr.ch4["date"], "%m"), mean, na.rm=T) 
nwr.sdev = aggregate(nwr.ch4["V4"], format(nwr.ch4["date"], "%m"), sd, na.rm=T) 
nwr.clim = nwr.mean$V4
nwr.sd = nwr.sdev$V4

tap.ch4$date = paste(tap.ch4$V2, tap.ch4$V3, 01)
tap.ch4$date = as.POSIXct(strptime(tap.ch4$date, format = "%Y %m %d"))
tap.ch4 = subset(tap.ch4, date >= start.date & date <= end.date)
tap.mean = aggregate(tap.ch4["V4"], format(tap.ch4["date"], "%m"), mean, na.rm=T) 
tap.sdev = aggregate(tap.ch4["V4"], format(tap.ch4["date"], "%m"), sd, na.rm=T) 
tap.clim = tap.mean$V4
tap.sd = tap.sdev$V4

wlg.ch4$date = paste(wlg.ch4$V2, wlg.ch4$V3, 01)
wlg.ch4$date = as.POSIXct(strptime(wlg.ch4$date, format = "%Y %m %d"))
wlg.ch4 = subset(wlg.ch4, date >= start.date & date <= end.date)
wlg.mean = aggregate(wlg.ch4["V4"], format(wlg.ch4["date"], "%m"), mean, na.rm=T) 
wlg.sdev = aggregate(wlg.ch4["V4"], format(wlg.ch4["date"], "%m"), sd, na.rm=T) 
wlg.clim = wlg.mean$V4
wlg.sd = wlg.sdev$V4

key.ch4$date = paste(key.ch4$V2, key.ch4$V3, 01)
key.ch4$date = as.POSIXct(strptime(key.ch4$date, format = "%Y %m %d"))
key.ch4 = subset(key.ch4, date >= start.date & date <= end.date)
key.mean = aggregate(key.ch4["V4"], format(key.ch4["date"], "%m"), mean, na.rm=T) 
key.sdev = aggregate(key.ch4["V4"], format(key.ch4["date"], "%m"), sd, na.rm=T) 
key.clim = key.mean$V4
key.sd = key.sdev$V4

mlo.ch4$date = paste(mlo.ch4$V2, mlo.ch4$V3, 01)
mlo.ch4$date = as.POSIXct(strptime(mlo.ch4$date, format = "%Y %m %d"))
mlo.ch4 = subset(mlo.ch4, date >= start.date & date <= end.date)
mlo.mean = aggregate(mlo.ch4["V4"], format(mlo.ch4["date"], "%m"), mean, na.rm=T) 
mlo.sdev = aggregate(mlo.ch4["V4"], format(mlo.ch4["date"], "%m"), sd, na.rm=T) 
mlo.clim = mlo.mean$V4
mlo.sd = mlo.sdev$V4

rpb.ch4$date = paste(rpb.ch4$V2, rpb.ch4$V3, 01)
rpb.ch4$date = as.POSIXct(strptime(rpb.ch4$date, format = "%Y %m %d"))
rpb.ch4 = subset(rpb.ch4, date >= start.date & date <= end.date)
rpb.mean = aggregate(rpb.ch4["V4"], format(rpb.ch4["date"], "%m"), mean, na.rm=T) 
rpb.sdev = aggregate(rpb.ch4["V4"], format(rpb.ch4["date"], "%m"), sd, na.rm=T) 
rpb.clim = rpb.mean$V4
rpb.sd = rpb.sdev$V4

chr.ch4$date = paste(chr.ch4$V2, chr.ch4$V3, 01)
chr.ch4$date = as.POSIXct(strptime(chr.ch4$date, format = "%Y %m %d"))
chr.ch4 = subset(chr.ch4, date >= start.date & date <= end.date)
chr.mean = aggregate(chr.ch4["V4"], format(chr.ch4["date"], "%m"), mean, na.rm=T) 
chr.sdev = aggregate(chr.ch4["V4"], format(chr.ch4["date"], "%m"), sd, na.rm=T) 
chr.clim = chr.mean$V4
chr.sd = chr.sdev$V4

asc.ch4$date = paste(asc.ch4$V2, asc.ch4$V3, 01)
asc.ch4$date = as.POSIXct(strptime(asc.ch4$date, format = "%Y %m %d"))
asc.ch4 = subset(asc.ch4, date >= start.date & date <= end.date)
asc.mean = aggregate(asc.ch4["V4"], format(asc.ch4["date"], "%m"), mean, na.rm=T) 
asc.sdev = aggregate(asc.ch4["V4"], format(asc.ch4["date"], "%m"), sd, na.rm=T) 
asc.clim = asc.mean$V4
asc.sd = asc.sdev$V4

smo.ch4$date = paste(smo.ch4$V2, smo.ch4$V3, 01)
smo.ch4$date = as.POSIXct(strptime(smo.ch4$date, format = "%Y %m %d"))
smo.ch4 = subset(smo.ch4, date >= start.date & date <= end.date)
smo.mean = aggregate(smo.ch4["V4"], format(smo.ch4["date"], "%m"), mean, na.rm=T) 
smo.sdev = aggregate(smo.ch4["V4"], format(smo.ch4["date"], "%m"), sd, na.rm=T) 
smo.clim = smo.mean$V4
smo.sd = smo.sdev$V4

eic.ch4$date = paste(eic.ch4$V2, eic.ch4$V3, 01)
eic.ch4$date = as.POSIXct(strptime(eic.ch4$date, format = "%Y %m %d"))
eic.ch4 = subset(eic.ch4, date >= start.date & date <= end.date)
eic.mean = aggregate(eic.ch4["V4"], format(eic.ch4["date"], "%m"), mean, na.rm=T) 
eic.sdev = aggregate(eic.ch4["V4"], format(eic.ch4["date"], "%m"), sd, na.rm=T) 
eic.clim = eic.mean$V4
eic.sd = eic.sdev$V4

cgo.ch4$date = paste(cgo.ch4$V2, cgo.ch4$V3, 01)
cgo.ch4$date = as.POSIXct(strptime(cgo.ch4$date, format = "%Y %m %d"))
cgo.ch4 = subset(cgo.ch4, date >= start.date & date <= end.date)
cgo.mean = aggregate(cgo.ch4["V4"], format(cgo.ch4["date"], "%m"), mean, na.rm=T) 
cgo.sdev = aggregate(cgo.ch4["V4"], format(cgo.ch4["date"], "%m"), sd, na.rm=T) 
cgo.clim = cgo.mean$V4
cgo.sd = cgo.sdev$V4

crz.ch4$date = paste(crz.ch4$V2, crz.ch4$V3, 01)
crz.ch4$date = as.POSIXct(strptime(crz.ch4$date, format = "%Y %m %d"))
crz.ch4 = subset(crz.ch4, date >= start.date & date <= end.date)
crz.mean = aggregate(crz.ch4["V4"], format(crz.ch4["date"], "%m"), mean, na.rm=T) 
crz.sdev = aggregate(crz.ch4["V4"], format(crz.ch4["date"], "%m"), sd, na.rm=T) 
crz.clim = crz.mean$V4
crz.sd = crz.sdev$V4

syo.ch4$date = paste(syo.ch4$V2, syo.ch4$V3, 01)
syo.ch4$date = as.POSIXct(strptime(syo.ch4$date, format = "%Y %m %d"))
syo.ch4 = subset(syo.ch4, date >= start.date & date <= end.date)
syo.mean = aggregate(syo.ch4["V4"], format(syo.ch4["date"], "%m"), mean, na.rm=T) 
syo.sdev = aggregate(syo.ch4["V4"], format(syo.ch4["date"], "%m"), sd, na.rm=T) 
syo.clim = syo.mean$V4
syo.sd = syo.sdev$V4

spo.ch4$date = paste(spo.ch4$V2, spo.ch4$V3, 01)
spo.ch4$date = as.POSIXct(strptime(spo.ch4$date, format = "%Y %m %d"))
spo.ch4 = subset(spo.ch4, date >= start.date & date <= end.date)
spo.mean = aggregate(spo.ch4["V4"], format(spo.ch4["date"], "%m"), mean, na.rm=T) 
spo.sdev = aggregate(spo.ch4["V4"], format(spo.ch4["date"], "%m"), sd, na.rm=T) 
spo.clim = spo.mean$V4
spo.sd = spo.sdev$V4


# calc stats
# correlation
cor.alt <- cor(alt.clim,alt.mod1,use="pairwise.complete.obs",method="pearson")
cor.brw <- cor(brw.clim,brw.mod1,use="pairwise.complete.obs",method="pearson")
cor.mhd <- cor(mhd.clim,mhd.mod1,use="pairwise.complete.obs",method="pearson")
#cor.lef <- cor(lef.clim,lef.mod1,use="pairwise.complete.obs",method="pearson")
cor.nwr <- cor(nwr.clim,nwr.mod1,use="pairwise.complete.obs",method="pearson")
cor.tap <- cor(tap.clim,tap.mod1,use="pairwise.complete.obs",method="pearson")
cor.wlg <- cor(wlg.clim,wlg.mod1,use="pairwise.complete.obs",method="pearson")
cor.key <- cor(key.clim,key.mod1,use="pairwise.complete.obs",method="pearson")
cor.mlo <- cor(mlo.clim,mlo.mod1,use="pairwise.complete.obs",method="pearson")
cor.rpb <- cor(rpb.clim,rpb.mod1,use="pairwise.complete.obs",method="pearson")
cor.chr <- cor(chr.clim,chr.mod1,use="pairwise.complete.obs",method="pearson")
cor.asc <- cor(asc.clim,asc.mod1,use="pairwise.complete.obs",method="pearson")
cor.smo <- cor(smo.clim,smo.mod1,use="pairwise.complete.obs",method="pearson")
cor.eic <- cor(eic.clim,eic.mod1,use="pairwise.complete.obs",method="pearson")
cor.cgo <- cor(cgo.clim,cgo.mod1,use="pairwise.complete.obs",method="pearson")
cor.crz <- cor(crz.clim,crz.mod1,use="pairwise.complete.obs",method="pearson")
cor.syo <- cor(syo.clim,syo.mod1,use="pairwise.complete.obs",method="pearson")
cor.spo <- cor(spo.clim,spo.mod1,use="pairwise.complete.obs",method="pearson")

# mean bias error:
M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=alt.mod1[k]-(alt.clim[k]) }
MBE.alt=(sum(M)/12)/(sum(alt.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=brw.mod1[k]-(brw.clim[k]) }
MBE.brw=(sum(M)/12)/(sum(brw.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mhd.mod1[k]-(mhd.clim[k]) }
MBE.mhd=(sum(M)/12)/(sum(mhd.clim)/12)*100

#M<-array(0,dim=c(12))
#for (k in 1:12){
#M[k]=lef.mod1[k]-(lef.clim[k]) }
#MBE.lef=(sum(M)/12)/(sum(lef.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=nwr.mod1[k]-(nwr.clim[k]) }
MBE.nwr=(sum(M)/12)/(sum(nwr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=tap.mod1[k]-(tap.clim[k]) }
MBE.tap=(sum(M)/12)/(sum(tap.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=wlg.mod1[k]-(wlg.clim[k]) }
MBE.wlg=(sum(M)/12)/(sum(wlg.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=key.mod1[k]-(key.clim[k]) }
MBE.key=(sum(M)/12)/(sum(key.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mlo.mod1[k]-(mlo.clim[k]) }
MBE.mlo=(sum(M)/12)/(sum(mlo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=rpb.mod1[k]-(rpb.clim[k]) }
MBE.rpb=(sum(M)/12)/(sum(rpb.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=chr.mod1[k]-(chr.clim[k]) }
MBE.chr=(sum(M)/12)/(sum(chr.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=asc.mod1[k]-(asc.clim[k]) }
MBE.asc=(sum(M)/12)/(sum(asc.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=smo.mod1[k]-(smo.clim[k]) }
MBE.smo=(sum(M)/12)/(sum(smo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=eic.mod1[k]-(eic.clim[k]) }
MBE.eic=(sum(M)/12)/(sum(eic.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=cgo.mod1[k]-(cgo.clim[k]) }
MBE.cgo=(sum(M)/12)/(sum(cgo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=crz.mod1[k]-(crz.clim[k]) }
MBE.crz=(sum(M)/12)/(sum(crz.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=syo.mod1[k]-(syo.clim[k]) }
MBE.syo=(sum(M)/12)/(sum(syo.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=spo.mod1[k]-(spo.clim[k]) }
MBE.spo=(sum(M)/12)/(sum(spo.clim)/12)*100

# ==========================================================================================
# ######## Additional stations -- not used in CO analysis ################################ #
# ######## These are included in the full_comparison to help with analys ################# #

zep.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$zep$mLon,stations$zep$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
zep.ch4 = read.table(zep, header=F)

zep.ch4$date = paste(zep.ch4$V2, zep.ch4$V3, 01)
zep.ch4$date = as.POSIXct(strptime(zep.ch4$date, format = "%Y %m %d"))
zep.ch4 = subset(zep.ch4, date >= start.date & date <= end.date)
zep.mean = aggregate(zep.ch4["V4"], format(zep.ch4["date"], "%m"), mean, na.rm=T) 
zep.sdev = aggregate(zep.ch4["V4"], format(zep.ch4["date"], "%m"), sd, na.rm=T) 
zep.clim = zep.mean$V4
zep.sd = zep.sdev$V4

cor.zep <- cor(zep.clim,zep.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=zep.mod1[k]-(zep.clim[k]) }
MBE.zep=(sum(M)/12)/(sum(zep.clim)/12)*100

sum.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$sum$mLon,stations$sum$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
sum.ch4 = read.table(sum, header=F)

sum.ch4$date = paste(sum.ch4$V2, sum.ch4$V3, 01)
sum.ch4$date = as.POSIXct(strptime(sum.ch4$date, format = "%Y %m %d"))
sum.ch4 = subset(sum.ch4, date >= start.date & date <= end.date)
sum.mean = aggregate(sum.ch4["V4"], format(sum.ch4["date"], "%m"), mean, na.rm=T) 
sum.sdev = aggregate(sum.ch4["V4"], format(sum.ch4["date"], "%m"), sd, na.rm=T) 
sum.clim = sum.mean$V4
sum.sd = sum.sdev$V4

cor.sum <- cor(sum.clim,sum.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=sum.mod1[k]-(sum.clim[k]) }
MBE.sum=(sum(M)/12)/(sum(sum.clim)/12)*100

wis.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$wis$mLon,stations$wis$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
wis.ch4 = read.table(wis, header=F)

wis.ch4$date = paste(wis.ch4$V2, wis.ch4$V3, 01)
wis.ch4$date = as.POSIXct(strptime(wis.ch4$date, format = "%Y %m %d"))
wis.ch4 = subset(wis.ch4, date >= start.date & date <= end.date)
wis.mean = aggregate(wis.ch4["V4"], format(wis.ch4["date"], "%m"), mean, na.rm=T) 
wis.sdev = aggregate(wis.ch4["V4"], format(wis.ch4["date"], "%m"), sd, na.rm=T) 
wis.clim = wis.mean$V4
wis.sd = wis.sdev$V4

cor.wis <- cor(wis.clim,wis.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=wis.mod1[k]-(wis.clim[k]) }
MBE.wis=(sum(M)/12)/(sum(wis.clim)/12)*100


bal.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$bal$mLon,stations$bal$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
bal.ch4 = read.table(bal, header=F)

bal.ch4$date = paste(bal.ch4$V2, bal.ch4$V3, 01)
bal.ch4$date = as.POSIXct(strptime(bal.ch4$date, format = "%Y %m %d"))
bal.ch4 = subset(bal.ch4, date >= start.date & date <= end.date)
bal.mean = aggregate(bal.ch4["V4"], format(bal.ch4["date"], "%m"), mean, na.rm=T) 
bal.sdev = aggregate(bal.ch4["V4"], format(bal.ch4["date"], "%m"), sd, na.rm=T) 
bal.clim = bal.mean$V4
bal.sd = bal.sdev$V4

cor.bal <- cor(bal.clim,bal.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=bal.mod1[k]-(bal.clim[k]) }
MBE.bal=(sum(M)/12)/(sum(bal.clim)/12)*100

azr.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$azr$mLon,stations$azr$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
azr.ch4 = read.table(azr, header=F)

azr.ch4$date = paste(azr.ch4$V2, azr.ch4$V3, 01)
azr.ch4$date = as.POSIXct(strptime(azr.ch4$date, format = "%Y %m %d"))
azr.ch4 = subset(azr.ch4, date >= start.date & date <= end.date)
azr.mean = aggregate(azr.ch4["V4"], format(azr.ch4["date"], "%m"), mean, na.rm=T) 
azr.sdev = aggregate(azr.ch4["V4"], format(azr.ch4["date"], "%m"), sd, na.rm=T) 
azr.clim = azr.mean$V4
azr.sd = azr.sdev$V4

cor.azr <- cor(azr.clim,azr.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=azr.mod1[k]-(azr.clim[k]) }
MBE.azr=(sum(M)/12)/(sum(azr.clim)/12)*100

uta.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$uta$mLon,stations$uta$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
uta.ch4 = read.table(uta, header=F)

uta.ch4$date = paste(uta.ch4$V2, uta.ch4$V3, 01)
uta.ch4$date = as.POSIXct(strptime(uta.ch4$date, format = "%Y %m %d"))
uta.ch4 = subset(uta.ch4, date >= start.date & date <= end.date)
uta.mean = aggregate(uta.ch4["V4"], format(uta.ch4["date"], "%m"), mean, na.rm=T) 
uta.sdev = aggregate(uta.ch4["V4"], format(uta.ch4["date"], "%m"), sd, na.rm=T) 
uta.clim = uta.mean$V4
uta.sd = uta.sdev$V4

cor.uta <- cor(uta.clim,uta.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=uta.mod1[k]-(uta.clim[k]) }
MBE.uta=(sum(M)/12)/(sum(uta.clim)/12)*100

uum.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$uum$mLon,stations$uum$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
uum.ch4 = read.table(uum, header=F)

uum.ch4$date = paste(uum.ch4$V2, uum.ch4$V3, 01)
uum.ch4$date = as.POSIXct(strptime(uum.ch4$date, format = "%Y %m %d"))
uum.ch4 = subset(uum.ch4, date >= start.date & date <= end.date)
uum.mean = aggregate(uum.ch4["V4"], format(uum.ch4["date"], "%m"), mean, na.rm=T) 
uum.sdev = aggregate(uum.ch4["V4"], format(uum.ch4["date"], "%m"), sd, na.rm=T) 
uum.clim = uum.mean$V4
uum.sd = uum.sdev$V4

cor.uum <- cor(uum.clim,uum.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=uum.mod1[k]-(uum.clim[k]) }
MBE.uum=(sum(M)/12)/(sum(uum.clim)/12)*100

izo.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$izo$mLon,stations$izo$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
izo.ch4 = read.table(izo, header=F)

izo.ch4$date = paste(izo.ch4$V2, izo.ch4$V3, 01)
izo.ch4$date = as.POSIXct(strptime(izo.ch4$date, format = "%Y %m %d"))
izo.ch4 = subset(izo.ch4, date >= start.date & date <= end.date)
izo.mean = aggregate(izo.ch4["V4"], format(izo.ch4["date"], "%m"), mean, na.rm=T) 
izo.sdev = aggregate(izo.ch4["V4"], format(izo.ch4["date"], "%m"), sd, na.rm=T) 
izo.clim = izo.mean$V4
izo.sd = izo.sdev$V4

cor.izo <- cor(izo.clim,izo.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=izo.mod1[k]-(izo.clim[k]) }
MBE.izo=(sum(M)/12)/(sum(izo.clim)/12)*100

ice.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$ice$mLon,stations$ice$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
ice.ch4 = read.table(ice, header=F)

ice.ch4$date = paste(ice.ch4$V2, ice.ch4$V3, 01)
ice.ch4$date = as.POSIXct(strptime(ice.ch4$date, format = "%Y %m %d"))
ice.ch4 = subset(ice.ch4, date >= start.date & date <= end.date)
ice.mean = aggregate(ice.ch4["V4"], format(ice.ch4["date"], "%m"), mean, na.rm=T) 
ice.sdev = aggregate(ice.ch4["V4"], format(ice.ch4["date"], "%m"), sd, na.rm=T) 
ice.clim = ice.mean$V4
ice.sd = ice.sdev$V4

cor.ice <- cor(ice.clim,ice.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=ice.mod1[k]-(ice.clim[k]) }
MBE.ice=(sum(M)/12)/(sum(ice.clim)/12)*100

sey.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$sey$mLon,stations$sey$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
sey.ch4 = read.table(sey, header=F)

sey.ch4$date = paste(sey.ch4$V2, sey.ch4$V3, 01)
sey.ch4$date = as.POSIXct(strptime(sey.ch4$date, format = "%Y %m %d"))
sey.ch4 = subset(sey.ch4, date >= start.date & date <= end.date)
sey.mean = aggregate(sey.ch4["V4"], format(sey.ch4["date"], "%m"), mean, na.rm=T) 
sey.sdev = aggregate(sey.ch4["V4"], format(sey.ch4["date"], "%m"), sd, na.rm=T) 
sey.clim = sey.mean$V4
sey.sd = sey.sdev$V4

cor.sey <- cor(sey.clim,sey.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=sey.mod1[k]-(sey.clim[k]) }
MBE.sey=(sum(M)/12)/(sum(sey.clim)/12)*100

mid.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$mid$mLon,stations$mid$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
mid.ch4 = read.table(mid, header=F)

mid.ch4$date = paste(mid.ch4$V2, mid.ch4$V3, 01)
mid.ch4$date = as.POSIXct(strptime(mid.ch4$date, format = "%Y %m %d"))
mid.ch4 = subset(mid.ch4, date >= start.date & date <= end.date)
mid.mean = aggregate(mid.ch4["V4"], format(mid.ch4["date"], "%m"), mean, na.rm=T) 
mid.sdev = aggregate(mid.ch4["V4"], format(mid.ch4["date"], "%m"), sd, na.rm=T) 
mid.clim = mid.mean$V4
mid.sd = mid.sdev$V4

cor.mid <- cor(mid.clim,mid.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mid.mod1[k]-(mid.clim[k]) }
MBE.mid=(sum(M)/12)/(sum(mid.clim)/12)*100

tdf.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$tdf$mLon,stations$tdf$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
tdf.ch4 = read.table(tdf, header=F)

tdf.ch4$date = paste(tdf.ch4$V2, tdf.ch4$V3, 01)
tdf.ch4$date = as.POSIXct(strptime(tdf.ch4$date, format = "%Y %m %d"))
tdf.ch4 = subset(tdf.ch4, date >= start.date & date <= end.date)
tdf.mean = aggregate(tdf.ch4["V4"], format(tdf.ch4["date"], "%m"), mean, na.rm=T) 
tdf.sdev = aggregate(tdf.ch4["V4"], format(tdf.ch4["date"], "%m"), sd, na.rm=T) 
tdf.clim = tdf.mean$V4
tdf.sd = tdf.sdev$V4

cor.tdf <- cor(tdf.clim,tdf.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=tdf.mod1[k]-(tdf.clim[k]) }
MBE.tdf=(sum(M)/12)/(sum(tdf.clim)/12)*100

nmb.mod1 = (get.var.ncdf(nc1,ch4.code,start=c(stations$nmb$mLon,stations$nmb$mLat,1,1),count=c(1,1,1,12)))*(conv/mm.ch4)
nmb.ch4 = read.table(nmb, header=F)

nmb.ch4$date = paste(nmb.ch4$V2, nmb.ch4$V3, 01)
nmb.ch4$date = as.POSIXct(strptime(nmb.ch4$date, format = "%Y %m %d"))
nmb.ch4 = subset(nmb.ch4, date >= start.date & date <= end.date)
nmb.mean = aggregate(nmb.ch4["V4"], format(nmb.ch4["date"], "%m"), mean, na.rm=T) 
nmb.sdev = aggregate(nmb.ch4["V4"], format(nmb.ch4["date"], "%m"), sd, na.rm=T) 
nmb.clim = nmb.mean$V4
nmb.sd = nmb.sdev$V4

cor.nmb <- cor(nmb.clim,nmb.mod1,use="pairwise.complete.obs",method="pearson")

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=nmb.mod1[k]-(nmb.clim[k]) }
MBE.nmb=(sum(M)/12)/(sum(nmb.clim)/12)*100

# ==========================================================================================
# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

# plot data NB FULL DATA SETS
pdf(file=paste(out.dir, mod1.name, "_CMDL_CH4_full_comparison.pdf", sep=""),width=14,height=21,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.6,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:18, 6, 3, byrow = TRUE))

#plot 
plot(alt.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Alert (82.4N, 62.5W, 210m)")
arrows( 1:12, ((alt.clim)-2*(alt.sd)),  1:12, ((alt.clim)+2*(alt.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(alt.mod1,type="o",col="red")
grid()
legend("topleft", mod1.name, lwd=1, col="red", bty="n")
text(6,1950, c(paste("r = ",sprintf("%1.3g", cor.alt)," MBE = ", sprintf("%1.3g", MBE.alt), "%", sep="")), cex=0.9)

plot(zep.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Zepplin (78.9N, 11.9E, 474m)")
arrows( 1:12, ((zep.clim)-2*(zep.sd)),  1:12, ((zep.clim)+2*(zep.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(zep.mod1,type="o",col="red")
grid()
text(6,1950, c(paste("r = ",sprintf("%1.3g", cor.zep)," MBE = ", sprintf("%1.3g", MBE.zep), "%", sep="")), cex=0.9)

plot(sum.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Summit (72.6N, 38.4W, 3209m)")
arrows( 1:12, ((sum.clim)-2*(sum.sd)),  1:12, ((sum.clim)+2*(sum.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(sum.mod1,type="o",col="red")
grid()
text(6,1950, c(paste("r = ",sprintf("%1.3g", cor.sum)," MBE = ", sprintf("%1.3g", MBE.sum), "%", sep="")), cex=0.9)

plot(brw.clim,ylim=c(1750,2050), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Barrow (71.3N, 156.6W, 11m)") 
arrows( 1:12, ((brw.clim)-2*(brw.sd)),  1:12, ((brw.clim)+2*(brw.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(brw.mod1,type="o",col="red")
grid()
text(6,2050, c(paste("r = ",sprintf("%1.3g", cor.brw)," MBE = ", sprintf("%1.3g", MBE.brw), "%", sep="")), cex=0.9)

plot(ice.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Iceland (63.4N, 20.3W, 118m)")
arrows( 1:12, ((ice.clim)-2*(ice.sd)),  1:12, ((ice.clim)+2*(ice.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(ice.mod1,type="o",col="red")
grid()
text(6,1950, c(paste("r = ",sprintf("%1.3g", cor.ice)," MBE = ", sprintf("%1.3g", MBE.ice), "%", sep="")), cex=0.9)

plot(bal.clim,ylim=c(1800,2050), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Baltic Sea (55.4N, 17.2E, 3m)")
arrows( 1:12, ((bal.clim)-2*(bal.sd)),  1:12, ((bal.clim)+2*(bal.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(bal.mod1,type="o",col="red")
grid()
text(6,2050, c(paste("r = ",sprintf("%1.3g", cor.bal)," MBE = ", sprintf("%1.3g", MBE.bal), "%", sep="")), cex=0.9)

plot(mhd.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mace Head (53.3N, 9.9W, 25m)") 
arrows( 1:12, ((mhd.clim)-2*(mhd.sd)),  1:12, ((mhd.clim)+2*(mhd.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mhd.mod1,type="o",col="red")
grid()
text(6,1950, c(paste("r = ",sprintf("%1.3g", cor.mhd)," MBE = ", sprintf("%1.3g", MBE.mhd), "%", sep="")), cex=0.9)

#plot(lef.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Park Falls (45.9N, 90.2W, 472m)") 
#arrows( 1:12, ((lef.clim)-2*(lef.sd)),  1:12, ((lef.clim)+2*(lef.sd)), length = 0.0, code =2 )
#axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
#points(lef.mod1,type="o",col="red")
#grid()
#text(6,10, c(paste("r = ",sprintf("%1.3g", cor.lef)," MBE = ", sprintf("%1.3g", MBE.lef), "%", sep="")), cex=0.9)

plot(uum.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Ulaan Uul (44.5N, 111.1E, 1007m)")
arrows( 1:12, ((uum.clim)-2*(uum.sd)),  1:12, ((uum.clim)+2*(uum.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(uum.mod1,type="o",col="red")
grid()
text(6,1950, c(paste("r = ",sprintf("%1.3g", cor.uum)," MBE = ", sprintf("%1.3g", MBE.uum), "%", sep="")), cex=0.9)

plot(nwr.clim,ylim=c(1700,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Niwot Ridge (40.0N, 105.6W, 3475m)") 
arrows( 1:12, ((nwr.clim)-2*(nwr.sd)),  1:12, ((nwr.clim)+2*(nwr.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(nwr.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.nwr)," MBE = ", sprintf("%1.3g", MBE.nwr), "%", sep="")), cex=0.9)

plot(uta.clim,ylim=c(1700,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Utah (39.9N, 113.7W, 1327m)")
arrows( 1:12, ((uta.clim)-2*(uta.sd)),  1:12, ((uta.clim)+2*(uta.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(uta.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.uta)," MBE = ", sprintf("%1.3g", MBE.uta), "%", sep="")), cex=0.9)

plot(azr.clim,ylim=c(1700,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Azores (38.7N, 27.4W, 19m)")
arrows( 1:12, ((azr.clim)-2*(azr.sd)),  1:12, ((azr.clim)+2*(azr.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(azr.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.azr)," MBE = ", sprintf("%1.3g", MBE.azr), "%", sep="")), cex=0.9)

plot(tap.clim,ylim=c(1700,2050), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Tae-ahn Peninsula (36.7N, 126.1E, 20m)") 
arrows( 1:12, ((tap.clim)-2*(tap.sd)),  1:12, ((tap.clim)+2*(tap.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(tap.mod1,type="o",col="red")
grid()
text(6,2050, c(paste("r = ",sprintf("%1.3g", cor.tap)," MBE = ", sprintf("%1.3g", MBE.tap), "%", sep="")), cex=0.9)

plot(wlg.clim,ylim=c(1750,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mt Waliguan (36.3N, 100.9E)") 
arrows( 1:12, ((wlg.clim)-2*(wlg.sd)),  1:12, ((wlg.clim)+2*(wlg.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(wlg.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.wlg)," MBE = ", sprintf("%1.3g", MBE.wlg), "%", sep="")), cex=0.9)

plot(wis.clim,ylim=c(1750,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Israel (30.9N, 34.8E, 477m)")
arrows( 1:12, ((wis.clim)-2*(wis.sd)),  1:12, ((wis.clim)+2*(wis.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(wis.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.wis)," MBE = ", sprintf("%1.3g", MBE.wis), "%", sep="")), cex=0.9)

plot(izo.clim,ylim=c(1750,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Tenerife (28.3N, 16.5W, 2372m)")
arrows( 1:12, ((izo.clim)-2*(izo.sd)),  1:12, ((izo.clim)+2*(izo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(izo.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.izo)," MBE = ", sprintf("%1.3g", MBE.izo), "%", sep="")), cex=0.9)

plot(mid.clim,ylim=c(1700,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Midway (28.1N, 177.8E, 11m)")
arrows( 1:12, ((mid.clim)-2*(mid.sd)),  1:12, ((mid.clim)+2*(mid.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mid.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.mid)," MBE = ", sprintf("%1.3g", MBE.mid), "%", sep="")), cex=0.9)

plot(key.clim,ylim=c(1700,1900), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Key Biscayne (25.7N, 80.2W, 3m)") 
arrows( 1:12, ((key.clim)-2*(key.sd)),  1:12, ((key.clim)+2*(key.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(key.mod1,type="o",col="red")
grid()
text(6,1900, c(paste("r = ",sprintf("%1.3g", cor.key)," MBE = ", sprintf("%1.3g", MBE.key), "%", sep="")), cex=0.9)

plot(mlo.clim,ylim=c(1650,1850), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mauna Loa (19.5N, 155.6W, 3397m)") 
arrows( 1:12, ((mlo.clim)-2*(mlo.sd)),  1:12, ((mlo.clim)+2*(mlo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mlo.mod1,type="o",col="red")
grid()
text(6,1850, c(paste("r = ",sprintf("%1.3g", cor.mlo)," MBE = ", sprintf("%1.3g", MBE.mlo), "%", sep="")), cex=0.9)

plot(rpb.clim,ylim=c(1650,1850), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Ragged Point (13.2N, 59.4W, 45m)") 
arrows( 1:12, ((rpb.clim)-2*(rpb.sd)),  1:12, ((rpb.clim)+2*(rpb.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(rpb.mod1,type="o",col="red")
grid()
text(6,1850, c(paste("r = ",sprintf("%1.3g", cor.rpb)," MBE = ", sprintf("%1.3g", MBE.rpb), "%", sep="")), cex=0.9)

plot(chr.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Christmas Island (1.7N, 157.2W, 3m)") 
arrows( 1:12, ((chr.clim)-2*(chr.sd)),  1:12, ((chr.clim)+2*(chr.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(chr.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.chr)," MBE = ", sprintf("%1.3g", MBE.chr), "%", sep="")), cex=0.9)

plot(sey.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Seychelles (4.7S, 55.5E, 2m)")
arrows( 1:12, ((sey.clim)-2*(sey.sd)),  1:12, ((sey.clim)+2*(sey.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(sey.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.sey)," MBE = ", sprintf("%1.3g", MBE.sey), "%", sep="")), cex=0.9)

plot(asc.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Ascension Island (7.9S, 14.4W, 54m)") 
arrows( 1:12, ((asc.clim)-2*(asc.sd)),  1:12, ((asc.clim)+2*(asc.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(asc.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.asc)," MBE = ", sprintf("%1.3g", MBE.asc), "%", sep="")), cex=0.9)

plot(smo.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Samoa (14.2S, 170.5W, 42m)") 
arrows( 1:12, ((smo.clim)-2*(smo.sd)),  1:12, ((smo.clim)+2*(smo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(smo.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.smo)," MBE = ", sprintf("%1.3g", MBE.smo), "%", sep="")), cex=0.9)

plot(nmb.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Namibia (23.6N, 15.0E, 456m)")
arrows( 1:12, ((nmb.clim)-2*(nmb.sd)),  1:12, ((nmb.clim)+2*(nmb.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(nmb.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.nmb)," MBE = ", sprintf("%1.3g", MBE.nmb), "%", sep="")), cex=0.9)

plot(eic.clim,ylim=c(1600,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Easter Island (27.1S, 109.4W, 50m)") 
arrows( 1:12, ((eic.clim)-2*(eic.sd)),  1:12, ((eic.clim)+2*(eic.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(eic.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.eic)," MBE = ", sprintf("%1.3g", MBE.eic), "%", sep="")), cex=0.9)

plot(cgo.clim,ylim=c(1600,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Cape Grim (40.7S, 144.7E, 94m)") 
arrows( 1:12, ((cgo.clim)-2*(cgo.sd)),  1:12, ((cgo.clim)+2*(cgo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(cgo.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.cgo)," MBE = ", sprintf("%1.3g", MBE.cgo), "%", sep="")), cex=0.9)

plot(crz.clim,ylim=c(1600,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Crozet Island (46.5S, 51.8E, 120m)") 
arrows( 1:12, ((crz.clim)-2*(crz.sd)),  1:12, ((crz.clim)+2*(crz.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(crz.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.crz)," MBE = ", sprintf("%1.3g", MBE.crz), "%", sep="")), cex=0.9)

plot(tdf.clim,ylim=c(1600,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Tierra Del Fuego (54.8S, 68.3W, 12m)")
arrows( 1:12, ((tdf.clim)-2*(tdf.sd)),  1:12, ((tdf.clim)+2*(tdf.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(tdf.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.tdf)," MBE = ", sprintf("%1.3g", MBE.tdf), "%", sep="")), cex=0.9)

plot(syo.clim,ylim=c(1600,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Syowa Station (69.0S, 39.6E, 11m)") 
arrows( 1:12, ((syo.clim)-2*(syo.sd)),  1:12, ((syo.clim)+2*(syo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(syo.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.syo)," MBE = ", sprintf("%1.3g", MBE.syo), "%", sep="")), cex=0.9)

plot(spo.clim,ylim=c(1600,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="South Pole (90.0S, 24.8W, 2810m)") 
arrows( 1:12, ((spo.clim)-2*(spo.sd)),  1:12, ((spo.clim)+2*(spo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(spo.mod1,type="o",col="red")
grid()
text(6,1800, c(paste("r = ",sprintf("%1.3g", cor.spo)," MBE = ", sprintf("%1.3g", MBE.spo), "%", sep="")), cex=0.9)


dev.off()

# ==========================================================================================

# plot comparison between the latitudinal distribution of observed and modelled methane
lats <- c(stations$alt$Lat,
stations$zep$Lat,
stations$sum$Lat,
stations$brw$Lat,
stations$ice$Lat,
stations$bal$Lat,
stations$mhd$Lat,
stations$uum$Lat,
stations$nwr$Lat,
stations$uta$Lat,
stations$azr$Lat,
stations$tap$Lat,
stations$wlg$Lat,
stations$izo$Lat,
stations$mid$Lat,
stations$key$Lat,
stations$mlo$Lat,
stations$rpb$Lat,
stations$sey$Lat,
stations$asc$Lat,
stations$smo$Lat,
stations$eic$Lat,
stations$cgo$Lat,
stations$crz$Lat,
stations$tdf$Lat,
stations$syo$Lat,
stations$spo$Lat)

obs.mean <- c(mean(alt.clim),
mean(zep.clim),
mean(sum.clim),
mean(brw.clim),
mean(ice.clim),
mean(bal.clim),
mean(mhd.clim),
mean(uum.clim),
mean(nwr.clim),
mean(uta.clim),
mean(azr.clim),
mean(tap.clim),
mean(wlg.clim),
mean(izo.clim),
mean(mid.clim),
mean(key.clim),
mean(mlo.clim),
mean(rpb.clim),
mean(sey.clim),
mean(asc.clim),
mean(smo.clim),
mean(eic.clim),
mean(cgo.clim),
mean(crz.clim),
mean(tdf.clim),
mean(syo.clim),
mean(spo.clim))

obs.sd <- c(sd(alt.clim),
sd(zep.clim),
sd(sum.clim),
sd(brw.clim),
sd(ice.clim),
sd(bal.clim),
sd(mhd.clim),
sd(uum.clim),
sd(nwr.clim),
sd(uta.clim),
sd(azr.clim),
sd(tap.clim),
sd(wlg.clim),
sd(izo.clim),
sd(mid.clim),
sd(key.clim),
sd(mlo.clim),
sd(rpb.clim),
sd(sey.clim),
sd(asc.clim),
sd(smo.clim),
sd(eic.clim),
sd(cgo.clim),
sd(crz.clim),
sd(tdf.clim),
sd(syo.clim),
sd(spo.clim))

mod.mean <- c(mean(alt.mod1),
mean(zep.mod1),
mean(sum.mod1),
mean(brw.mod1),
mean(ice.mod1),
mean(bal.mod1),
mean(mhd.mod1),
mean(uum.mod1),
mean(nwr.mod1),
mean(uta.mod1),
mean(azr.mod1),
mean(tap.mod1),
mean(wlg.mod1),
mean(izo.mod1),
mean(mid.mod1),
mean(key.mod1),
mean(mlo.mod1),
mean(rpb.mod1),
mean(sey.mod1),
mean(asc.mod1),
mean(smo.mod1),
mean(eic.mod1),
mean(cgo.mod1),
mean(crz.mod1),
mean(tdf.mod1),
mean(syo.mod1),
mean(spo.mod1))

mod.zon <- (get.var.ncdf(nc1,ch4.code,start=c(1,1,1,1),count=c(length(lon),length(lat),1,12)))*(conv/mm.ch4)
mod.zon <- apply(mod.zon, c(2), mean)

pdf(file=paste(out.dir, mod1.name, "_CMDL_CH4_latitude_comparison.pdf", sep=""),pointsize=14)

plot(1:10, xlim=c(-90,90), ylim=c(1600,1950) , col="white", ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Latitude")
grid()
polygon(c(lats, rev(lats)), c((obs.mean)-2*(obs.sd), rev((obs.mean)+2*(obs.sd))), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(lats, obs.mean, lwd=2, type="o")
arrows(lats, ((obs.mean)-2*(obs.sd)),  lats, ((obs.mean)+2*(obs.sd)), length = 0.0, code =2 )
lines(lats, mod.mean, lwd=2, type="o", pch=2, col="red")
lines(lat, mod.zon, lwd=1.5, col="red", lty=2)
text(-50, 1800, paste("mean bias = ", sprintf("%1.3g", mean(obs.mean-mod.mean)), " (ppbv)", sep="") )
legend("topleft", c(mod1.name,"obs"), lwd=1, col=c("red","black"), bty="n")

dev.off()

# ==========================================================================================
# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

#plot data
pdf(file=paste(out.dir, mod1.name, "_CMDL_CH4_comparison.pdf", sep=""),width=14,height=21,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.6,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:18, 6, 3, byrow = TRUE))

#plot 
plot(alt.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Alert (82.4N, 62.5W, 210m)")
arrows( 1:12, ((alt.clim)-2*(alt.sd)),  1:12, ((alt.clim)+2*(alt.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(alt.mod1,type="o",col="red")
grid()
legend("topleft", mod1.name, lwd=1, col="red", bty="n")
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.alt)," MBE = ", sprintf("%1.3g", MBE.alt), "%", sep="")), cex=0.9)

plot(brw.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Barrow (71.3N, 156.6W, 11m)") 
arrows( 1:12, ((brw.clim)-2*(brw.sd)),  1:12, ((brw.clim)+2*(brw.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(brw.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.brw)," MBE = ", sprintf("%1.3g", MBE.brw), "%", sep="")), cex=0.9)

plot(mhd.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mace Head (53.3N, 9.9W, 25m)") 
arrows( 1:12, ((mhd.clim)-2*(mhd.sd)),  1:12, ((mhd.clim)+2*(mhd.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mhd.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.mhd)," MBE = ", sprintf("%1.3g", MBE.mhd), "%", sep="")), cex=0.9)

#plot(lef.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Park Falls (45.9N, 90.2W, 472m)") 
#arrows( 1:12, ((lef.clim)-2*(lef.sd)),  1:12, ((lef.clim)+2*(lef.sd)), length = 0.0, code =2 )
#axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
#points(lef.mod1,type="o",col="red")
#grid()
#text(6,10, c(paste("r = ",sprintf("%1.3g", cor.lef)," MBE = ", sprintf("%1.3g", MBE.lef), "%", sep="")), cex=0.9)

plot(nwr.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Niwot Ridge (40.0N, 105.6W, 3475m)") 
arrows( 1:12, ((nwr.clim)-2*(nwr.sd)),  1:12, ((nwr.clim)+2*(nwr.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(nwr.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.nwr)," MBE = ", sprintf("%1.3g", MBE.nwr), "%", sep="")), cex=0.9)

plot(tap.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Tae-ahn Peninsula (36.7N, 126.1E, 20m)") 
arrows( 1:12, ((tap.clim)-2*(tap.sd)),  1:12, ((tap.clim)+2*(tap.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(tap.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.tap)," MBE = ", sprintf("%1.3g", MBE.tap), "%", sep="")), cex=0.9)

plot(wlg.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mt Waliguan (36.3N, 100.9E)") 
arrows( 1:12, ((wlg.clim)-2*(wlg.sd)),  1:12, ((wlg.clim)+2*(wlg.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(wlg.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.wlg)," MBE = ", sprintf("%1.3g", MBE.wlg), "%", sep="")), cex=0.9)

plot(key.clim,ylim=c(1750,1950), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Key Biscayne (25.7N, 80.2W, 3m)") 
arrows( 1:12, ((key.clim)-2*(key.sd)),  1:12, ((key.clim)+2*(key.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(key.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.key)," MBE = ", sprintf("%1.3g", MBE.key), "%", sep="")), cex=0.9)

plot(mlo.clim,ylim=c(1650,1850), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mauna Loa (19.5N, 155.6W, 3397m)") 
arrows( 1:12, ((mlo.clim)-2*(mlo.sd)),  1:12, ((mlo.clim)+2*(mlo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mlo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.mlo)," MBE = ", sprintf("%1.3g", MBE.mlo), "%", sep="")), cex=0.9)

plot(rpb.clim,ylim=c(1650,1850), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Ragged Point (13.2N, 59.4W, 45m)") 
arrows( 1:12, ((rpb.clim)-2*(rpb.sd)),  1:12, ((rpb.clim)+2*(rpb.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(rpb.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.rpb)," MBE = ", sprintf("%1.3g", MBE.rpb), "%", sep="")), cex=0.9)

plot(chr.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Christmas Island (1.7N, 157.2W, 3m)") 
arrows( 1:12, ((chr.clim)-2*(chr.sd)),  1:12, ((chr.clim)+2*(chr.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(chr.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.chr)," MBE = ", sprintf("%1.3g", MBE.chr), "%", sep="")), cex=0.9)

plot(asc.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Ascension Island (7.9S, 14.4W, 54m)") 
arrows( 1:12, ((asc.clim)-2*(asc.sd)),  1:12, ((asc.clim)+2*(asc.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(asc.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.asc)," MBE = ", sprintf("%1.3g", MBE.asc), "%", sep="")), cex=0.9)

plot(smo.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Samoa (14.2S, 170.5W, 42m)") 
arrows( 1:12, ((smo.clim)-2*(smo.sd)),  1:12, ((smo.clim)+2*(smo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(smo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.smo)," MBE = ", sprintf("%1.3g", MBE.smo), "%", sep="")), cex=0.9)

plot(eic.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Easter Island (27.1S, 109.4W, 50m)") 
arrows( 1:12, ((eic.clim)-2*(eic.sd)),  1:12, ((eic.clim)+2*(eic.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(eic.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.eic)," MBE = ", sprintf("%1.3g", MBE.eic), "%", sep="")), cex=0.9)

plot(cgo.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Cape Grim (40.7S, 144.7E, 94m)") 
arrows( 1:12, ((cgo.clim)-2*(cgo.sd)),  1:12, ((cgo.clim)+2*(cgo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(cgo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.cgo)," MBE = ", sprintf("%1.3g", MBE.cgo), "%", sep="")), cex=0.9)

plot(crz.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Crozet Island (46.5S, 51.8E, 120m)") 
arrows( 1:12, ((crz.clim)-2*(crz.sd)),  1:12, ((crz.clim)+2*(crz.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(crz.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.crz)," MBE = ", sprintf("%1.3g", MBE.crz), "%", sep="")), cex=0.9)

plot(syo.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Syowa Station (69.0S, 39.6E, 11m)") 
arrows( 1:12, ((syo.clim)-2*(syo.sd)),  1:12, ((syo.clim)+2*(syo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(syo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.syo)," MBE = ", sprintf("%1.3g", MBE.syo), "%", sep="")), cex=0.9)

plot(spo.clim,ylim=c(1650,1800), ylab=bquote(paste(CH[4], " (ppbv)", sep=" ")), xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="South Pole (90.0S, 24.8W, 2810m)") 
arrows( 1:12, ((spo.clim)-2*(spo.sd)),  1:12, ((spo.clim)+2*(spo.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(spo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.spo)," MBE = ", sprintf("%1.3g", MBE.spo), "%", sep="")), cex=0.9)


dev.off()



