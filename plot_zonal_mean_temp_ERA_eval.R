# R Script to plot model.1 vs temp ERA data 

# Alex Archibald, July 2011

# call the interpolate zm function and pass in the variable (var) to 
# interpolate and the values (pres) to interpolate onto
var <- temp.code

# define pressure levels to interpolate onto NOTE these are in hPa!!
pres <- c(1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,
500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10,7,5,3,2,1)

# ERA data
nc0 <- open.ncdf(paste(obs.dir, "ERA/data/erai_temp_2000-2011_N48_P37.nc", sep=""), readunlim=FALSE)

# extract/define variables
era.z  <- get.var.ncdf(nc0,"T")
era.sd <- apply(era.z,c(2,3),function(x) sd(as.vector(x), na.rm=T))
era.z  <- apply(era.z,c(2,3),mean,na.rm=T)
era.z  <- era.z[,rev(1:length(pres))]
era.sd  <- era.sd[,rev(1:length(pres))]
lat.era<- get.var.ncdf(nc0, "latitude")
lat    <- get.var.ncdf(nc1, "latitude")
hgt    <- get.var.ncdf(nc0, "p")
z      <- seq(length(hgt))

# check to see if the model is on the same grid as the obs (currently N48)
if (length(lat) != 73 ) {
source(paste(script.dir, "interpolate_zm_n96_eval.R", sep=""))
} else {
source(paste(script.dir, "interpolate_zm_eval.R", sep=""))
}

# define model tropopause height on pressure (using scale height from UKCA)
ht     <- get.var.ncdf(nc1, trop.pres.code)
ht     <- apply(ht, c(2), mean)*1E-2 # (convert to hPa)

# set the plotting field to the interpolated field
ukca.z <- apply(newvv, c(1,2), mean)
rm(newvv)
rm(var)

# create an array of abs. difference
diff <- (ukca.z-era.z)

# create a mask of significance (diff/era.sd)
sig.mask <- ifelse( abs( (diff/(era.sd))) > 1.0, TRUE, FALSE)

#diff <- diff*sig.mask

# create a nice log scale for the y axis.
# This transfrmation was taken from the skewty.R function from the ozone sonde package
log.z <-  132.18199999999999 - 44.061 * log10(rev(hgt))
log.ht<-  132.18199999999999 - 44.061 * log10(ht)

# generate a list of where to hash out the masked points
pts      <- expand.grid(x = lat, y = log.z)
pts$mask <- as.vector(sig.mask)

# ###################################################################################################################################
# find the index of the tropopause-ish level (100 hPa)
bot    <- which(pres==1000.0)
trop   <- which(pres==100.0)

s.lat  <- which(lat.era>=-25)[1]
f.lat  <- which(lat.era>=25)[1]
b.hgt  <- which(pres>=80)[1]

# copy data for bias calcs
diff.raw <- diff

# set axis'
axis_x <- seq(from=-90, to=90, by=15)
axis_y <- z

# the y axis labels get a bit crowded so here is a cut down set:
y.labs <- c(1000,700,500,250,150,100,70,50,30,20,10,7,5,3,2,1)

# set limits for plots and data
zmin <- -10.0
zmax <-  10.0
diff[diff>=zmax] <- zmax
diff[diff<=zmin] <- zmin

# ##################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"-ERA_Temp.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
filled.contour(lat.era, log.z, diff, ylab="Altitude (hPa)", xlab="Latitude (degrees)", main=paste(mod1.name,"- ERA Temperature bias ",sep=" "), 
zlim=c(zmin,zmax), col=heat.cols(22), xaxt="n", yaxt="n", 
ylim=c(log.z[1],log.z[32]), key.title = title("K"), plot.axes= {
contour(lat.era, log.z, diff, method = "edge", labcex = 1, col = "black", add = TRUE, lty=1, levels=seq(0,10,1)) #positive
contour(lat.era, log.z, diff, method = "edge", labcex = 1, col = "black", add = TRUE, lty=2, levels=seq(-10,0,1)) #negative
lines(lat, log.ht, lwd=2, lty=2)
axis(side=1, axis_x, labels=TRUE, tick=TRUE)
axis(side=2, log.z, labels=FALSE, tick=TRUE)
axis(side=2, log.z[c(1,12,16,21,25,27:37)],   labels=sprintf("%1g", y.labs), tick=TRUE)
#points(pts$x[pts$mask], pts$y[pts$mask], cex = 0.8, pch=4, col="white")
grid() } )

par(xpd=T)
text(-60,90, paste("Min =",sprintf("%1.3g", min(diff.raw, na.rm=T) ), "Mean =", sprintf("%1.3g", mean(diff.raw, na.rm=T) ), "Max =", sprintf("%1.3g", max(diff.raw, na.rm=T) ), sep=" ") )
par(xpd=F)

dev.off()
