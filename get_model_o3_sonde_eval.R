# R script to extract model ozone at given latitudes and longitudes

# check to see if the longitudes are -180 -- 180 (i.e. NOT the model grid)
if (dat.lon < 0.0) {
dat.lon <- dat.lon + 360.0 }

model.o3 <- get.var.ncdf(nc1, o3.code, start=c(which(lon>=dat.lon)[1], which(lat>=dat.lat)[1], 1, 1), count=c(1, 1, length(hgt), length(time)) )*(conv/mm.o3)
