# R Script to calculate the tropospheric ozone burden

# Alex Archibald, February 2012

# extract vars
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")
time  <- get.var.ncdf(nc1, "t")

source(paste(script.dir, "check_model_dims.R", sep=""))

o3      <- get.var.ncdf(nc1,o3.code) # kg/kg o3
trophgt <- get.var.ncdf(nc1,"ht")
mass    <- get.var.ncdf(nc1,air.mass) # kg air

# Calc the burden ########################################################################################################

if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source("calc_trop_mask.R"))

# mask out troposphere and convert to molecules 
# n.molecules = NA(molecules/mol) * mass(g) / mmr(g/mol) )
o3.mass <- (o3 * mass * mask)

# Calc the burden in Tg
o3.burden <- sum( (o3.mass)*1E-9) / length(time)
