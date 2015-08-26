# R script to generate a tropospheric mask

# You will need to pass in:
# nc1, and the dimensions of the model variable (lon,lat,ht,time)

if ( exists("trophgt") == TRUE) print("Tropopause height exists, carrying on") else ( trophgt <- get.var.ncdf(nc1,trop.hgt.code) )
if ( exists("modhgt") == TRUE) print("Model hybrid heights exist, carrying on") else ( modhgt  <- get.var.ncdf(nc5,"geop_theta") )

# define loop vars
i <- NULL; j <- NULL; k <- NULL; l <- NULL; m <- NULL; n <- NULL

# Calculate mask  ############################################################################################################
mask <- array(0, dim=c(length(lon),length(lat),length(hgt),length(time)))

# generate trop mask -- remove strat
for (i in 1:length(lon)) {
   for (j in 1:length(lat)) {
     for (k in 1:length(hgt)) {
       for (l in 1:length(time)) {
       mask[i,j,k,l] <- ifelse(modhgt[i,j,k] <= trophgt[i,j,l], 1, 0) 
      }
     }
   }
}
