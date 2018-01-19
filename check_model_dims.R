
# R scrip to check the model dimensions

# Alex Archibald, March 2012
# Modified February 2014 to make more flexible

# Inputs: 
# nc1 = the netcdf file of your model data
# nc4-5 = the UM anciliary info about various model grids
# These should contain info on the heights of the grid boxes,
# volumes, and areas.

# Outputs:
# vol 	= array(lon,lat,hgt) of grid box volumes in m^3
# gb.sa = array(lon,lat) of grid box surface area in m^2 
# modhgt= array(lon,lat,hgt) of grid box heights in m


# ancilary information about the model grid
if (length(get.var.ncdf(nc1, lat.dim.name)) == 73) {
nc4 <- open.ncdf(paste(ancil.dir, "surface_area.nc", sep=""))
nc5 <- open.ncdf(paste(ancil.dir, "ukca_geovol.nc", sep="")) 
gb.sa   <- get.var.ncdf(nc4,"field") 		# surface area of grid boxes in m^2
modhgt  <- get.var.ncdf(nc5,"geop_theta") 	# height of model grid in m 
vol     <- get.var.ncdf(nc5,"vol_theta") 	# volume of grid boxes in m^3
}

if (length(get.var.ncdf(nc1, lat.dim.name)) == 145) {
nc4 <- open.ncdf(paste(ancil.dir, "surface_area_N96.nc", sep=""))
nc5 <- open.ncdf(paste(ancil.dir, "n96_l63_geovol.nc", sep=""))
gb.sa   <- get.var.ncdf(nc4,"Area") 		# surface area of grid boxes in m^2
modhgt  <- get.var.ncdf(nc5,"ht") 		# height of model grid in m 
vol     <- get.var.ncdf(nc5,"vol_theta")	# volume of grid boxes in m^3
}

