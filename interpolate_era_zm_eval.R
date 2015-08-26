# R Script to interpolate ERA pressure data 
# onto UM 12 level grid.

# Alex Archibald, February 2012

# hard coded here for nc0 (i.e. the Observation data...)

# length of pressure array (passed in)
pmax <- length(pres)

# extract model co-ords
lonv  <- get.var.ncdf(nc0, "lon")
latv  <- get.var.ncdf(nc0, "lat")
levv  <- get.var.ncdf(nc0, "lev")*1E-2
timev <- get.var.ncdf(nc0, "time")

# set max lengths
xmax <- length(lonv)  
ymax <- length(latv)  
zmax <- length(levv)  
tmax <- length(timev) 

# set counters to NULL
it <- NULL; iy <- NULL; ix <- NULL; ip <- NULL; iz <- NULL

# set variables 
p1 <- NULL; p2 <- NULL

# create empty array's to fill with data
newvv <- array(as.numeric(NA), dim=c(ymax,pmax,tmax))
vv    <- array(as.numeric(NA), dim=c(ymax,zmax,tmax))

# Main code here -------------------------------------------------------------------------------------- #
# loop over all time steps
print ("start loop over pressure")
for (it in 1:tmax) {
   print (paste("Time step: ",it,sep=""))

# read pressure and variable     
         vv <- get.var.ncdf( nc0,var,start=c(1,1,1,it),count=c(xmax,ymax,zmax,1) )
         print(str(vv))

# loop over longitude and latitude
      for (iy in 1:ymax) {

# loop over pressure
            for (ip in 1:pmax) {

# determine the interval, loop over model levels and interpolate linear in log(p)
            ptarget = log(pres[ip])
             for (iz in 2:zmax) {
	         p1=log(levv[iz-1]) # NOTE conversion to hPa
	         p2=log(levv[iz  ])
		if ( ptarget <= p1 ) {
			if ( ptarget > p2 ) {
			newvv[iy,ip,it] = vv[iy,iz-1] + ( ( (vv[iy,iz] - vv[iy,iz-1] )/(p2-p1))*(ptarget-p1) )
		    } # end if
		  } # end if/while
	       }# end do model level loop
            } # end do pressure loop
         } # end do latitude loop
 } # end do loop over time

# End of main code ----------------------------------------------------------------------------------- #

















