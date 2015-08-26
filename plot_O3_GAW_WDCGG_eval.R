# R script to read in O3 data (from GAW WDCGG web site)
# and overplot model data.

# Alex Archibald, September, 2013

# constants and loop vars
conv <- 1E9

# get obs
# read in the surface O3 obs
in.dir <- paste(obs.dir, "CMDL/srfo3/o3/monthly", sep="")

# set the option to extract data: 
# option 1 = seasonal cycle
# option 2 = (multi) annual mean
# option 3 = range (max - min) of (mean) monthly mean 
option <- 1

source(paste(script.dir, "get_gaw_surface_o3.R", sep=""))
srf.o3 <- subset(srf.o3, alt < 1500.)

# extract sites
zep <- all.out[[grep("zep", file.names) ]]
sum <- all.out[[grep("sum", file.names) ]]
brw <- all.out[[grep("brw", file.names) ]]
pal <- all.out[[grep("pal", file.names) ]]
ice <- all.out[[grep("ice", file.names) ]]
mhd <- all.out[[grep("mhd", file.names) ]]
thd <- all.out[[grep("thd", file.names) ]]
bmw <- all.out[[grep("bmw", file.names) ]]
mlo <- all.out[[grep("mlo", file.names) ]]
rpb <- all.out[[grep("rpb", file.names) ]]
mkn <- all.out[[grep("mkn", file.names) ]]
bkt <- all.out[[grep("bkt", file.names) ]]
smo <- all.out[[grep("smo", file.names) ]]
cgo <- all.out[[grep("cgo", file.names) ]]
syo <- all.out[[grep("syo", file.names) ]]
spo <- all.out[[grep("spo", file.names) ]]

