# R Script to plot the NOy and Total
# in model runs
# Alex Archibald, February 2012
# Updated 2015 to look at the d[NOy]/dt|chem

require(ncdf)
require(fields)

# Extract model variables and define constants, 
# loop vars
lat  <- get.var.ncdf(nc1, "latitude")
lon  <- get.var.ncdf(nc1, "longitude")
hgt  <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
time <- get.var.ncdf(nc1, "t")

# get the molar mass ratios (which are molar mass X/molar mass air)
source("~/Dropbox/r_scripts/ukca_evaluation/get_mol_masses.R")

# get the netCDF codes for the variables
source("~/Dropbox/r_scripts/ukca_evaluation/noy_species_names.R")

# set the conversion factors
conv <- 1E9 #ppb

# open files to do analysis with
nc1 <- open.ncdf("~/xjciv/dec_2005_noy_dchem.nc")
nc2 <- open.ncdf("~/xjciv/nald_dec_2005.nc")

no     <- get.var.ncdf(nc1,no.code)*(conv/mm.no) # convert to vmr
#no     <- apply(no,c(2,3),mean) # means the array and keeps dims 2 and 3
no2    <- get.var.ncdf(nc1,no2.code)*(conv/mm.no2) 
#no2    <- apply(no2,c(2,3),mean)
n2o5   <- get.var.ncdf(nc1,n2o5.code)*(conv/mm.n2o5)
#n2o5   <- apply(n2o5,c(2,3),mean)
no3    <- get.var.ncdf(nc1,no3.code)*(conv/mm.no3) 
#no3    <- apply(no3,c(2,3),mean)
ho2no2 <- get.var.ncdf(nc1,ho2no2.code)*(conv/mm.ho2no2)
#ho2no2 <- apply(ho2no2,c(2,3),mean)
hono2  <- get.var.ncdf(nc1,hono2.code)*(conv/mm.hono2)
#hono2  <- apply(hono2,c(2,3),mean)
brono2 <- get.var.ncdf(nc1,brono2.code)*(conv/mm.brono2)
#brono2 <- apply(brono2,c(2,3),mean)
clono2 <- get.var.ncdf(nc1,clono2.code)*(conv/mm.clono2)
#clono2 <- apply(clono2,c(2,3),mean)
n      <- get.var.ncdf(nc1,n.code)*(conv/mm.n)
#n      <- apply(n,c(2,3),mean)
#noy    <- get.var.ncdf(nc1,noy.code)*(conv/mm.no2) # convert to vmr of NO2!
#noy    <- apply(noy,c(2,3),mean)
hono   <- get.var.ncdf(nc1,hono.code)*(conv/mm.hono)
#hono   <- apply(hono,c(2,3),mean)
pan    <- get.var.ncdf(nc1,pan.code)*(conv/mm.pan)
#pan    <- apply(pan,c(2,3),mean)
ppan   <- get.var.ncdf(nc1,ppan.code)*(conv/mm.ppan)
#ppan   <- apply(ppan,c(2,3),mean)
meono2 <- get.var.ncdf(nc1,meono2.code)*(conv/mm.meono2)
#meono2 <- apply(meono2,c(2,3),mean)
ison   <- get.var.ncdf(nc1,ison.code)*(conv/mm.ison)
#ison   <- apply(ison,c(2,3),mean)
mpan   <- get.var.ncdf(nc1,mpan.code)*(conv/mm.mpan)
#mpan   <- apply(mpan,c(2,3),mean)
nald   <- get.var.ncdf(nc2,nald.code)*(conv/mm.nald)
#nald   <- apply(nald,c(2,3),mean)

# generate an array of the NOy
noy.calc <- (no+no2+(2*n2o5)+no3+ho2no2+hono2+hono+pan+ppan+meono2+
               ison+mpan+nald+brono2+clono2+n)

