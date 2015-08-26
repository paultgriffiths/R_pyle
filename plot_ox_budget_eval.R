# R script to plot and calculate the ox budget
# in the troposphere.

# Alex Archibald, February 2012


# define constants and conv. factors
conv.factor <- 60*60*24*30*48*(1e-12)
nav         <- 6.02214179E23

# extract variables
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")*1E-3 # km
time  <- get.var.ncdf(nc1, "t")

# model (UM) tropopause height
ht     <- get.var.ncdf(nc1, trop.hgt.code)
ht     <- apply(ht, c(2), mean)*1E-3 # km

# ################################################################################################################
# define empty arrays 
ncp       <- array(NA, dim=c(length(lon), length(lat), length(hgt), length(time)) )
net.p.std <- array(NA, dim=c(length(lon), length(lat), length(hgt), length(time)) )
net.l.std <- array(NA, dim=c(length(lon), length(lat), length(hgt), length(time)) )
dd.map.std<- array(NA, dim=c(length(lon), length(lat), length(time)) )

source(paste(script.dir, "check_model_dims.R", sep=""))
# Check to see if a trop. mask exists?
if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source(paste(script.dir, "calc_trop_mask.R", sep="")))

# extract ozone production terms
p1.1 <- get.var.ncdf(nc1,ho2no.code) * mask *3.0 ## NOTE I made a mistake in my umui job set up so have had to multiply fluxes (here) by three!!
p1.2 <- get.var.ncdf(nc1,meo2no.code) * mask *3.0
p1.3 <- get.var.ncdf(nc1,ro2no.code) * mask *3.0
p1.4 <- get.var.ncdf(nc1,ohrcooh.code) * mask *3.0
p1.5 <- get.var.ncdf(nc1,ohrono2.code) * mask *3.0
p1.6 <- get.var.ncdf(nc1,hvrono2.code) * mask *3.0
p1.7 <- get.var.ncdf(nc1,ohpan.code) * mask *3.0

# sum the terms
net.p     <- (p1.1 + p1.2 + p1.3 + p1.4 + p1.5 + p1.6 + p1.7)

# loop over time and standardise the flux terms:
# moles/grdibox/s -> moles/m3/s
for (i in 1:length(time) ) {
net.p.std <- (net.p[,,,i]/vol) }

# extract ozone loss terms
l1.1 <- get.var.ncdf(nc1,o1dh2o.code) * mask *3.0
l1.2 <- get.var.ncdf(nc1,mlr.code) * mask *3.0
l1.3 <- get.var.ncdf(nc1,ho2o3.code) * mask *3.0
l1.4 <- get.var.ncdf(nc1,oho3.code) * mask *3.0
l1.5 <- get.var.ncdf(nc1,o3alk.code) * mask *3.0
l1.6 <- get.var.ncdf(nc1,n2o5h2o.code) * mask *3.0
l1.7 <- get.var.ncdf(nc1,no3loss.code) * mask *3.0
# 2d fields
l1.8 <- get.var.ncdf(nc1,o3.dd.code)  *3.0
l1.9 <- get.var.ncdf(nc1,noy.dd.code) *3.0
# 3d noy wet dep
l1.10 <- get.var.ncdf(nc1,noy.wd.code) * mask *3.0

# sum the terms
net.l <- (l1.1 + l1.2 + l1.3 + l1.4 + l1.5 + l1.6 + l1.7)

# loop over time and standardise the flux terms:
# moles/grdibox/s -> moles/m3/s
for (i in 1:length(time) ) {
net.l.std <- (net.l[,,,i]/vol) }

# convert from moles/gridbox/s to molecules/cm-3/s
net.o3 <- (net.p - net.l)
for (i in 1:length(time) ) {
ncp[,,,i] <- ( net.o3[,,,i]/(vol*1E6)) }
ncp <- ncp*nav
ncp <- ncp/1E6
ncp <- apply( ncp, c(2,3), mean, na.rm=T )

# subset the data so that some of the high values are omited..
ncp.90 <- ncp
ncp.90[ncp.90>=0.5]  <- 0.5
ncp.90[ncp.90<=-0.5] <- -0.5

# creata a map of the dry deposition (O3 + NOy)
dd.map <- (l1.8 + l1.9)
# convert from moles/gridbox/s to molecules/cm-2/s
for (i in 1:length(time) ) {
dd.map.std[,,i] <- ( dd.map[,,i]/(gb.sa*100*100) ) }
dd.map.std <- dd.map.std*nav
dd.map.std <- dd.map.std/1E9 # scale by 10^9
dd.map <- apply(dd.map.std, c(1,2), mean)

# ################################################################################
# Write these values on the plot
# calc the total production
o3.prod.yrt = sum(p1.1 + p1.2 + p1.3 + p1.4 + p1.5 + p1.6 + p1.7)*conv.factor

# calculate the 3d and 2d (deposition) loss 
o3.loss1.yrt = sum(l1.1 + l1.2 + l1.3 + l1.4 + l1.5 + l1.6 + l1.7)*conv.factor
o3.loss2.yrt = (sum(l1.8 + l1.9)  + sum(l1.10))*conv.factor

o3.netchem <-  o3.prod.yrt - o3.loss1.yrt 
ste.inf    <-  o3.prod.yrt - o3.loss1.yrt - o3.loss2.yrt

# diagnosed STE (moles/grid cell/s)
ste.diag <- get.var.ncdf(nc1, ste.code) * mask
ste.diag <- sum(ste.diag)*conv.factor

