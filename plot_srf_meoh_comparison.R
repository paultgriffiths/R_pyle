# R script to plot comparison of surface mthanol from 
# Mace Head and Cape Verde (annual average data)

# Can be used as part of the UKCA evaluation scripts

# Alex Archibald, CAS, July 2012

# Extract model variables and define constants, 
# loop vars
lat  <- get.var.ncdf(nc1, "latitude")
lon  <- get.var.ncdf(nc1, "longitude")
hgt  <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
time <- get.var.ncdf(nc1, "t")
# calc del lon and lats
del.lon <- lon[2] - lon[1]
del.lat <- lat[2] - lat[1]

ppb  <- 1E9
ppt  <- 1E12

# extract the model methanol
ukca.meoh <- get.var.ncdf(nc1, meoh.code)*(ppt/mm.meoh)

# extract the cape verde observations
capev <- read.table(paste(obs.dir, "CapeVerde/vocs/methanol/daily/cvo116n00.uyrk.as.cn.methanol.nl.da.dat", sep=""), skip=32, header=F)
names <- c("DATE","TIME","DATE2","TIME2","methanol","ND","SD","F","CS","REM")
names(capev) <- names
capev$date <- paste(capev$DATE, capev$TIME)
capev$date <- as.POSIXct(strptime(capev$date, format = "%Y-%m-%d %H:%M"))
# set missing data
capev$methanol[capev$methanol<=0] <- NA

# extract the mace head observations
maceh <- read.csv(paste(obs.dir, "MaceHead/RCW_MaceHead_Data.csv", sep=""), header=T)
maceh$date <- as.POSIXct(strptime(maceh$date, format = "%d/%m/%Y %H:%M"))
# convert methanol to pptv (from ppbv)
maceh$methanol <- maceh$methanol*1E3

# calculate seasonl means of the methanol data
cv.mean <- aggregate(capev["methanol"], format(capev["date"], "%m"), mean, na.rm=T) 
cv.sdev <- aggregate(capev["methanol"], format(capev["date"], "%m"), sd, na.rm=T) 
cv.clim <- cv.mean$methanol
cv.sd   <- cv.sdev$methanol

mh.mean <- aggregate(maceh["methanol"], format(maceh["date"], "%m"), mean, na.rm=T) 
mh.sdev <- aggregate(maceh["methanol"], format(maceh["date"], "%m"), sd, na.rm=T) 
mh.clim <- mh.mean$methanol
mh.sd   <- mh.sdev$methanol

# set the locations for the two sites
mh.lat <- 53.0
mh.lon <- -9.9
cv.lat <- 16.848
cv.lon <- -24.871

# convert "real" lats and longs to model grid boxes
mh.lat.m <- (round (  ((mh.lat +90)/del.lat)  ))+1
mh.lon.m <- ifelse ( mh.lon<0, (round( ((mh.lon+360)/del.lon)-0.5))+1, (round( ((mh.lon/del.lon)-0.5) ))+1  )
cv.lat.m <- (round (  ((cv.lat +90)/del.lat)  ))+1
cv.lon.m <- ifelse ( cv.lon<0, (round( ((cv.lon+360)/del.lon)-0.5))+1, (round( ((cv.lon/del.lon)-0.5) ))+1  )

# extract model data at the obs locations
cv.mod1 <- ukca.meoh[cv.lon.m, cv.lat.m, 1, ]
mh.mod1 <- ukca.meoh[mh.lon.m, mh.lat.m, 1, ]

# calc stats
# correlation
cor.cv <- cor(cv.clim,cv.mod1,use="pairwise.complete.obs",method="pearson")
cor.mh <- cor(mh.clim,mh.mod1,use="pairwise.complete.obs",method="pearson")

# mean bias error:
M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=cv.mod1[k]-(cv.clim[k]) }
MBE.cv=(sum(M)/12)/(sum(cv.clim)/12)*100

M<-array(0,dim=c(12))
for (k in 1:12){
M[k]=mh.mod1[k]-(mh.clim[k]) }
MBE.mh=(sum(M)/12)/(sum(mh.clim)/12)*100

# ==========================================================================================
# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

pdf(file=paste(out.dir, mod1.name, "_srf_MeOH_comparison.pdf", sep=""),width=8,height=7,paper="special",
onefile=FALSE,pointsize=14)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.4,0.6,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:6, 3, 2, byrow = TRUE))

#plot 
plot(cv.clim,ylim=c(0,2000), ylab="MeOH (pptv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Cape Verde (16.9N, 24.9W, 10m)")
arrows( 1:12, ((cv.clim)-(cv.sd)),  1:12, ((cv.clim)+(cv.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(cv.mod1,type="o",col="red")
grid()
legend("topleft", mod1.name, lwd=1, col="red", bty="n")
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.cv)," MBE = ", sprintf("%1.3g", MBE.cv), "%", sep="")), cex=0.9)

plot(mh.clim,ylim=c(0,2000), ylab="MeOH (pptv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mace Head (53.0N, 9.9W, 25m)") 
arrows( 1:12, ((mh.clim)-(mh.sd)),  1:12, ((mh.clim)+(mh.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mh.mod1,type="o",col="red")
grid()
text(3,1500, c(paste("r = ",sprintf("%1.3g", cor.mh)," MBE = ", sprintf("%1.3g", MBE.mh), "%", sep="")), cex=0.9)

dev.off()