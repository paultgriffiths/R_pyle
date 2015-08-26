# R Script to interpolate pressure data 
# Alex Archibald, January 2012

library(ncdf)

mod.name <- "xgywk"

nc1 <- open.ncdf("/data/ata27/xgywk/xgywk_evaluation_output.nc" ) 
var <- "field542"
species <- "clo"

# define pressure levels to interpolate onto NOTE these are in hPa!!
pres <- c(1000,850,700,500,400,300,250,200,170,150,130,115,100,90,80,70,50,30,20,15,10,7,5,3,2,1.5,1.0,0.5,0.3,0.2,0.1)
pmax <- length(pres)

# extract model co-ords
lonv  <- get.var.ncdf(nc1, "longitude")
latv  <- get.var.ncdf(nc1, "latitude")
levv  <- get.var.ncdf(nc1, "hybrid_ht")
timev <- get.var.ncdf(nc1, "t")

# check that the two variables have the same lengths
xmax <- length(lonv)  
ymax <- length(latv)  
zmax <- length(levv)  
tmax <- length(timev) 

# set counters to NULL
it <- NULL
iy <- NULL
ix <- NULL
ip <- NULL
iz <- NULL

# set variables 
p1 <- NULL
p2 <- NULL
zm <- FALSE

# create empty array's to fill with data
newvv <- array(as.numeric(NA), dim=c(ymax,pmax,tmax))
vv    <- array(as.numeric(NA), dim=c(ymax,zmax,tmax))

# Main code here -------------------------------------------------------------------------------------- #
# loop over all time steps
print ("start loop over pressure")
for (it in 1:tmax) {
   print (paste("Time step: ",it,sep=""))

# read pressure and variable     
         vv <- get.var.ncdf( nc1,var,start=c(1,1,1,it),count=c(xmax,ymax,zmax,1) )
#	  vv <- apply(vv,c(2,3),mean)
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


# write new variable in netcdf on pressure levels

# define the netcdf coordinate variables -- note these have values!
dim1 <- dim.def.ncdf( "latitude","degrees", as.double(latv))
dim2 <- dim.def.ncdf( "pressure","hPa", as.double(pres))
dim3 <- dim.def.ncdf( "time","years", as.double(timev))

# define new array to fill with data
temp <- var.def.ncdf("Temperature","K", list(dim1,dim2,dim3), -1, 
 longname="UKCA Interpolated Temperature")

# associate the netcdf variable with a netcdf file   
# put the interpolated variable into the file, and close
nc.ex <- create.ncdf( paste(mod.name,"_",species,"_pres_interp.nc",sep=""), temp )
put.var.ncdf(nc.ex, temp, newvv)
close.ncdf(nc.ex)

















