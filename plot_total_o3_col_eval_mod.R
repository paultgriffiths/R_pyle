# R Script to calculate the tropospheric ozone column using
# tropopause mask.

# Alex Archibald, February 2012

# define constants and loop vars and arrays
conv.fac <- 2.69E20 # molec.cm-2 -> DUnits
nav      <- 6.02214179E23 
mmr.o3   <- 48.0e-3 # in kg

# extract vars
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")
time  <- get.var.ncdf(nc1, "t")

o3      <- get.var.ncdf(nc1,o3.code) # kg/kg o3
mass    <- get.var.ncdf(nc1,air.mass) # kg air

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

col.scale <- colorRampPalette(brewer.pal(9,"Reds"))
# ###################################################################################################################################
png(file=paste(out.dir,"Total_Column_O3.png", sep=""), 
    height=600, width=600, units="px", bg="white", pointsize=14)    

# overplot the data 
filled.contour(1:12, lat, o3.col, ylab="Latitude (degrees)", xlab="Month", 
               main=bquote(paste( "", .(mod1.name), ~ "total" ~ O[3], " column", sep=" ")),
zlim=c(175,425), col=col.scale(length(levels)-1), xaxt="n", nlevels=nlevels, 
plot.axes= {
key.title="(DU)"
contour(1:12, lat, o3.col, col = "gray", add = TRUE, lty=1, lwd=0.7, 
        drawlabels= TRUE, levels=seq(175,425,25), cex=0.5)
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
axis(side=2, axis_y, labels=TRUE, tick=TRUE)
} )

par(xpd=T)
text(3,95, paste("Min =",sprintf("%1.3g", min(o3.col, na.rm=T) ), "Max =", sprintf("%1.3g", max(o3.col, na.rm=T) ), sep=" ") )
par(xpd=F)

dev.off()


