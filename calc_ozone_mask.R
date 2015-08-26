# R script to generate an ozone-apause mask

# Alex Archibald and Tara B, March 2012

# You will need to pass in:
# nc1, and the dimensions of the model variable (lon,lat,hgt,time)

if ( exists("o3") == TRUE) print("Ozone array exists, carrying on") else ( o3 <- get.var.ncdf(nc1,o3.code) )

# define loop vars
i <- NULL; j <- NULL; k <- NULL; l <- NULL

# Calculate mask  ############################################################################################################
mask <- array(0, dim=c(length(lon),length(lat),length(hgt),length(time)))

for (i in 1:length(lon)) { 
  for(j in 1:length(lat)) { 
    for (l in 1:length(time)) { 
      for (k in 1:length(hgt)) {
      mask[i,j,k,l] <- 1 # assumes no spuriously high values at surface!
	if ( o3[i,j,k,l]*(1.0E9/mm.o3) > 150.0 ) {
	mask[i,j,k,l] <- 0 # Sets values above 150ppb O3 to be 0
	break }
      }
   }
  }
}