print(paste("Sum of d[NOy]/dt = ", sprintf("%1.1f", sum(noy.calc)) )

# sum the array over all lons
noy.sum <- apply(noy.calc, c(2,3), sum)

##########################################################
pdf(file="~/xjciv/xjciv_dec_2005_dNOy_chem.pdf", paper="a4",onefile=TRUE,pointsize=16)

#par(mfrow=c(2,2))
#par(oma=c(0,0,1,0)) 
#par(mgp = c(2, 1, 0))

#image.plot(lat, hgt, no, xlab="Latitude", ylab="Height /km", main="NO /ppb", col=temp.cols(51))
#image.plot(lat, hgt, no2, xlab="Latitude", ylab="Height /km", main="NO2 /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, n2o5, xlab="Latitude", ylab="Height /km", main="N2O5 /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, no3*1e3, xlab="Latitude", ylab="Height /km", main="NO3 /ppt", col=temp.cols(51) )
#image.plot(lat, hgt, ho2no2, xlab="Latitude", ylab="Height /km", main="HO2NO2 /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, hono2, xlab="Latitude", ylab="Height /km", main="HONO2 /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, brono2*1e3, xlab="Latitude", ylab="Height /km", main="BrONO2 /ppt", col=temp.cols(51) )
#image.plot(lat, hgt, clono2, xlab="Latitude", ylab="Height /km", main="ClONO2 /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, n*1e3, xlab="Latitude", ylab="Height /km", main="N /ppt", col=temp.cols(51) )
#image.plot(lat, hgt, noy, xlab="Latitude", ylab="Height /km", main="NOy (advt)", col=temp.cols(51) )
#image.plot(lat, hgt, noy.calc, xlab="Latitude", ylab="Height /km", main="NOy (calc)", col=temp.cols(51) )
#image.plot(lat, hgt, n2o, xlab="Latitude", ylab="Height /km", main="N2O", col=temp.cols(51) )
#image.plot(lat, hgt, hono, xlab="Latitude", ylab="Height /km", main="HONO /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, pan, xlab="Latitude", ylab="Height /km", main="PAN /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, ppan, xlab="Latitude", ylab="Height /km", main="PPAN /ppb", col=temp.cols(51) )
#image.plot(lat, hgt, meono2*1e3, xlab="Latitude", ylab="Height /km", main="MeONO2 /ppt", col=temp.cols(51) )
#image.plot(lat, hgt, ison*1e3, xlab="Latitude", ylab="Height /km", main="ISON /ppt", col=temp.cols(51) )
#image.plot(lat, hgt, mpan*1e3, xlab="Latitude", ylab="Height /km", main="MPAN /ppt", col=temp.cols(51) )
#image.plot(lat, hgt, nald, xlab="Latitude", ylab="Height /km", main="NALD /ppb", col=temp.cols(51) )
image.plot(lon, lat, noy.calc[,,1,1], xlab="Longitude", ylab="Latitude", main="Surface d[NOy]/dt")
image.plot(lon, lat, noy.calc[,,10,1], xlab="Longitude", ylab="Latitude", main="Free trop d[NOy]/dt")
image.plot(lat, hgt, noy.sum, xlab="Latitude", ylab="Height /km", main="Zonal sum d[NOy]/dt")

dev.off()

#q()
##########################################################
#pdf(file=paste(out.dir,mod1.name, "_N2O_NOy_Ratio.pdf", sep=""), paper="a4",onefile=TRUE,pointsize=20)
#
#plot(n2o[,1:22], noy[,1:22], col="gray", xlab="N2O /ppb", ylab="NOy /ppb", xlim=c(0,350), ylim=c(0,20), main="N2O/NOy")
#points(n2o[,23:31], noy[,23:31], col="lightblue")
#points(n2o[,32:40], noy[,32:40], col="pink")
#points(n2o[,41:47], noy[,41:47], col="yellow")
#points(n2o[,48:52], noy[,48:52], col="orange")

#legend("topright", c("0-10 km", "10-20 km", "20-30 km", "30-40 km", "40-50 km" ), lwd=2, col=c("gray", "lightblue", "pink", "yellow", "orange"), bty="n") 

#dev.off()
