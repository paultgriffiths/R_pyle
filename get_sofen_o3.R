# R script to open the Sofen and Evans O3 database. 

# we want to use this script to load the montly median O3 data from the Sofen dataset
# and then query the 
require(ncdf4)
require(ncdf)
require(RColorBrewer)
source("~/Dropbox/r_scripts/ukca_evaluation/ukca_eval_functions.R")
source("~/Dropbox/r_scripts/ukca_evaluation/get_mol_masses.R")
require(plotrix)

nc1 <- open.ncdf("~/Desktop/xgywn_evaluation_output.nc")
lon <- get.var.ncdf(nc1, "longitude")
lat <- get.var.ncdf(nc1, "latitude")
time <- get.var.ncdf(nc1, "t")
#mod.date <- as.POSIXct(time, origin="1970-01-01 00:00")
# set model date
mod.date <- as.POSIXct("2000-01-01")

# extract the model field and convert the model arrays
mod.o3 <- re.grid.map(get.var.ncdf(nc1, "tracer1"), lon)*1E9/mm.o3
mod.o3 <- mod.o3[,,1,]
mod.o3 <- apply(mod.o3, c(1,2), mean)
# generate an array of the max-min of the monthly mean data
#mod.o3 <- apply(mod.o3, c(1,2), function(x) max(x)-min(x) )

# modify the lat/lon arrays to reflect the mid point values
d.lat <- (lat[2]-lat[1])/2
mod.lat <- lat+d.lat

# wrap the lon array
mid.lon <- which(lon>=180)[1]
d.lon <- (mod.lon[2]-mod.lon[1])/2
lon2 <- seq(-180,180-(d.lon*2),(2*d.lon) )#abind(new.array <- abind(lon[mid.lon:length(lon)], lon[1:mid.lon-1], along=1))
mod.lon <- lon2+d.lon

# Now illustrate some manipulations of the var.ncdf object
data.file <- "~/Downloads/CCMI_SurfaceOzoneObs_25x375_UKCA_Annual_v2.4.nc"
nc <- nc_open(data.file)

# loop through the data file and pull out attributes
i <- 1
while(i <= length(nc$dim) ) {
  print(i)
  if( nc$dim[[i]]$name=="longitude") {
    lon.id <-i
    dat.lon <- nc$dim[[lon.id]]$vals }
  if( nc$dim[[i]]$name=="latitude") {
    lat.id <-i
    dat.lat <- nc$dim[[lat.id]]$vals }
  if( nc$dim[[i]]$name=="time") {
    t.id <-i    
    time <- nc$dim[[t.id]]$vals
    dat.dates<- as.POSIXct(time, origin = "1970-01-01") }
  i<-i+1 
}

# extract the median ozone from the data file
dat.o3 <- ncvar_get(nc, "Mean_Gridded_Ozone")

# find the id of the data date which matches the model data
dat.id <- which(dat.dates>mod.date)[1]

# select just the data for the model date
dat.o3 <- dat.o3[,,dat.id:dat.id+11]

# reform the model data array
dat.o3 <- t(dat.o3)

# generate a mask where there is data
mask <- !is.na(dat.o3)

#image.plot(dat.lon, dat.lat, dat.o3)
#world(add=T)

#image.plot(mod.lon, mod.lat, mod.o3)
#world(add=T)

# obs data are on slightly different grid so have cut the top model row
mod.o3 <- mod.o3[1:96, 1:72]

# generate a differnce field (mod-obs)
diff.o3 <- mod.o3 - dat.o3

# mask the model data
mod.o3.raw <- mod.o3
mod.o3 <- mod.o3*mask

pdf("~/xgywn_ozone_map_plot_mean.pdf", width=8,height=6,
    paper="special",onefile=TRUE,pointsize=12)



plot.breaks <- seq(-25,25,1)
cus.cols <- rev(colorRampPalette(brewer.pal(9,"RdBu"))(length(plot.breaks)-1))
cus.cols2 <- colorRampPalette(brewer.pal(9,"Reds"))(15)



image.plot(mod.lon, mod.lat, mod.o3.raw, col=cus.cols2,
           zlim=c(0,60), xlab="Longitude",
           ylab="Latitude")
world(add=T)

image.plot(mod.lon, mod.lat, dat.o3, col=cus.cols2, 
           zlim=c(0,60), xlab="Longitude",
           ylab="Latitude")
world(add=T)

image.plot(mod.lon, mod.lat, mod.o3, col=cus.cols2,
           zlim=c(0,60), xlab="Longitude",
           ylab="Latitude")
world(add=T)

image.plot(mod.lon, mod.lat, diff.o3, col=cus.cols, 
           zlim=c(min(plot.breaks),max(plot.breaks)), breaks=plot.breaks, xlab="Longitude",
           ylab="Latitude")
world(add=T)

image.plot(mod.lon, mod.lat, diff.o3, col=cus.cols, xlim=c(-10,50), ylim=c(20,60),
           zlim=c(min(plot.breaks),max(plot.breaks)), breaks=plot.breaks, xlab="Longitude",
           ylab="Latitude")
world(add=T)

image.plot(mod.lon, mod.lat, diff.o3, col=cus.cols, xlim=c(-140,-50), ylim=c(20,60),
           zlim=c(min(plot.breaks),max(plot.breaks)), breaks=plot.breaks, xlab="Longitude",
           ylab="Latitude")
world(add=T)


# vectorise the data
dato3 <- c(dat.o3)
modo3 <- c(mod.o3)

fit.o3 <- lm(modo3 ~ dato3)

#pdf("~/xgywn_ozone_scatter_plot.pdf", width=8,height=6,
#    paper="special",onefile=TRUE,pointsize=12)
plot(dato3, modo3, xlim=c(0,55), ylim=c(0,55), 
     xlab="Observations (ppb)", ylab="UKCA (ppb)")
lines(c(seq(0:60)), c(seq(0:60)), col="grey", lwd=0.8)
lines(c(seq(0:60)), c(seq(0,30,0.5)), col="grey", lwd=0.8)
lines(c(seq(0,30,0.5)), c(seq(0:60)), col="grey", lwd=0.8)
par(xpd=NA)
text(30, 60, paste("Mean bias =", sprintf(fmt = "%.3f", mean(diff.o3, na.rm=T)), "(ppb)" ))
par(xpd=FALSE)
grid()
abline(fit.o3, col="red", lwd=2)
#dev.off()


dev.off()

modo3[modo3==0]<-NA
modo3.2 <- modo3[!is.na(modo3)]

dato3[dato3==0]<-NA
dato3.2 <- dato3[!is.na(dato3)]

taylor.diagram(dato3.2, modo3.2, normalize = TRUE)

plot(dato3.2, modo3.2)
abline(lm(modo3.2 ~ dato3.2), col="red")