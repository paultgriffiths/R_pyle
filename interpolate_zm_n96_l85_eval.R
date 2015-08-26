# R Script to interpolate model variable onto pressure
# grid and generate zonal mean.
# Takes input's:
# "var", "nc1" and "pres" from calling script 

# Alex Archibald, February, 2012

# This version also includes a call to a routine to do a 
# 2d interpolation of the model field (lon, lat) to the obs
# grid (i.e. N96-N48 transform)
source(paste(script.dir, "/interp2d.R", sep=""))

# Arguments  --------------------------------------------------------------------------------------- #
pmax <- length(pres)

# extract model co-ords
# extract model co-ords
lonp  <- get.var.ncdf(nc1, lon.dim.name)
latp  <- get.var.ncdf(nc1, lat.dim.name)
levp  <- get.var.ncdf(nc1, hgt.dim.name)
timep <- get.var.ncdf(nc1, time.dim.name)

lonv  <- get.var.ncdf(nc1, lon.dim.name)
latv  <- get.var.ncdf(nc1, lat.dim.name)
levv  <- get.var.ncdf(nc1, hgt.dim.name)
timev <- get.var.ncdf(nc1, time.dim.name)

# check that the two variables have the same lengths
if ( length(lonp)  == length(lonv) )  xmax <- length(lonp)  else print("Longitudes not equal")
if ( length(latp)  == length(latv) )  ymax <- length(latp)  else print("Latitudes not equal")
if ( length(levp)  == length(levv) )  zmax <- length(levp)  else print("Levels not equal")
if ( length(timep) == length(timev) ) tmax <- length(timep) else print("Times not equal")

# set counters to NULL
it <- NULL; iy <- NULL; ix <- NULL; ip <- NULL
i <- NULL; j <- NULL

# set variables 
p1 <- NULL; p2 <- NULL; zm <- FALSE

# hard code the N48/Obs co-ords
xmax <- 96; ymax <- 73

# create empty array's to fill with data
newvv  <- array(as.numeric(NA), dim=c(ymax,pmax,tmax))
pp     <- array(as.numeric(NA), dim=c(ymax,zmax,tmax))
vv     <- array(as.numeric(NA), dim=c(ymax,zmax,tmax))

# Main code here -------------------------------------------------------------------------------------- #
# loop over all time steps
print ("start loop over pressure")
for (it in 1:tmax) {
   print (paste("Time step: ",it,sep=""))

# read pressure and variable     
         pp <- get.var.ncdf( nc1, "p",      start=c(1,1,1,it),count=c(xmax,ymax,zmax,1) )
	  pp <- apply(pp,c(2,3),mean)
         print(str(pp))
         vv <- var[,,,it:1] 
	  vv <- apply(vv,c(2,3),mean)
         print(str(vv))

# loop over longitude and latitude
      for (iy in 1:ymax) {

# loop over pressure
            for (ip in 1:pmax) {

# determine the interval, loop over model levels and interpolate linear in log(p)
            ptarget = log(pres[ip])
             for (iz in 2:zmax) {
	         p1=log(pp[iy,iz-1]/100.) # NOTE conversion to hPa
	         p2=log(pp[iy,iz  ]/100.)
		if ( ptarget <= p1 ) {
			if ( ptarget >= p2 ) {
			newvv[iy,ip,it] = vv[iy,iz-1] + ( ( (vv[iy,iz] - vv[iy,iz-1] )/(p2-p1))*(ptarget-p1) )

		    } # end if
		  } # end if/while
	       }# end do model level loop
            } # end do pressure loop
         } # end do latitude loop
 } # end do loop over time
# end of main code ----------------------------------------------------------------------------------- #

















