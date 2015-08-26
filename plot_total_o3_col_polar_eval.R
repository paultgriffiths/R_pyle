# R Script to calculate the tropospheric ozone column using
# tropopause mask.

# Alex Archibald, February 2012

# OMI trop o3 column in DU
nc0 <- open.ncdf(paste(obs.dir, "TOMS/NIWAAssimV2.6_merged_mm.nc", sep=""), readunlim=FALSE)

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
#gb.sa   <- get.var.ncdf(nc4,"Area") # surface area of grid boxes in m**2

toms.o3 <- get.var.ncdf(nc0, "toz", start=c(1,1,314), count=c(96,73,12)) # TOMS total ozone in DU
sat.lat <- get.var.ncdf(nc0, "latitude")

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
o3.col   <- array(NA, dim=c(length(lon),length(lat),length(time)) ) 
for (m in 1:length(time)) {
  o3.col[,,m] <- (o3.mol[,,m] /  gb.sa[,]) / conv.fac
} 

# generate seasonal means
o3.col.djf <- (o3.col[,,12] + o3.col[,,1] + o3.col[,,2]) / 3.0
o3.col.mam <- (o3.col[,,3] + o3.col[,,4] + o3.col[,,5]) / 3.0
o3.col.jja <- (o3.col[,,6] + o3.col[,,7] + o3.col[,,8]) / 3.0
o3.col.son <- (o3.col[,,9] + o3.col[,,10] + o3.col[,,11]) / 3.0

# End calculate column #############################################################################################################
# source the multi filled contour script
source(paste(script.dir, "Filled.contour3.R", sep=""))
source(paste(script.dir, "Filled.legend.R", sep=""))


# ###################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_Total_O3_seasonal_col.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

# plot.new() is necessary if using the modified versions of filled.contour
plot.new()


# set plotting params
NH <- TRUE
lat.0 <- 0.0
zlim <- c(150,450)
cont.cols <- o3.col.cols

# Top left
#par(new = "TRUE",plt = c(0.1,0.35,0.60,0.90),las = 1,cex.axis = 1)
par(new = "TRUE",plt = c(0.1,0.4,0.60,0.95),las = 1,cex.axis = 1)

var <- o3.col.djf
main.text = "DJF"
source(paste(script.dir, "plot_polar.R", sep=""))

# Top right
par(new = "TRUE",plt = c(0.5,0.8,0.60,0.95),las = 1,cex.axis = 1)

var <- o3.col.mam
main.text = "MAM"
source(paste(script.dir, "plot_polar.R", sep=""))

# Bottom left 
par(new = "TRUE",plt = c(0.1,0.4,0.15,0.5),las = 1,cex.axis = 1)

var <- o3.col.jja
main.text = "JJA"
source(paste(script.dir, "plot_polar.R", sep=""))

# Bottom right
par(new = "TRUE",plt = c(0.5,0.8,0.15,0.5),las = 1,cex.axis = 1)

var <- o3.col.son
main.text = "SON"
source(paste(script.dir, "plot_polar.R", sep=""))

# Add a legend:
par(new = "TRUE",plt = c(0.85,0.9,0.25,0.85),las = 1,cex.axis = 1)
filled.legend(unique(lon), unique(lat), var, color=cont.cols, xlab="", ylab="", xlim="", ylim="", zlim=zlim )
text(0.5, 550, paste(mod1.name, "Total Column Ozone", sep=" ") )
text(0.5, 500, "DU")

# ################################ now plot the SH data #############################################################
NH <- FALSE

# plot.new() is necessary if using the modified versions of filled.contour
plot.new()

# Top left
par(new = "TRUE",plt = c(0.1,0.4,0.60,0.95),las = 1,cex.axis = 1)
var <- o3.col.djf
main.text = "DJF"
source(paste(script.dir, "plot_polar.R", sep=""))

# Top right
par(new = "TRUE",plt = c(0.5,0.8,0.60,0.95),las = 1,cex.axis = 1)
var <- o3.col.mam
main.text = "MAM"
source(paste(script.dir, "plot_polar.R", sep=""))

# Bottom left 
par(new = "TRUE",plt = c(0.1,0.4,0.15,0.5),las = 1,cex.axis = 1)
var <- o3.col.jja
main.text = "JJA"
source(paste(script.dir, "plot_polar.R", sep=""))

# Bottom right
par(new = "TRUE",plt = c(0.5,0.8,0.15,0.5),las = 1,cex.axis = 1)
var <- o3.col.son
main.text = "SON"
source(paste(script.dir, "plot_polar.R", sep=""))

# Add a legend:
par(new = "TRUE",plt = c(0.85,0.9,0.25,0.85),las = 1,cex.axis = 1)
filled.legend(unique(lon), unique(lat), var, color=cont.cols, xlab="", ylab="", xlim="", ylim="", zlim=zlim )
text(0.5, 550, paste(mod1.name, "Total Column Ozone", sep=" ") )
text(0.5, 500, "DU")

dev.off()


