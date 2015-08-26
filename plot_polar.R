# R script to convert a 2-D field onto a 
# polar projection.

# Based in parts on the clim.pact, satellite function

# Alex Archibald, CAS, July 2012

# need to pass in:
# lon, lat -- model coords
# var -- array to re-map2
# lat.0 -- lower latitude to re-map
# NH -- logical for NH or SH

require(fields)
require(akima)
require(maps)
require(mapproj)

# set the lat and lon of the world map -- used for background map
data(world.dat)
lat.cont <- world.dat$y ; lon.cont <- world.dat$x

# calculate the lengths of the model physical dimensions
nx <- length(lon); ny <- length(lat)

# create a set of lon*lat 1-D arrays of each lon at every lat and 
# each lat at every lon etc
lonx <- rep(lon,ny); latx <- sort(rep(lat,nx))

# check for NH projection?
if (!NH) latx <- -latx
if (!NH) lat.cont <- -lat.cont
if (!NH) lon.cont <- -lon.cont
if (!NH) lonx <- -lonx

# re-grid onto a polar projection
r <- sin( pi*(90-latx)/180 )
x <- r*sin(pi*lonx/180)
y <- -r*cos(pi*lonx/180)
x.grd <- seq(-sin( pi*(90-lat.0)/180 ),sin( pi*(90-lat.0)/180 ),by=0.01)
y.grd <- x.grd

# set Z to the variable being passed in
Z <- c(var)

xylims <- max(r)*c(-1,1)
nxy <- length(x.grd)
good <- is.finite(Z) & (latx>lat.0)
polar <- interp(x[good],y[good],Z[good],x.grd,y.grd,duplicate="mean")$z

# set object to plot
map <- polar

# do the same for the world map data
ok <- is.finite(lon.cont) & is.finite(lat.cont)  & (lat.cont>lat.0)
lat.cont <- abs(lat.cont)
lon.cont[!ok] <-  -9999; lat.cont[!ok] <-  -9999
lon.cont[lon.cont > 180] <- lon.cont[lon.cont > 180] - 360
lon.cont[!ok] <- NA; lat.cont[!ok] <- NA

r <- sin( pi*(90-lat.cont)/180 )
x.cont <- r*sin(pi*(lon.cont)/180)
y.cont <- -r*cos(pi*(lon.cont)/180)

# plot the data
#image.plot(x.grd, y.grd, map, xlab="", ylab="", main=main.text, col=tau.cols(12), xlim=xylims, ylim=xylims, xaxt="n", yaxt="n", frame.plot=FALSE, zlim=zlim)
#contour(x.grd, y.grd, map, add=TRUE, lwd=1.5, col="gray")
#lines(x.cont, y.cont, col="black")

#plot the data
filled.contour3(x.grd, y.grd, map, xlab="", ylab="", main="", color=cont.cols, xlim=xylims, ylim=xylims, zlim=zlim, axes=FALSE) #xaxt="n", yaxt="n", frame.plot=FALSE )
contour(x.grd, y.grd, map, add=TRUE, lwd=1.5, col="gray")
lines(x.cont, y.cont, col="black")
#The xpd=NA allows for writing outside the plot limits, but still using the the x and y axes to place the text
par(xpd=NA)
text(0,-1.1, paste(main.text, "Min =",sprintf("%1.3g", min(map, na.rm=T) ), "Max =", sprintf("%1.3g", max(map, na.rm=T) ), sep=" ") )
