# R script to extract model dimensions

# To be used with UKCA model evaluation package
# Alex Archibald, CAS, Feb 2014

require(ncdf)
lat  <- get.var.ncdf(nc1, lat.dim.name)
lon  <- get.var.ncdf(nc1, lon.dim.name)
hgt  <- get.var.ncdf(nc1, hgt.dim.name)
time <- get.var.ncdf(nc1, time.dim.name)
