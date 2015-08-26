# R analysis script used to compare UKCA model 
# data to observations.

# Alex Archibald, CAS, Jan 2012

# exract the physical dimensions from the two files 
lon  <- get.var.ncdf(nc1, "longitude")
lat  <- get.var.ncdf(nc1, "latitude")
hgt  <- get.var.ncdf(nc1, "hybrid_ht")
time <- get.var.ncdf(nc1, "t")

# determine the grid spacing
xmax <- length(lon)
ymax <- length(lat)

if ( (xmax) == 96 )  dlon <- 3.75 
if ( (xmax) == 192 ) dlon <- 1.875 
if ( (ymax) == 73 )  dlat <- 2.50 
if ( (ymax) == 145 ) dlat <- 1.25 

# height in km's to pass to plots
hgt <- hgt/1000.
hgt.10 <- which(hgt>=10.0)[1]

# ##################################################################################
# generate an array of NOx (kg/kg) from the two simulations 
no.1temp <- get.var.ncdf(nc1, no.code)
no2.1temp<- get.var.ncdf(nc1, no2.code)

nox1 <- (no.1temp + no2.1temp)
rm(no.1temp); rm(no2.1temp)

mm.nox <- (16+14) + (16+16+14)
# ##################################################################################
#  
# The plots compare the model runs with statistical 
# data compiled from aircraft campaigns

source(paste(script.dir, "read_campaign_dat.R", sep=""))
source(paste(script.dir, "plot_Emmons_HCHO_eval.R", sep=""))
source(paste(script.dir, "plot_Emmons_PAN_eval.R", sep=""))
source(paste(script.dir, "plot_Emmons_H2O2_eval.R", sep=""))
source(paste(script.dir, "plot_Emmons_HNO3_eval.R", sep=""))
source(paste(script.dir, "plot_Emmons_O3_eval.R", sep=""))
source(paste(script.dir, "plot_Emmons_CO_eval.R", sep=""))
source(paste(script.dir, "plot_Emmons_NOx_eval.R", sep=""))


