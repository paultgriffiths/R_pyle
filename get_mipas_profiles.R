# R script to extract profiles from Zonal Mean
# MIPAS data
 
# open data
nc0 <- open.ncdf(paste(obs.dir, "MIPAS/mipas_o3_2003-2008.nc", sep=""))

# extract variables (MIPAS height in hPa's)
mipas.hgt <- get.var.ncdf(nc0,"z")
mipas.lat <- get.var.ncdf(nc0, "latitude")
mipas.lon <- get.var.ncdf(nc0, "longitude")
mipas.time<- get.var.ncdf(nc0, "t")

start.lat<- find.lat(mipas.lat, first.lat)
end.lat  <- find.lat(mipas.lat,  last.lat)

# extract observed variables (these are already zonal means so only need to average
# over the latitude dimension -- keep height)

assign(paste(location,".mipas.o3.z",sep=""), apply( (get.var.ncdf(nc0, "MIPAS_O3", start=c(1, start.lat, 1, 1), count=c(length(mipas.lon), end.lat-start.lat, length(mipas.hgt), length(mipas.time)))), c(2), mean, na.rm=T) )