# nice format for output
ox.prod    <- sprintf("%1.3g", (o3.prod.yrt) )
ox.loss    <- sprintf("%1.3g", (o3.loss1.yrt) )
ox.loss.dd <- sprintf("%1.3g", (o3.loss2.yrt) )
ox.netchem <- sprintf("%1.3g", (o3.prod.yrt - o3.loss1.yrt) )
ste.inf    <- sprintf("%1.3g", (o3.prod.yrt - o3.loss1.yrt - o3.loss2.yrt)*-1.0 ) # To get a positive flux
ox.prod    <- sprintf("%1.3g", (o3.prod.yrt) )
ste.diagn  <- sprintf("%1.3g", (ste.diag) )

# Calc the burden in Tg
if ( exists("o3.burden") == TRUE) print("Tropospheric Ozone burden exists, carrying on") else (source(paste(script.dir, "get_trop_o3_burden.R", sep="")))

tau.o3     <- sprintf("%1.3g", ((o3.burden/(o3.loss1.yrt + o3.loss2.yrt))*360) ) # convert to days
# ################################################################################
# some extra bits and bobs for the plot

# set a nice scale
minmax <- function (x) pmax( max(x), abs(min(x)) )
zlim <- c(-0.5, 0.5)

# find index of hgt which is greater than 20 km's 
hindex   <- which((hgt)>20)[1]
# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_ox_budget.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
image.plot(lat, hgt[1:hindex], ncp.90[,1:hindex], xlab="Latitude (degrees)", ylab="Altitude (km)", 
main=paste(mod1.name,"Ox Net Chemical Production", sep=" "), 
zlim=zlim, col=heat.cols(23) )
# add tropopause
lines(lat, ht, lwd=2, lty=2)

par(xpd=T)
text(x=-60,y=20, paste("Ox Prod = ", ox.prod, "Tg/yr", sep="") )
text(x=-60,y=19, paste("Ox Loss = ", ox.loss, "Tg/yr", sep="") )
text(x=-60,y=18, paste("Ox Net  = ", ox.netchem, "Tg/yr", sep="") )
text(x= 50,y=19, paste("STE inferred = ",  ste.inf, "Tg/yr", sep="") )
text(x= 50,y=18, paste("STE diag.    = ",  ste.diagn, "Tg/yr", sep="") )
text(x= 60,y=17, paste("Lifetime = ",  tau.o3, "days", sep="") )
text(x= 70,y=21.5, expression(paste("10"^"6", " (molecules cm"^"-3","s"^"-1",")", sep="") ), font=2)

par(xpd=F)

dev.off()

# ###################################################################################################################################
# set lims
zlim <- c(0, 500)

# find the index for the mid latitude in the array
midlon <- which(lon>=180.0)[1]
maxlon <- length(lon)
dellon <- lon[2]-lon[1]
# reform array - makes it look nicer on map
dd.map <- abind(dd.map[midlon:maxlon,], dd.map[1:midlon-1,], along=1)

pdf(file=paste(out.dir,mod1.name,"_ox_dep_map.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)
# overplot the data 
image.plot(seq(-180,(180-dellon),dellon), lat, dd.map, xlab="Latitude (degrees)", ylab="Latitude (degrees)", 
main=paste(mod1.name,"Ox deposition", sep=" "), 
zlim=zlim, col=col.cols(23) )
map("world", add=T)

par(xpd=T)
text(x=-90,95, paste("Total Ox Deposition = ", ox.loss.dd, " Tg/yr", sep="") )
text(x= 90,y=95, expression(paste("10"^"9", " (molecules cm"^"-2","s"^"-1",")", sep="") ), font=2)
par(xpd=F)

dev.off()

# delete arrays ########
rm(net.l); rm(net.l.std)
rm(net.p); rm(net.p.std)

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_ox_budget_sources_sinks.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

par(mfrow=c(1,2))

prod.ls <- c( sum(p1.1), sum(p1.2), sum(p1.3), sum (sum(p1.4) + sum(p1.5) + sum(p1.6) + sum(p1.7)) ) 
lbls1   <- c("HO2+NO", "MeO2+NO", "RO2+NO", "Other")
pct     <- round(prod.ls/sum(prod.ls)*100)
lbls    <- paste(lbls1, pct) # add percents to labels
lbls    <- paste(lbls,"%",sep="") # ad % to labels

bp <- barplot(pct, names.arg=lbls1, col=rainbow(length(lbls1)), las=2, ylab = "Contribution (%)", xlab="", ylim=c(0,75),
main=paste(mod1.name, "Production of Tropospheric Ox", sep=" ") )
grid()
box()
text(bp, 0, round(pct, 1),cex=1,pos=3)

loss.ls <- c( sum(l1.1), sum(l1.2), sum(l1.3), sum(l1.4), sum(l1.5), sum(sum(l1.6) + sum(l1.7)), sum(l1.8), sum(sum(l1.9) + sum(l1.10)) ) 
lbls1   <- c("O1D+H2O", "Minor", "HO2+O3", "OH+O3", "O3+Alk", "NxOy", "O3dry", "NOydep")
pct     <- round(loss.ls/sum(loss.ls)*100)
lbls    <- paste(lbls1, pct) # add percents to labels
lbls    <- paste(lbls,"%",sep="") # ad % to labels

bp <- barplot(pct, names.arg=lbls1, col=rainbow(length(lbls1)), las=2, ylab = "Contribution (%)", xlab="", ylim=c(0,50), 
main=paste(mod1.name, "Loss of Tropospheric Ox", sep=" ") )
grid()
box()
text(bp, 0, round(pct, 1),cex=1,pos=3)

dev.off()

