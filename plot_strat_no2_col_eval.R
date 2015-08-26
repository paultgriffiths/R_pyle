# R Script to calculate the tropospheric no2 column using
# tropopause mask.

# Alex Archibald, February 2012

# OMI trop NO2 column in 10^15 molecules/cm2
nc0 <- open.ncdf(paste(obs.dir, "OMI/NO2/column/omi_no2_strat_col_zm.nc", sep=""), readunlim=FALSE)

# extract vars
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")
time  <- get.var.ncdf(nc1, "t")

# define constants and loop vars and arrays
nav      <- 6.02214179E23 
mmr.no2  <- 46.0e-3 # in kg
no2.col  <- array(NA, dim=c(length(lon),length(lat),length(time)) ) 

source(paste(script.dir, "check_model_dims.R", sep=""))

no2     <- get.var.ncdf(nc1, no2.code) # kg/kg no2
trophgt <- get.var.ncdf(nc1,"ht")
mass    <- get.var.ncdf(nc1, air.mass) # kg air
omi.no2 <- get.var.ncdf(nc0, "no2_column") / 1e15 # OMI trop NO2 in molecules cm-2
sat.lat <- get.var.ncdf(nc0, "latitude")

# #####################################################################
# Check to see if a trop. mask and mass exist?
if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source(paste(script.dir, "calc_trop_mask.R", sep="")))

# #####################################################################
# copy the mask that is for the troposphere
strat.mask <- 1-(mask)

# Start calculate column ############################################################################################################
# mask out troposphere and convert to molecules 
# n.molecules = NA(molecules/mol) * mass(g) / mmr(g/mol) )
no2.mass <- (no2 * mass * strat.mask)

# convert to molecules 
no2.mol <- nav * (no2.mass/mmr.no2) 

# Ozone column = sum in vertical (kg)
no2.mol <- apply(no2.mol,c(1,2,4),sum)

# loop over each month
# divide by area (molecules/m2) and convert to DU
for (m in 1:length(time)) {
  no2.col[,,m] <- (no2.mol[,,m] /  gb.sa[,])
} 

# apply zonal mean
no2.col <- apply(no2.col, c(3,2), mean) / (100 * 100 * 1E15)

# End calculate column #############################################################################################################

# set dates for x axis
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

# set axis'
axis_x <- seq(from=0, to=360, by=30)
axis_y <- seq(from=-90, to=90, by=15)

zlim   <- seq(0,5,0.5)
nlevels<- 21
levels <- pretty(zlim, nlevels)

# set maximum levels
no2.raw <- no2.col
no2.col[no2.col>5.0] <- 5.0

# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_Strat_NO2_col.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# overplot the data 
filled.contour(1:12, lat, no2.col, ylab="Latitude (degrees)", xlab="Month", main=bquote(paste( "", .(mod1.name), ~ "stratospheric" ~ NO[2], " column", sep=" ")), 
zlim=c(0,5), col=col.cols(length(levels)-1), xaxt="n",nlevels=nlevels,
plot.axes= {
#contour(1:12, lat, no2.col, method = "edge", labcex = 1.0, col = "black", add = TRUE, lty=1, levels=seq(0,7,0.5))
contour(1:12, sat.lat, omi.no2, method = "edge", labcex = 1.0, col = "black", add = TRUE, lty=1, levels=seq(0,7,0.5))
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
axis(side=2, axis_y, labels=TRUE, tick=TRUE)
grid() } )

par(xpd=T)
text(3,95, paste("Min =",sprintf("%1.3g", min(no2.raw) ), "Mean =", sprintf("%1.3g", mean(no2.raw) ), "Max =", sprintf("%1.3g", max(no2.raw) ), sep=" ") )
text(8.5,95, expression(paste("10"^"15", " (molecules cm"^"-2",")", sep="") ), font=2)
par(xpd=F)

dev.off()