# extract o3 from regions using converted grid cell co-ords
zep.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(zep$lon)),find.lat(mean(zep$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
sum.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(sum$lon)),find.lat(mean(sum$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
brw.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(brw$lon)),find.lat(mean(brw$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
pal.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(pal$lon)),find.lat(mean(pal$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
ice.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(ice$lon)),find.lat(mean(ice$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
mhd.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(mhd$lon)),find.lat(mean(mhd$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
thd.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(thd$lon)),find.lat(mean(thd$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
bmw.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(bmw$lon)),find.lat(mean(bmw$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
mlo.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(mlo$lon)),find.lat(mean(mlo$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
rpb.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(rpb$lon)),find.lat(mean(rpb$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
mkn.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(mkn$lon)),find.lat(mean(mkn$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
bkt.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(bkt$lon)),find.lat(mean(bkt$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
smo.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(smo$lon)),find.lat(mean(smo$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
cgo.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(cgo$lon)),find.lat(mean(cgo$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
syo.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(syo$lon)),find.lat(mean(syo$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)
spo.mod1 = (get.var.ncdf(nc1,o3.code,start=c(find.lon(mean(spo$lon)),find.lat(mean(spo$lat)),1,1),count=c(1,1,1,12)))*(conv/mm.o3)

# calc stats
# correlation
cor.zep <- cor(zep$O3.mean,zep.mod1,use="pairwise.complete.obs",method="pearson")
cor.sum <- cor(sum$O3.mean,sum.mod1,use="pairwise.complete.obs",method="pearson")
cor.brw <- cor(brw$O3.mean,brw.mod1,use="pairwise.complete.obs",method="pearson")
cor.pal <- cor(pal$O3.mean,pal.mod1,use="pairwise.complete.obs",method="pearson")
cor.ice <- cor(ice$O3.mean,ice.mod1,use="pairwise.complete.obs",method="pearson")
cor.mhd <- cor(mhd$O3.mean,mhd.mod1,use="pairwise.complete.obs",method="pearson")
cor.thd <- cor(thd$O3.mean,thd.mod1,use="pairwise.complete.obs",method="pearson")
cor.bmw <- cor(bmw$O3.mean,bmw.mod1,use="pairwise.complete.obs",method="pearson")
cor.mlo <- cor(mlo$O3.mean,mlo.mod1,use="pairwise.complete.obs",method="pearson")
cor.rpb <- cor(rpb$O3.mean,rpb.mod1,use="pairwise.complete.obs",method="pearson")
cor.mkn <- cor(mkn$O3.mean,mkn.mod1,use="pairwise.complete.obs",method="pearson")
cor.bkt <- cor(bkt$O3.mean,bkt.mod1,use="pairwise.complete.obs",method="pearson")
cor.smo <- cor(smo$O3.mean,smo.mod1,use="pairwise.complete.obs",method="pearson")
cor.cgo <- cor(cgo$O3.mean,cgo.mod1,use="pairwise.complete.obs",method="pearson")
cor.syo <- cor(syo$O3.mean,syo.mod1,use="pairwise.complete.obs",method="pearson")
cor.spo <- cor(spo$O3.mean,spo.mod1,use="pairwise.complete.obs",method="pearson")

# mean bias error:
mbe.zep <- mbe(zep.mod1, zep$O3.mean)
mbe.sum <- mbe(sum.mod1, sum$O3.mean)
mbe.brw <- mbe(brw.mod1, brw$O3.mean)
mbe.pal <- mbe(pal.mod1, pal$O3.mean)
mbe.ice <- mbe(ice.mod1, ice$O3.mean)
mbe.mhd <- mbe(mhd.mod1, mhd$O3.mean)
mbe.thd <- mbe(thd.mod1, thd$O3.mean)
mbe.bmw <- mbe(bmw.mod1, bmw$O3.mean)
mbe.mlo <- mbe(mlo.mod1, mlo$O3.mean)
mbe.rpb <- mbe(rpb.mod1, rpb$O3.mean)
mbe.mkn <- mbe(mkn.mod1, mkn$O3.mean)
mbe.bkt <- mbe(bkt.mod1, bkt$O3.mean)
mbe.smo <- mbe(smo.mod1, smo$O3.mean)
mbe.cgo <- mbe(cgo.mod1, cgo$O3.mean)
mbe.syo <- mbe(syo.mod1, syo$O3.mean)
mbe.spo <- mbe(spo.mod1, spo$O3.mean)

# ==========================================================================================
# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

#plot data
pdf(file=paste(out.dir, mod1.name, "_GAW_WDCGG_O3_comparison.pdf", sep=""),width=14,height=21,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.6,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:18, 6, 3, byrow = TRUE))

#plot 
plot(zep$O3.mean,ylim=c(0,100), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Zeppelin (78.9N, 11.8E, 475m)")
arrows( 1:12, ((zep$O3.mean)-2*(zep$O3.sd)),  1:12, ((zep$O3.mean)+2*(zep$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(zep.mod1,type="o",col="red")
grid()
legend("topleft", mod1.name, lwd=1, col="red", bty="n")
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.zep)," MBE = ", sprintf("%1.3g", mbe.zep), "%", sep="")), cex=0.9)

plot(sum$O3.mean,ylim=c(0,80), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Summit (72.6N, 38.5W, 3238m)") 
arrows( 1:12, ((sum$O3.mean)-2*(sum$O3.sd)),  1:12, ((sum$O3.mean)+2*(sum$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(sum.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.sum)," MBE = ", sprintf("%1.3g", mbe.sum), "%", sep="")), cex=0.9)

plot(brw$O3.mean,ylim=c(0,80), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Barrow (71.3N, 156.6W, 11m)") 
arrows( 1:12, ((brw$O3.mean)-2*(brw$O3.sd)),  1:12, ((brw$O3.mean)+2*(brw$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(brw.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.brw)," MBE = ", sprintf("%1.3g", mbe.brw), "%", sep="")), cex=0.9)

plot(pal$O3.mean,ylim=c(0,100), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Pallas (67.9N, 24.1E, 560m)") 
arrows( 1:12, ((pal$O3.mean)-2*(pal$O3.sd)),  1:12, ((pal$O3.mean)+2*(pal$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(pal.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.pal)," MBE = ", sprintf("%1.3g", mbe.pal), "%", sep="")), cex=0.9)

plot(ice$O3.mean,ylim=c(0,80), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Heimaey (63.4N, 20.3W, 100m)") 
arrows( 1:12, ((ice$O3.mean)-2*(ice$O3.sd)),  1:12, ((ice$O3.mean)+2*(ice$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(ice.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.ice)," MBE = ", sprintf("%1.3g", mbe.ice), "%", sep="")), cex=0.9)

plot(mhd$O3.mean,ylim=c(0,80), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mace Head (53.3N, 9.9W, 8m)") 
arrows( 1:12, ((mhd$O3.mean)-2*(mhd$O3.sd)),  1:12, ((mhd$O3.mean)+2*(mhd$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mhd.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.mhd)," MBE = ", sprintf("%1.3g", mbe.mhd), "%", sep="")), cex=0.9)

plot(thd$O3.mean,ylim=c(0,80), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Trinidad Head (41N, 124W, 120m)") 
arrows( 1:12, ((thd$O3.mean)-2*(thd$O3.sd)),  1:12, ((thd$O3.mean)+2*(thd$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(thd.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.thd)," MBE = ", sprintf("%1.3g", mbe.thd), "%", sep="")), cex=0.9)

plot(bmw$O3.mean,ylim=c(0,80), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Tudor Hill (32.3N, 64.9W, 30m)") 
arrows( 1:12, ((bmw$O3.mean)-2*(bmw$O3.sd)),  1:12, ((bmw$O3.mean)+2*(bmw$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(bmw.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.bmw)," MBE = ", sprintf("%1.3g", mbe.bmw), "%", sep="")), cex=0.9)

plot(mlo$O3.mean,ylim=c(0,80), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mauna Loa (19.5N, 155.6W, 3397m)") 
arrows( 1:12, ((mlo$O3.mean)-2*(mlo$O3.sd)),  1:12, ((mlo$O3.mean)+2*(mlo$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mlo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.mlo)," MBE = ", sprintf("%1.3g", mbe.mlo), "%", sep="")), cex=0.9)

plot(rpb$O3.mean,ylim=c(0,60), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Ragged Point (13.2N, 59.4W, 45m)") 
arrows( 1:12, ((rpb$O3.mean)-2*(rpb$O3.sd)),  1:12, ((rpb$O3.mean)+2*(rpb$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(rpb.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.rpb)," MBE = ", sprintf("%1.3g", mbe.rpb), "%", sep="")), cex=0.9)

plot(mkn$O3.mean,ylim=c(0,60), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Mt. Keyna (0.1S, 37.3E, 3678m)") 
arrows( 1:12, ((mkn$O3.mean)-2*(mkn$O3.sd)),  1:12, ((mkn$O3.mean)+2*(mkn$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(mkn.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.mkn)," MBE = ", sprintf("%1.3g", mbe.mkn), "%", sep="")), cex=0.9)

plot(bkt$O3.mean,ylim=c(0,60), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Bukit Koto Tab. (0.2S, 100W, 864m)") 
arrows( 1:12, ((bkt$O3.mean)-2*(bkt$O3.sd)),  1:12, ((bkt$O3.mean)+2*(bkt$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(bkt.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.bkt)," MBE = ", sprintf("%1.3g", mbe.bkt), "%", sep="")), cex=0.9)

plot(smo$O3.mean,ylim=c(0,50), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Samoa (14.2S, 170.5W, 42m)") 
arrows( 1:12, ((smo$O3.mean)-2*(smo$O3.sd)),  1:12, ((smo$O3.mean)+2*(smo$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(smo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.smo)," MBE = ", sprintf("%1.3g", mbe.smo), "%", sep="")), cex=0.9)

plot(cgo$O3.mean,ylim=c(0,50), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Cape Grim (40.7S, 144.7E, 94m)") 
arrows( 1:12, ((cgo$O3.mean)-2*(cgo$O3.sd)),  1:12, ((cgo$O3.mean)+2*(cgo$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(cgo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.cgo)," MBE = ", sprintf("%1.3g", mbe.cgo), "%", sep="")), cex=0.9)

plot(syo$O3.mean,ylim=c(0,50), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="Syowa Station (69.0S, 39.6E, 11m)") 
arrows( 1:12, ((syo$O3.mean)-2*(syo$O3.sd)),  1:12, ((syo$O3.mean)+2*(syo$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(syo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.syo)," MBE = ", sprintf("%1.3g", mbe.syo), "%", sep="")), cex=0.9)

plot(spo$O3.mean,ylim=c(0,50), ylab="O3 (ppbv)", xlab="Month", xaxt="n", type="o", lwd=1.5,  cex.main=0.9, main="South Pole (90.0S, 24.8W, 2810m)") 
arrows( 1:12, ((spo$O3.mean)-2*(spo$O3.sd)),  1:12, ((spo$O3.mean)+2*(spo$O3.sd)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
points(spo.mod1,type="o",col="red")
grid()
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.spo)," MBE = ", sprintf("%1.3g", mbe.spo), "%", sep="")), cex=0.9)


dev.off()



