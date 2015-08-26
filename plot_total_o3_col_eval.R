# R Script to calculate the tropospheric ozone column using
# tropopause mask.

# Alex Archibald, February 2012

# Merged total O3 column by Greg Boedecker (compilation of OMI, TOMS and sondes).
nc0 <- open.ncdf(paste(obs.dir, "Boedecker/BSCO_V2.8_mm2.nc", sep=""), readunlim=FALSE)

# define constants and loop vars and arrays
conv.fac <- 2.69E20 # molec.cm-2 -> DUnits
nav      <- 6.02214179E23 
mmr.o3   <- 48.0e-3 # in kg

# extract vars
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")
time  <- get.var.ncdf(nc1, "t")

source(paste(script.dir, "check_model_dims.R", sep=""))

o3      <- get.var.ncdf(nc1,o3.code) # kg/kg o3
mass    <- get.var.ncdf(nc1,air.mass) # kg air

toms.o3 <- get.var.ncdf(nc0, "TCO", start=c(1,1,313), count=c(1,73,12)) # Start at 01/2005 and end at 12/2005
sat.lat <- get.var.ncdf(nc0, "latitude")

o3.col   <- array(NA, dim=c(length(lon),length(lat),length(time)) ) 

# Start calculate column ############################################################################################################
# convert to molecules 
# n.molecules = NA(molecules/mol) * mass(g) / mmr(g/mol) )
o3.mass <- (o3 * mass)

# convert to molecules 
o3.mol <- nav * (o3.mass/mmr.o3) 

# Ozone column = sum in vertical (kg)
o3.mol <- apply(o3.mol,c(1,2,4),sum)

# loop over each month
# divide by area (molecules/m2) and convert to DU
for (m in 1:length(time)) {
  o3.col[,,m] <- (o3.mol[,,m] /  gb.sa[,]) / conv.fac
} 

# apply zonal mean
o3.col <- apply(o3.col, c(3,2), mean)
toms.o3<- t(toms.o3) #apply(toms.o3, c(3,2), mean)
toms.o3<- toms.o3[,rev(1:length(sat.lat))]
# End calculate column #############################################################################################################

# set dates for x axis
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

# set axis'
axis_x <- monthNames
axis_y <- seq(from=-90, to=90, by=15)
zlim   <- seq(from=175,to=425, by=25)
nlevels<- 18
levels <- pretty(zlim, nlevels)

# set high and low values
o3.col[o3.col>425] <- 425.0
o3.col[o3.col<175] <- 175.0
# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_Total_O3_col.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
filled.contour(1:12, lat, o3.col, ylab="Latitude (degrees)", xlab="Month", main=bquote(paste( "", .(mod1.name), ~ "total" ~ O[3], " column", sep=" ")),
zlim=c(175,425), col=o3.col.cols(length(levels)-1), xaxt="n", nlevels=nlevels, 
plot.axes= {
key.title="(DU)"
contour(1:12, lat, o3.col, col = "gray", add = TRUE, lty=1, lwd=0.7, drawlabels= TRUE, levels=seq(175,425,25), cex=0.5)
contour(1:12, sat.lat, toms.o3, col = "black", add = TRUE, lty=1, lwd=2, levels=seq(175,425,25))
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
axis(side=2, axis_y, labels=TRUE, tick=TRUE)
} )

par(xpd=T)
text(3,95, paste("Min =",sprintf("%1.3g", min(o3.col, na.rm=T) ), "Max =", sprintf("%1.3g", max(o3.col, na.rm=T) ), sep=" ") )
par(xpd=F)

dev.off()


