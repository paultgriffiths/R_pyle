# R Script to interpolate a model variable 
# onto user defined pressure levels 

# Alex Archibald, May 2012

library(ncdf)

# Do you want to write the interpolated variable to an output file? T or F
write.2.file <- TRUE

# Enter a model name for writing a netcdf output
mod.name <- "xgyws"

# location to send output
#out.dir <- paste("/data/ata27/",mod.name,"/",sep="")
out.dir <- "/data/ata27/"

nc1   <- open.ncdf(paste("/data/ata27/",mod.name,"/",mod.name,"_evaluation_output.nc", sep=""), readunlim=FALSE ) 

# set the name of the variable in the netCDF file you want to interpolate onto pressure
var      <- "tracer1"
var.name <- "ozone"
units    <- "kg/kg" 

# ############################################################################################################################################

# define pressure levels to interpolate onto NOTE these are in hPa!!
#pres <- c(1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10,7,5,3,2,1.5,1.0,0.5,0.3,0.2,0.1)
pres <- c(1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10)
#pres <- c(1000,850,700,500,400,300,250,200,170,150,130,115,100,90,80,70,50,30,20,15,10,7,5,3,2,1.5,1.0,0.5,0.3,0.2,0.1)
pmax <- length(pres)

# extract model co-ords
lonv  <- get.var.ncdf(nc1, "longitude")
latv  <- get.var.ncdf(nc1, "latitude")
levv  <- get.var.ncdf(nc1, "hybrid_ht")
timev <- get.var.ncdf(nc1, "t")

# set lengths of dims
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
newvv <- array(as.numeric(NA), dim=c(xmax,ymax,pmax,tmax))


# Main code here -------------------------------------------------------------------------------------- #
# loop over all time steps
print ("start loop over pressure")
for (it in 1:tmax) {
   print (paste("Time step: ",it,sep=""))

# read pressure and variable (NB assume that pressure is called "p" in netCDF file)    
         pp <- get.var.ncdf( nc1,"p",      start=c(1,1,1,it),count=c(xmax,ymax,zmax,1) )
         print(str(pp))
         vv <- get.var.ncdf( nc1,var,      start=c(1,1,1,it),count=c(xmax,ymax,zmax,1) )
         print(str(vv))

# loop over longitude and latitude
      for (iy in 1:ymax) {
          for (ix in 1:xmax) {

# loop over pressure
            for (ip in 1:pmax) {

# determine the interval, loop over model levels and interpolate linear in log(p)
            ptarget = log(pres[ip])
             for (iz in 2:zmax) {
	         p1=log(pp[ix,iy,iz-1]/100.) # NOTE conversion to hPa
	         p2=log(pp[ix,iy,iz  ]/100.)
		if ( ptarget < p1 ) {
			if ( ptarget >= p2 ) {
			newvv[ix,iy,ip,it] = vv[ix,iy,iz-1] + ( ( (vv[ix,iy,iz] - vv[ix,iy,iz-1] )/(p2-p1))*(ptarget-p1) )
		    } # end if
		  } # end if/while
	       }# end do model level loop
            } # end do pressure loop
           } # end do longitude loop 
         } # end do latitude loop
 } # end do loop over time
# end of main code ----------------------------------------------------------------------------------- #


if (write.2.file==TRUE) {

# write new variable in netcdf on pressure levels
# define the netcdf coordinate variables -- note these have values!
dim1 <- dim.def.ncdf( "longitude","degrees", as.double(lonv))
dim2 <- dim.def.ncdf( "latitude","degrees", as.double(latv))
dim3 <- dim.def.ncdf( "pressure","hPa", as.double(pres))
dim4 <- dim.def.ncdf( "time","years", as.double(timev))

# define new array to fill with data
temp <- var.def.ncdf(var, units, list(dim1,dim2,dim3,dim4), -1, 
 longname=paste("UKCA pressure interpolated ", var.name, sep="") )

# associate the netcdf variable with a netcdf file   
# put the interpolated variable into the file, and close
nc.ex <- create.ncdf( paste(out.dir, mod.name,"_pres_interp_", var.name, ".nc",sep=""), temp )
put.var.ncdf(nc.ex, temp, newvv)
close.ncdf(nc.ex)

}


q()
