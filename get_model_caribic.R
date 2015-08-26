# R script to extract model variables at given latitudes
# longitude and altitudes and return a time series

find.lat <- function(lat, x) {
which(lat>=x)[1]	
}

lat       <- get.var.ncdf(nc1, "latitude")
start.lat <- find.lat(lat, first.lat)
end.lat   <- find.lat(lat,  last.lat)

lon       <- get.var.ncdf(nc1, "longitude")
start.lon <- find.lat(lon, first.lon)
end.lon   <- find.lat(lon,  last.lon)

start.hgt <- which( (get.var.ncdf(nc1, "hybrid_ht")*1E-3) > 8.0)[1]
end.hgt   <- which( (get.var.ncdf(nc1, "hybrid_ht")*1E-3) > 12.0)[1]

assign(paste(location,".mod.o3.mean",sep=""), apply( (get.var.ncdf(nc1, o3.code, start=c(start.lon, start.lat, start.hgt, 1), count=c(end.lon-start.lon, end.lat-start.lat, end.hgt-start.hgt, 12) )*(conv/mm.o3)), c(4), mean) )
assign(paste(location,".mod.co.mean",sep=""), apply( (get.var.ncdf(nc1, co.code, start=c(start.lon, start.lat, start.hgt, 1), count=c(end.lon-start.lon, end.lat-start.lat, end.hgt-start.hgt, 12) )*(conv/mm.co)), c(4), mean) )

assign(paste(location,".mod.o3.var",sep=""), apply( (get.var.ncdf(nc1, o3.code, start=c(start.lon, start.lat, start.hgt, 1), count=c(end.lon-start.lon, end.lat-start.lat, end.hgt-start.hgt, 12) )*(conv/mm.o3)), c(4), var) )
assign(paste(location,".mod.co.var",sep=""), apply( (get.var.ncdf(nc1, co.code, start=c(start.lon, start.lat, start.hgt, 1), count=c(end.lon-start.lon, end.lat-start.lat, end.hgt-start.hgt, 12) )*(conv/mm.co)), c(4), var) )
