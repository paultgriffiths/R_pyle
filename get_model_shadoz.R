# R script to extract model variables at given latitudes
# longitude and altitudes and return a time series


find.lat <- function(lat, x) {
which(lat>=x)[1]	
}

start.lat <- find.lat(lat, first.lat)
start.lon <- find.lat(lon, first.lon)

assign(paste(location,".mod",sep=""), t(get.var.ncdf(nc1, o3.code, start=c(start.lon, start.lat, 1, 1), count=c(1, 1, length(lev), 12) )*(conv/mm.o3) ) )

