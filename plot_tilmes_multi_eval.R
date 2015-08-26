# R script to perform a Tilmes (2011)
# comparison of model O3 to sondes.

# Alex Archibald, CAS, July 2012

library(ncdf)
library(fields)
library(abind)

# set the working directory for output (default to directory of this script)
out.dir <- "/data/ata27/"
obs.dir <- paste(obs.dir, ""

# enter name of modelsand some info for legends 
mod1.name <- "xgpal"
mod2.name <- "xgywo"
mod3.name <- "xgywn"

mod1.type <- "CheT"
mod2.type <- "CheS"
mod3.type <- "CheST"

# source a list of the molecular masses used in UKCA for tracers
source(paste(script.dir, "get_mol_masses.R", sep=""))
source(paste(script.dir, "tracer_var_codes.R", sep=""))

nc1 <- open.ncdf(paste("/data/ata27/",mod1.name,"/",mod1.name,"_pres_interp_ozone.nc", sep=""), readunlim=FALSE) 
nc2 <- open.ncdf(paste("/data/ata27/",mod2.name,"/",mod2.name,"_pres_interp_ozone.nc", sep=""), readunlim=FALSE) 
nc3 <- open.ncdf(paste("/data/ata27/",mod3.name,"/",mod3.name,"_pres_interp_ozone.nc", sep=""), readunlim=FALSE)

# constants and vars
conv <- 1E9

# extract variables
lon <- get.var.ncdf(nc1, "longitude")
lat <- get.var.ncdf(nc1, "latitude")
lev <- get.var.ncdf(nc1, "pressure")
time <- get.var.ncdf(nc1, "time") 

mod1.o3 <- get.var.ncdf(nc1, o3.code)*(conv/mm.o3)
mod2.o3 <- get.var.ncdf(nc2, o3.code)*(conv/mm.o3)
mod3.o3 <- get.var.ncdf(nc3, o3.code)*(conv/mm.o3)

# find the index for the mid latitude in the array
midlon <- which(lon>=180.0)[1]
maxlon <- length(lon)
dellon <- lon[2]-lon[1]
dellat <- lat[2] - lat[1]
# reform array - centers the array on the meridian
mod1.o3  <- abind(mod1.o3[midlon:maxlon,,,], mod1.o3[1:midlon-1,,,], along=1)
lon <- seq(-180,180-dellon,dellon)

# set up labels for months
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")

# extract the obs
sh.pol.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/sh_polar1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
sh.pol.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/sh_polar1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
sh.mid.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/sh_midlat1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
sh.mid.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/sh_midlat1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
tropics2.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/tropics21995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
tropics2.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/tropics21995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
tropics3.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/tropics31995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
tropics3.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/tropics31995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
eastus.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/eastern_us1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
eastus.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/eastern_us1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
japan.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/japan1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
japan.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/japan1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
westeu.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/west_europe1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
westeu.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/west_europe1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
canada.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/canada1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
canada.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/canada1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
nh.pol.e.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/nh_polar_east1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
nh.pol.e.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/nh_polar_east1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])
nh.pol.w.mean <- t(read.table(paste(obs.dir, "Tilmes_Ozone/nh_polar_west1995_2011.asc", sep=""), skip=33, header=FALSE, nrows=26)[,2:13])
nh.pol.w.sd   <- t(read.table(paste(obs.dir, "Tilmes_Ozone/nh_polar_west1995_2011.asc", sep=""), skip=114, header=FALSE, nrows=26)[,2:13])

# source the model locations
fields <- read.csv("tilmes_locations.R")

# convert "real" lats and longs to model grid boxes
fields$mLat1 <- (round (  ((fields$lat1 +90)/dellat)  ))+1
fields$mLat2 <- (round (  ((fields$lat2 +90)/dellat)  ))+1

fields$mLon1 <- ifelse ( fields$lon1<0, (round( ((fields$lon1+360)/dellon)-0.5))+1, (round( ((fields$lon1/dellon)-0.5) ))+1  )
fields$mLon2 <- ifelse ( fields$lon2<0, (round( ((fields$lon2+360)/dellon)-0.5))+1, (round( ((fields$lon2/dellon)-0.5) ))+1  )

# use split to convert the location data frame into a series of data frames split by the
# region
stations <- split(fields[], fields$region)

# extract the model fields
sh.pol.mod1.mean <- apply(mod1.o3[stations$sh.pol$mLon1:stations$sh.pol$mLon2, stations$sh.pol$mLat1:stations$sh.pol$mLat2, ,], c(3,4), mean, na.rm=T)
sh.mid.mod1.mean <- apply(mod1.o3[stations$sh.mid$mLon1:stations$sh.mid$mLon2, stations$sh.mid$mLat1:stations$sh.mid$mLat2, ,], c(3,4), mean, na.rm=T)
tropics2.mod1.mean <- apply(mod1.o3[stations$tropics2$mLon1:stations$tropics2$mLon2, stations$tropics2$mLat1:stations$tropics2$mLat2, ,], c(3,4), mean, na.rm=T)
tropics3.mod1.mean <- apply(mod1.o3[stations$tropics3$mLon1:stations$tropics3$mLon2, stations$tropics3$mLat1:stations$tropics3$mLat2, ,], c(3,4), mean, na.rm=T)
eastus.mod1.mean <- apply(mod1.o3[stations$eastus$mLon1:stations$eastus$mLon2, stations$eastus$mLat1:stations$eastus$mLat2, ,], c(3,4), mean, na.rm=T)
japan.mod1.mean <- apply(mod1.o3[stations$japan$mLon1:stations$japan$mLon2, stations$japan$mLat1:stations$japan$mLat2, ,], c(3,4), mean, na.rm=T)
westeu.mod1.mean <- apply(mod1.o3[stations$westeu$mLon1:stations$westeu$mLon2, stations$westeu$mLat1:stations$westeu$mLat2, ,], c(3,4), mean, na.rm=T)
canada.mod1.mean <- apply(mod1.o3[stations$canada$mLon1:stations$canada$mLon2, stations$canada$mLat1:stations$canada$mLat2, ,], c(3,4), mean, na.rm=T)
nh.pol.e.mod1.mean <- apply(mod1.o3[stations$nh.pol.e$mLon1:stations$nh.pol.e$mLon2, stations$nh.pol.e$mLat1:stations$nh.pol.e$mLat2, ,], c(3,4), mean, na.rm=T)
nh.pol.w.mod1.mean <- apply(mod1.o3[stations$nh.pol.w$mLon1:stations$nh.pol.w$mLon2, stations$nh.pol.w$mLat1:stations$nh.pol.w$mLat2, ,], c(3,4), mean, na.rm=T)

sh.pol.mod1.sd <- apply(mod1.o3[stations$sh.pol$mLon1:stations$sh.pol$mLon2, stations$sh.pol$mLat1:stations$sh.pol$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
sh.mid.mod1.sd <- apply(mod1.o3[stations$sh.mid$mLon1:stations$sh.mid$mLon2, stations$sh.mid$mLat1:stations$sh.mid$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
tropics2.mod1.sd <- apply(mod1.o3[stations$tropics2$mLon1:stations$tropics2$mLon2, stations$tropics2$mLat1:stations$tropics2$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
tropics3.mod1.sd <- apply(mod1.o3[stations$tropics3$mLon1:stations$tropics3$mLon2, stations$tropics3$mLat1:stations$tropics3$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
eastus.mod1.sd <- apply(mod1.o3[stations$eastus$mLon1:stations$eastus$mLon2, stations$eastus$mLat1:stations$eastus$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
japan.mod1.sd <- apply(mod1.o3[stations$japan$mLon1:stations$japan$mLon2, stations$japan$mLat1:stations$japan$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
westeu.mod1.sd <- apply(mod1.o3[stations$westeu$mLon1:stations$westeu$mLon2, stations$westeu$mLat1:stations$westeu$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
canada.mod1.sd <- apply(mod1.o3[stations$canada$mLon1:stations$canada$mLon2, stations$canada$mLat1:stations$canada$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
nh.pol.e.mod1.sd <- apply(mod1.o3[stations$nh.pol.e$mLon1:stations$nh.pol.e$mLon2, stations$nh.pol.e$mLat1:stations$nh.pol.e$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
nh.pol.w.mod1.sd <- apply(mod1.o3[stations$nh.pol.w$mLon1:stations$nh.pol.w$mLon2, stations$nh.pol.w$mLat1:stations$nh.pol.w$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )

# calc stats
# correlation
cor.mod1.sh.pol.250 <- cor(sh.pol.mean[,11], sh.pol.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.sh.pol.500 <- cor(sh.pol.mean[,6], sh.pol.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.sh.pol.700 <- cor(sh.pol.mean[,4], sh.pol.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.sh.pol.900 <- cor(sh.pol.mean[,2], sh.pol.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.sh.mid.250 <- cor(sh.mid.mean[,11], sh.mid.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.sh.mid.500 <- cor(sh.mid.mean[,6], sh.mid.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.sh.mid.700 <- cor(sh.mid.mean[,4], sh.mid.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.sh.mid.900 <- cor(sh.mid.mean[,2], sh.mid.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.tropics2.250 <- cor(tropics2.mean[,11], tropics2.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.tropics2.500 <- cor(tropics2.mean[,6], tropics2.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.tropics2.700 <- cor(tropics2.mean[,4], tropics2.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.tropics2.900 <- cor(tropics2.mean[,2], tropics2.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.tropics3.250 <- cor(tropics3.mean[,11], tropics3.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.tropics3.500 <- cor(tropics3.mean[,6], tropics3.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.tropics3.700 <- cor(tropics3.mean[,4], tropics3.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.tropics3.900 <- cor(tropics3.mean[,2], tropics3.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.eastus.250 <- cor(eastus.mean[,11], eastus.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.eastus.500 <- cor(eastus.mean[,6], eastus.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.eastus.700 <- cor(eastus.mean[,4], eastus.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.eastus.900 <- cor(eastus.mean[,2], eastus.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.japan.250 <- cor(japan.mean[,11], japan.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.japan.500 <- cor(japan.mean[,6], japan.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.japan.700 <- cor(japan.mean[,4], japan.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.japan.900 <- cor(japan.mean[,2], japan.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.westeu.250 <- cor(westeu.mean[,11], westeu.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.westeu.500 <- cor(westeu.mean[,6], westeu.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.westeu.700 <- cor(westeu.mean[,4], westeu.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.westeu.900 <- cor(westeu.mean[,2], westeu.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.canada.250 <- cor(canada.mean[,11], canada.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.canada.500 <- cor(canada.mean[,6], canada.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.canada.700 <- cor(canada.mean[,4], canada.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.canada.900 <- cor(canada.mean[,2], canada.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.nh.pol.e.250 <- cor(nh.pol.e.mean[,11], nh.pol.e.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.nh.pol.e.500 <- cor(nh.pol.e.mean[,6], nh.pol.e.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.nh.pol.e.700 <- cor(nh.pol.e.mean[,4], nh.pol.e.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.nh.pol.e.900 <- cor(nh.pol.e.mean[,2], nh.pol.e.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod1.nh.pol.w.250 <- cor(nh.pol.w.mean[,11], nh.pol.w.mod1.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod1.nh.pol.w.500 <- cor(nh.pol.w.mean[,6], nh.pol.w.mod1.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod1.nh.pol.w.700 <- cor(nh.pol.w.mean[,4], nh.pol.w.mod1.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod1.nh.pol.w.900 <- cor(nh.pol.w.mean[,2], nh.pol.w.mod1.mean[5,],use="pairwise.complete.obs",method="pearson")

# mean bias error:
mbe.mod1.sh.pol.250 <- mean(sh.pol.mod1.mean[21,]-sh.pol.mean[,11])
mbe.mod1.sh.pol.500 <- mean(sh.pol.mod1.mean[16,]-sh.pol.mean[,6])
mbe.mod1.sh.pol.700 <- mean(sh.pol.mod1.mean[12,]-sh.pol.mean[,2])
mbe.mod1.sh.pol.900 <- mean(sh.pol.mod1.mean[5,]-sh.pol.mean[,2])

mbe.mod1.sh.mid.250 <- mean(sh.mid.mod1.mean[21,]-sh.mid.mean[,11])
mbe.mod1.sh.mid.500 <- mean(sh.mid.mod1.mean[16,]-sh.mid.mean[,6])
mbe.mod1.sh.mid.700 <- mean(sh.mid.mod1.mean[12,]-sh.mid.mean[,2])
mbe.mod1.sh.mid.900 <- mean(sh.mid.mod1.mean[5,]-sh.mid.mean[,2])

mbe.mod1.tropics2.250 <- mean(tropics2.mod1.mean[21,]-tropics2.mean[,11])
mbe.mod1.tropics2.500 <- mean(tropics2.mod1.mean[16,]-tropics2.mean[,6])
mbe.mod1.tropics2.700 <- mean(tropics2.mod1.mean[12,]-tropics2.mean[,2])
mbe.mod1.tropics2.900 <- mean(tropics2.mod1.mean[5,]-tropics2.mean[,2])

mbe.mod1.tropics3.250 <- mean(tropics3.mod1.mean[21,]-tropics3.mean[,11])
mbe.mod1.tropics3.500 <- mean(tropics3.mod1.mean[16,]-tropics3.mean[,6])
mbe.mod1.tropics3.700 <- mean(tropics3.mod1.mean[12,]-tropics3.mean[,2])
mbe.mod1.tropics3.900 <- mean(tropics3.mod1.mean[5,]-tropics3.mean[,2])

mbe.mod1.eastus.250 <- mean(eastus.mod1.mean[21,]-eastus.mean[,11])
mbe.mod1.eastus.500 <- mean(eastus.mod1.mean[16,]-eastus.mean[,6])
mbe.mod1.eastus.700 <- mean(eastus.mod1.mean[12,]-eastus.mean[,2])
mbe.mod1.eastus.900 <- mean(eastus.mod1.mean[5,]-eastus.mean[,2])

mbe.mod1.japan.250 <- mean(japan.mod1.mean[21,]-japan.mean[,11])
mbe.mod1.japan.500 <- mean(japan.mod1.mean[16,]-japan.mean[,6])
mbe.mod1.japan.700 <- mean(japan.mod1.mean[12,]-japan.mean[,2])
mbe.mod1.japan.900 <- mean(japan.mod1.mean[5,]-japan.mean[,2])

mbe.mod1.westeu.250 <- mean(westeu.mod1.mean[21,]-westeu.mean[,11])
mbe.mod1.westeu.500 <- mean(westeu.mod1.mean[16,]-westeu.mean[,6])
mbe.mod1.westeu.700 <- mean(westeu.mod1.mean[12,]-westeu.mean[,2])
mbe.mod1.westeu.900 <- mean(westeu.mod1.mean[5,]-westeu.mean[,2])

mbe.mod1.canada.250 <- mean(canada.mod1.mean[21,]-canada.mean[,11])
mbe.mod1.canada.500 <- mean(canada.mod1.mean[16,]-canada.mean[,6])
mbe.mod1.canada.700 <- mean(canada.mod1.mean[12,]-canada.mean[,2])
mbe.mod1.canada.900 <- mean(canada.mod1.mean[5,]-canada.mean[,2])

mbe.mod1.nh.pol.e.250 <- mean(nh.pol.e.mod1.mean[21,]-nh.pol.e.mean[,11])
mbe.mod1.nh.pol.e.500 <- mean(nh.pol.e.mod1.mean[16,]-nh.pol.e.mean[,6])
mbe.mod1.nh.pol.e.700 <- mean(nh.pol.e.mod1.mean[12,]-nh.pol.e.mean[,2])
mbe.mod1.nh.pol.e.900 <- mean(nh.pol.e.mod1.mean[5,]-nh.pol.e.mean[,2])

mbe.mod1.nh.pol.w.250 <- mean(nh.pol.w.mod1.mean[21,]-nh.pol.w.mean[,11])
mbe.mod1.nh.pol.w.500 <- mean(nh.pol.w.mod1.mean[16,]-nh.pol.w.mean[,6])
mbe.mod1.nh.pol.w.700 <- mean(nh.pol.w.mod1.mean[12,]-nh.pol.w.mean[,2])
mbe.mod1.nh.pol.w.900 <- mean(nh.pol.w.mod1.mean[5,]-nh.pol.w.mean[,2])
# ############################################################################################################################################
# extract the model fields
sh.pol.mod2.mean <- apply(mod2.o3[stations$sh.pol$mLon1:stations$sh.pol$mLon2, stations$sh.pol$mLat1:stations$sh.pol$mLat2, ,], c(3,4), mean, na.rm=T)
sh.mid.mod2.mean <- apply(mod2.o3[stations$sh.mid$mLon1:stations$sh.mid$mLon2, stations$sh.mid$mLat1:stations$sh.mid$mLat2, ,], c(3,4), mean, na.rm=T)
tropics2.mod2.mean <- apply(mod2.o3[stations$tropics2$mLon1:stations$tropics2$mLon2, stations$tropics2$mLat1:stations$tropics2$mLat2, ,], c(3,4), mean, na.rm=T)
tropics3.mod2.mean <- apply(mod2.o3[stations$tropics3$mLon1:stations$tropics3$mLon2, stations$tropics3$mLat1:stations$tropics3$mLat2, ,], c(3,4), mean, na.rm=T)
eastus.mod2.mean <- apply(mod2.o3[stations$eastus$mLon1:stations$eastus$mLon2, stations$eastus$mLat1:stations$eastus$mLat2, ,], c(3,4), mean, na.rm=T)
japan.mod2.mean <- apply(mod2.o3[stations$japan$mLon1:stations$japan$mLon2, stations$japan$mLat1:stations$japan$mLat2, ,], c(3,4), mean, na.rm=T)
westeu.mod2.mean <- apply(mod2.o3[stations$westeu$mLon1:stations$westeu$mLon2, stations$westeu$mLat1:stations$westeu$mLat2, ,], c(3,4), mean, na.rm=T)
canada.mod2.mean <- apply(mod2.o3[stations$canada$mLon1:stations$canada$mLon2, stations$canada$mLat1:stations$canada$mLat2, ,], c(3,4), mean, na.rm=T)
nh.pol.e.mod2.mean <- apply(mod2.o3[stations$nh.pol.e$mLon1:stations$nh.pol.e$mLon2, stations$nh.pol.e$mLat1:stations$nh.pol.e$mLat2, ,], c(3,4), mean, na.rm=T)
nh.pol.w.mod2.mean <- apply(mod2.o3[stations$nh.pol.w$mLon1:stations$nh.pol.w$mLon2, stations$nh.pol.w$mLat1:stations$nh.pol.w$mLat2, ,], c(3,4), mean, na.rm=T)

sh.pol.mod2.sd <- apply(mod2.o3[stations$sh.pol$mLon1:stations$sh.pol$mLon2, stations$sh.pol$mLat1:stations$sh.pol$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
sh.mid.mod2.sd <- apply(mod2.o3[stations$sh.mid$mLon1:stations$sh.mid$mLon2, stations$sh.mid$mLat1:stations$sh.mid$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
tropics2.mod2.sd <- apply(mod2.o3[stations$tropics2$mLon1:stations$tropics2$mLon2, stations$tropics2$mLat1:stations$tropics2$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
tropics3.mod2.sd <- apply(mod2.o3[stations$tropics3$mLon1:stations$tropics3$mLon2, stations$tropics3$mLat1:stations$tropics3$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
eastus.mod2.sd <- apply(mod2.o3[stations$eastus$mLon1:stations$eastus$mLon2, stations$eastus$mLat1:stations$eastus$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
japan.mod2.sd <- apply(mod2.o3[stations$japan$mLon1:stations$japan$mLon2, stations$japan$mLat1:stations$japan$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
westeu.mod2.sd <- apply(mod2.o3[stations$westeu$mLon1:stations$westeu$mLon2, stations$westeu$mLat1:stations$westeu$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
canada.mod2.sd <- apply(mod2.o3[stations$canada$mLon1:stations$canada$mLon2, stations$canada$mLat1:stations$canada$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
nh.pol.e.mod2.sd <- apply(mod2.o3[stations$nh.pol.e$mLon1:stations$nh.pol.e$mLon2, stations$nh.pol.e$mLat1:stations$nh.pol.e$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
nh.pol.w.mod2.sd <- apply(mod2.o3[stations$nh.pol.w$mLon1:stations$nh.pol.w$mLon2, stations$nh.pol.w$mLat1:stations$nh.pol.w$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )

# calc stats
# correlation
cor.mod2.sh.pol.250 <- cor(sh.pol.mean[,11], sh.pol.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.sh.pol.500 <- cor(sh.pol.mean[,6], sh.pol.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.sh.pol.700 <- cor(sh.pol.mean[,4], sh.pol.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.sh.pol.900 <- cor(sh.pol.mean[,2], sh.pol.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.sh.mid.250 <- cor(sh.mid.mean[,11], sh.mid.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.sh.mid.500 <- cor(sh.mid.mean[,6], sh.mid.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.sh.mid.700 <- cor(sh.mid.mean[,4], sh.mid.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.sh.mid.900 <- cor(sh.mid.mean[,2], sh.mid.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.tropics2.250 <- cor(tropics2.mean[,11], tropics2.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.tropics2.500 <- cor(tropics2.mean[,6], tropics2.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.tropics2.700 <- cor(tropics2.mean[,4], tropics2.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.tropics2.900 <- cor(tropics2.mean[,2], tropics2.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.tropics3.250 <- cor(tropics3.mean[,11], tropics3.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.tropics3.500 <- cor(tropics3.mean[,6], tropics3.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.tropics3.700 <- cor(tropics3.mean[,4], tropics3.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.tropics3.900 <- cor(tropics3.mean[,2], tropics3.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.eastus.250 <- cor(eastus.mean[,11], eastus.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.eastus.500 <- cor(eastus.mean[,6], eastus.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.eastus.700 <- cor(eastus.mean[,4], eastus.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.eastus.900 <- cor(eastus.mean[,2], eastus.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.japan.250 <- cor(japan.mean[,11], japan.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.japan.500 <- cor(japan.mean[,6], japan.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.japan.700 <- cor(japan.mean[,4], japan.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.japan.900 <- cor(japan.mean[,2], japan.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.westeu.250 <- cor(westeu.mean[,11], westeu.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.westeu.500 <- cor(westeu.mean[,6], westeu.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.westeu.700 <- cor(westeu.mean[,4], westeu.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.westeu.900 <- cor(westeu.mean[,2], westeu.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.canada.250 <- cor(canada.mean[,11], canada.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.canada.500 <- cor(canada.mean[,6], canada.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.canada.700 <- cor(canada.mean[,4], canada.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.canada.900 <- cor(canada.mean[,2], canada.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.nh.pol.e.250 <- cor(nh.pol.e.mean[,11], nh.pol.e.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.nh.pol.e.500 <- cor(nh.pol.e.mean[,6], nh.pol.e.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.nh.pol.e.700 <- cor(nh.pol.e.mean[,4], nh.pol.e.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.nh.pol.e.900 <- cor(nh.pol.e.mean[,2], nh.pol.e.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod2.nh.pol.w.250 <- cor(nh.pol.w.mean[,11], nh.pol.w.mod2.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod2.nh.pol.w.500 <- cor(nh.pol.w.mean[,6], nh.pol.w.mod2.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod2.nh.pol.w.700 <- cor(nh.pol.w.mean[,4], nh.pol.w.mod2.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod2.nh.pol.w.900 <- cor(nh.pol.w.mean[,2], nh.pol.w.mod2.mean[5,],use="pairwise.complete.obs",method="pearson")

# mean bias error:
mbe.mod2.sh.pol.250 <- mean(sh.pol.mod2.mean[21,]-sh.pol.mean[,11])
mbe.mod2.sh.pol.500 <- mean(sh.pol.mod2.mean[16,]-sh.pol.mean[,6])
mbe.mod2.sh.pol.700 <- mean(sh.pol.mod2.mean[12,]-sh.pol.mean[,2])
mbe.mod2.sh.pol.900 <- mean(sh.pol.mod2.mean[5,]-sh.pol.mean[,2])

mbe.mod2.sh.mid.250 <- mean(sh.mid.mod2.mean[21,]-sh.mid.mean[,11])
mbe.mod2.sh.mid.500 <- mean(sh.mid.mod2.mean[16,]-sh.mid.mean[,6])
mbe.mod2.sh.mid.700 <- mean(sh.mid.mod2.mean[12,]-sh.mid.mean[,2])
mbe.mod2.sh.mid.900 <- mean(sh.mid.mod2.mean[5,]-sh.mid.mean[,2])

mbe.mod2.tropics2.250 <- mean(tropics2.mod2.mean[21,]-tropics2.mean[,11])
mbe.mod2.tropics2.500 <- mean(tropics2.mod2.mean[16,]-tropics2.mean[,6])
mbe.mod2.tropics2.700 <- mean(tropics2.mod2.mean[12,]-tropics2.mean[,2])
mbe.mod2.tropics2.900 <- mean(tropics2.mod2.mean[5,]-tropics2.mean[,2])

mbe.mod2.tropics3.250 <- mean(tropics3.mod2.mean[21,]-tropics3.mean[,11])
mbe.mod2.tropics3.500 <- mean(tropics3.mod2.mean[16,]-tropics3.mean[,6])
mbe.mod2.tropics3.700 <- mean(tropics3.mod2.mean[12,]-tropics3.mean[,2])
mbe.mod2.tropics3.900 <- mean(tropics3.mod2.mean[5,]-tropics3.mean[,2])

mbe.mod2.eastus.250 <- mean(eastus.mod2.mean[21,]-eastus.mean[,11])
mbe.mod2.eastus.500 <- mean(eastus.mod2.mean[16,]-eastus.mean[,6])
mbe.mod2.eastus.700 <- mean(eastus.mod2.mean[12,]-eastus.mean[,2])
mbe.mod2.eastus.900 <- mean(eastus.mod2.mean[5,]-eastus.mean[,2])

mbe.mod2.japan.250 <- mean(japan.mod2.mean[21,]-japan.mean[,11])
mbe.mod2.japan.500 <- mean(japan.mod2.mean[16,]-japan.mean[,6])
mbe.mod2.japan.700 <- mean(japan.mod2.mean[12,]-japan.mean[,2])
mbe.mod2.japan.900 <- mean(japan.mod2.mean[5,]-japan.mean[,2])

mbe.mod2.westeu.250 <- mean(westeu.mod2.mean[21,]-westeu.mean[,11])
mbe.mod2.westeu.500 <- mean(westeu.mod2.mean[16,]-westeu.mean[,6])
mbe.mod2.westeu.700 <- mean(westeu.mod2.mean[12,]-westeu.mean[,2])
mbe.mod2.westeu.900 <- mean(westeu.mod2.mean[5,]-westeu.mean[,2])

mbe.mod2.canada.250 <- mean(canada.mod2.mean[21,]-canada.mean[,11])
mbe.mod2.canada.500 <- mean(canada.mod2.mean[16,]-canada.mean[,6])
mbe.mod2.canada.700 <- mean(canada.mod2.mean[12,]-canada.mean[,2])
mbe.mod2.canada.900 <- mean(canada.mod2.mean[5,]-canada.mean[,2])

mbe.mod2.nh.pol.e.250 <- mean(nh.pol.e.mod2.mean[21,]-nh.pol.e.mean[,11])
mbe.mod2.nh.pol.e.500 <- mean(nh.pol.e.mod2.mean[16,]-nh.pol.e.mean[,6])
mbe.mod2.nh.pol.e.700 <- mean(nh.pol.e.mod2.mean[12,]-nh.pol.e.mean[,2])
mbe.mod2.nh.pol.e.900 <- mean(nh.pol.e.mod2.mean[5,]-nh.pol.e.mean[,2])

mbe.mod2.nh.pol.w.250 <- mean(nh.pol.w.mod2.mean[21,]-nh.pol.w.mean[,11])
mbe.mod2.nh.pol.w.500 <- mean(nh.pol.w.mod2.mean[16,]-nh.pol.w.mean[,6])
mbe.mod2.nh.pol.w.700 <- mean(nh.pol.w.mod2.mean[12,]-nh.pol.w.mean[,2])
mbe.mod2.nh.pol.w.900 <- mean(nh.pol.w.mod2.mean[5,]-nh.pol.w.mean[,2])
# ############################################################################################################################################
# extract the model fields
sh.pol.mod3.mean <- apply(mod3.o3[stations$sh.pol$mLon1:stations$sh.pol$mLon2, stations$sh.pol$mLat1:stations$sh.pol$mLat2, ,], c(3,4), mean, na.rm=T)
sh.mid.mod3.mean <- apply(mod3.o3[stations$sh.mid$mLon1:stations$sh.mid$mLon2, stations$sh.mid$mLat1:stations$sh.mid$mLat2, ,], c(3,4), mean, na.rm=T)
tropics2.mod3.mean <- apply(mod3.o3[stations$tropics2$mLon1:stations$tropics2$mLon2, stations$tropics2$mLat1:stations$tropics2$mLat2, ,], c(3,4), mean, na.rm=T)
tropics3.mod3.mean <- apply(mod3.o3[stations$tropics3$mLon1:stations$tropics3$mLon2, stations$tropics3$mLat1:stations$tropics3$mLat2, ,], c(3,4), mean, na.rm=T)
eastus.mod3.mean <- apply(mod3.o3[stations$eastus$mLon1:stations$eastus$mLon2, stations$eastus$mLat1:stations$eastus$mLat2, ,], c(3,4), mean, na.rm=T)
japan.mod3.mean <- apply(mod3.o3[stations$japan$mLon1:stations$japan$mLon2, stations$japan$mLat1:stations$japan$mLat2, ,], c(3,4), mean, na.rm=T)
westeu.mod3.mean <- apply(mod3.o3[stations$westeu$mLon1:stations$westeu$mLon2, stations$westeu$mLat1:stations$westeu$mLat2, ,], c(3,4), mean, na.rm=T)
canada.mod3.mean <- apply(mod3.o3[stations$canada$mLon1:stations$canada$mLon2, stations$canada$mLat1:stations$canada$mLat2, ,], c(3,4), mean, na.rm=T)
nh.pol.e.mod3.mean <- apply(mod3.o3[stations$nh.pol.e$mLon1:stations$nh.pol.e$mLon2, stations$nh.pol.e$mLat1:stations$nh.pol.e$mLat2, ,], c(3,4), mean, na.rm=T)
nh.pol.w.mod3.mean <- apply(mod3.o3[stations$nh.pol.w$mLon1:stations$nh.pol.w$mLon2, stations$nh.pol.w$mLat1:stations$nh.pol.w$mLat2, ,], c(3,4), mean, na.rm=T)

sh.pol.mod3.sd <- apply(mod3.o3[stations$sh.pol$mLon1:stations$sh.pol$mLon2, stations$sh.pol$mLat1:stations$sh.pol$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
sh.mid.mod3.sd <- apply(mod3.o3[stations$sh.mid$mLon1:stations$sh.mid$mLon2, stations$sh.mid$mLat1:stations$sh.mid$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
tropics2.mod3.sd <- apply(mod3.o3[stations$tropics2$mLon1:stations$tropics2$mLon2, stations$tropics2$mLat1:stations$tropics2$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
tropics3.mod3.sd <- apply(mod3.o3[stations$tropics3$mLon1:stations$tropics3$mLon2, stations$tropics3$mLat1:stations$tropics3$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
eastus.mod3.sd <- apply(mod3.o3[stations$eastus$mLon1:stations$eastus$mLon2, stations$eastus$mLat1:stations$eastus$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
japan.mod3.sd <- apply(mod3.o3[stations$japan$mLon1:stations$japan$mLon2, stations$japan$mLat1:stations$japan$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
westeu.mod3.sd <- apply(mod3.o3[stations$westeu$mLon1:stations$westeu$mLon2, stations$westeu$mLat1:stations$westeu$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
canada.mod3.sd <- apply(mod3.o3[stations$canada$mLon1:stations$canada$mLon2, stations$canada$mLat1:stations$canada$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
nh.pol.e.mod3.sd <- apply(mod3.o3[stations$nh.pol.e$mLon1:stations$nh.pol.e$mLon2, stations$nh.pol.e$mLat1:stations$nh.pol.e$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )
nh.pol.w.mod3.sd <- apply(mod3.o3[stations$nh.pol.w$mLon1:stations$nh.pol.w$mLon2, stations$nh.pol.w$mLat1:stations$nh.pol.w$mLat2, ,], c(3,4), function(x) sd(as.vector(x), na.rm=T) )

# calc stats
# correlation
cor.mod3.sh.pol.250 <- cor(sh.pol.mean[,11], sh.pol.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.sh.pol.500 <- cor(sh.pol.mean[,6], sh.pol.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.sh.pol.700 <- cor(sh.pol.mean[,4], sh.pol.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.sh.pol.900 <- cor(sh.pol.mean[,2], sh.pol.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.sh.mid.250 <- cor(sh.mid.mean[,11], sh.mid.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.sh.mid.500 <- cor(sh.mid.mean[,6], sh.mid.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.sh.mid.700 <- cor(sh.mid.mean[,4], sh.mid.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.sh.mid.900 <- cor(sh.mid.mean[,2], sh.mid.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.tropics2.250 <- cor(tropics2.mean[,11], tropics2.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.tropics2.500 <- cor(tropics2.mean[,6], tropics2.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.tropics2.700 <- cor(tropics2.mean[,4], tropics2.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.tropics2.900 <- cor(tropics2.mean[,2], tropics2.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.tropics3.250 <- cor(tropics3.mean[,11], tropics3.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.tropics3.500 <- cor(tropics3.mean[,6], tropics3.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.tropics3.700 <- cor(tropics3.mean[,4], tropics3.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.tropics3.900 <- cor(tropics3.mean[,2], tropics3.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.eastus.250 <- cor(eastus.mean[,11], eastus.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.eastus.500 <- cor(eastus.mean[,6], eastus.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.eastus.700 <- cor(eastus.mean[,4], eastus.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.eastus.900 <- cor(eastus.mean[,2], eastus.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.japan.250 <- cor(japan.mean[,11], japan.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.japan.500 <- cor(japan.mean[,6], japan.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.japan.700 <- cor(japan.mean[,4], japan.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.japan.900 <- cor(japan.mean[,2], japan.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.westeu.250 <- cor(westeu.mean[,11], westeu.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.westeu.500 <- cor(westeu.mean[,6], westeu.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.westeu.700 <- cor(westeu.mean[,4], westeu.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.westeu.900 <- cor(westeu.mean[,2], westeu.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.canada.250 <- cor(canada.mean[,11], canada.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.canada.500 <- cor(canada.mean[,6], canada.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.canada.700 <- cor(canada.mean[,4], canada.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.canada.900 <- cor(canada.mean[,2], canada.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.nh.pol.e.250 <- cor(nh.pol.e.mean[,11], nh.pol.e.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.nh.pol.e.500 <- cor(nh.pol.e.mean[,6], nh.pol.e.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.nh.pol.e.700 <- cor(nh.pol.e.mean[,4], nh.pol.e.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.nh.pol.e.900 <- cor(nh.pol.e.mean[,2], nh.pol.e.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

cor.mod3.nh.pol.w.250 <- cor(nh.pol.w.mean[,11], nh.pol.w.mod3.mean[21,],use="pairwise.complete.obs",method="pearson")
cor.mod3.nh.pol.w.500 <- cor(nh.pol.w.mean[,6], nh.pol.w.mod3.mean[16,],use="pairwise.complete.obs",method="pearson")
cor.mod3.nh.pol.w.700 <- cor(nh.pol.w.mean[,4], nh.pol.w.mod3.mean[12,],use="pairwise.complete.obs",method="pearson")
cor.mod3.nh.pol.w.900 <- cor(nh.pol.w.mean[,2], nh.pol.w.mod3.mean[5,],use="pairwise.complete.obs",method="pearson")

# mean bias error:
mbe.mod3.sh.pol.250 <- mean(sh.pol.mod3.mean[21,]-sh.pol.mean[,11])
mbe.mod3.sh.pol.500 <- mean(sh.pol.mod3.mean[16,]-sh.pol.mean[,6])
mbe.mod3.sh.pol.700 <- mean(sh.pol.mod3.mean[12,]-sh.pol.mean[,2])
mbe.mod3.sh.pol.900 <- mean(sh.pol.mod3.mean[5,]-sh.pol.mean[,2])

mbe.mod3.sh.mid.250 <- mean(sh.mid.mod3.mean[21,]-sh.mid.mean[,11])
mbe.mod3.sh.mid.500 <- mean(sh.mid.mod3.mean[16,]-sh.mid.mean[,6])
mbe.mod3.sh.mid.700 <- mean(sh.mid.mod3.mean[12,]-sh.mid.mean[,2])
mbe.mod3.sh.mid.900 <- mean(sh.mid.mod3.mean[5,]-sh.mid.mean[,2])

mbe.mod3.tropics2.250 <- mean(tropics2.mod3.mean[21,]-tropics2.mean[,11])
mbe.mod3.tropics2.500 <- mean(tropics2.mod3.mean[16,]-tropics2.mean[,6])
mbe.mod3.tropics2.700 <- mean(tropics2.mod3.mean[12,]-tropics2.mean[,2])
mbe.mod3.tropics2.900 <- mean(tropics2.mod3.mean[5,]-tropics2.mean[,2])

mbe.mod3.tropics3.250 <- mean(tropics3.mod3.mean[21,]-tropics3.mean[,11])
mbe.mod3.tropics3.500 <- mean(tropics3.mod3.mean[16,]-tropics3.mean[,6])
mbe.mod3.tropics3.700 <- mean(tropics3.mod3.mean[12,]-tropics3.mean[,2])
mbe.mod3.tropics3.900 <- mean(tropics3.mod3.mean[5,]-tropics3.mean[,2])

mbe.mod3.eastus.250 <- mean(eastus.mod3.mean[21,]-eastus.mean[,11])
mbe.mod3.eastus.500 <- mean(eastus.mod3.mean[16,]-eastus.mean[,6])
mbe.mod3.eastus.700 <- mean(eastus.mod3.mean[12,]-eastus.mean[,2])
mbe.mod3.eastus.900 <- mean(eastus.mod3.mean[5,]-eastus.mean[,2])

mbe.mod3.japan.250 <- mean(japan.mod3.mean[21,]-japan.mean[,11])
mbe.mod3.japan.500 <- mean(japan.mod3.mean[16,]-japan.mean[,6])
mbe.mod3.japan.700 <- mean(japan.mod3.mean[12,]-japan.mean[,2])
mbe.mod3.japan.900 <- mean(japan.mod3.mean[5,]-japan.mean[,2])

mbe.mod3.westeu.250 <- mean(westeu.mod3.mean[21,]-westeu.mean[,11])
mbe.mod3.westeu.500 <- mean(westeu.mod3.mean[16,]-westeu.mean[,6])
mbe.mod3.westeu.700 <- mean(westeu.mod3.mean[12,]-westeu.mean[,2])
mbe.mod3.westeu.900 <- mean(westeu.mod3.mean[5,]-westeu.mean[,2])

mbe.mod3.canada.250 <- mean(canada.mod3.mean[21,]-canada.mean[,11])
mbe.mod3.canada.500 <- mean(canada.mod3.mean[16,]-canada.mean[,6])
mbe.mod3.canada.700 <- mean(canada.mod3.mean[12,]-canada.mean[,2])
mbe.mod3.canada.900 <- mean(canada.mod3.mean[5,]-canada.mean[,2])

mbe.mod3.nh.pol.e.250 <- mean(nh.pol.e.mod3.mean[21,]-nh.pol.e.mean[,11])
mbe.mod3.nh.pol.e.500 <- mean(nh.pol.e.mod3.mean[16,]-nh.pol.e.mean[,6])
mbe.mod3.nh.pol.e.700 <- mean(nh.pol.e.mod3.mean[12,]-nh.pol.e.mean[,2])
mbe.mod3.nh.pol.e.900 <- mean(nh.pol.e.mod3.mean[5,]-nh.pol.e.mean[,2])

mbe.mod3.nh.pol.w.250 <- mean(nh.pol.w.mod3.mean[21,]-nh.pol.w.mean[,11])
mbe.mod3.nh.pol.w.500 <- mean(nh.pol.w.mod3.mean[16,]-nh.pol.w.mean[,6])
mbe.mod3.nh.pol.w.700 <- mean(nh.pol.w.mod3.mean[12,]-nh.pol.w.mean[,2])
mbe.mod3.nh.pol.w.900 <- mean(nh.pol.w.mod3.mean[5,]-nh.pol.w.mean[,2])
# ############################################################################################################################################
pdf(file=paste(out.dir,mod1.name, "_", mod2.name, "_", mod3.name,"_Tilmes_ozone.pdf", sep=""),width=12,height=9,paper="special",onefile=TRUE,pointsize=13)

par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0.3,0.8,0.8,0.05), # global margins in inches (bottom, left, top, right)
       mai=c(0.01,0.01,0.01,0.01), # subplot margins in inches (bottom, left, top, right)
       mgp=c(2, 0.5, 0) )
layout(matrix(1:40, 4, 10, byrow = TRUE))


# 250 hPa plots
plot(1:12, sh.pol.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.pol.mean[,11]+sh.pol.sd[,11], rev(sh.pol.mean[,11]-sh.pol.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.pol.mean[,11])
lines(1:12, sh.pol.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (sh.pol.mod1.mean[21,]-sh.pol.mod1.sd[21,]), 1:12, (sh.pol.mod1.mean[21,]+sh.pol.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.pol.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (sh.pol.mod2.mean[21,]-sh.pol.mod2.sd[21,]), 1:12, (sh.pol.mod2.mean[21,]+sh.pol.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.pol.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (sh.pol.mod3.mean[21,]-sh.pol.mod3.sd[21,]), 1:12, (sh.pol.mod3.mean[21,]+sh.pol.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.250)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.250)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.250)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "South \nPole") 
text(-4,300, "Ozone (ppbv)", srt=90)
par(xpd=F)

plot(1:12, sh.mid.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.mid.mean[,11]+sh.mid.sd[,11], rev(sh.mid.mean[,11]-sh.mid.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.mid.mean[,11])
lines(1:12, sh.mid.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (sh.mid.mod1.mean[21,]-sh.mid.mod1.sd[21,]), 1:12, (sh.mid.mod1.mean[21,]+sh.mid.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.mid.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (sh.mid.mod2.mean[21,]-sh.mid.mod2.sd[21,]), 1:12, (sh.mid.mod2.mean[21,]+sh.mid.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.mid.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (sh.mid.mod3.mean[21,]-sh.mid.mod3.sd[21,]), 1:12, (sh.mid.mod3.mean[21,]+sh.mid.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.250)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.250)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.250)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "Southern \nMidlat") 
par(xpd=F)


plot(1:12, tropics2.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics2.mean[,11]+tropics2.sd[,11], rev(tropics2.mean[,11]-tropics2.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics2.mean[,11])
lines(1:12, tropics2.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (tropics2.mod1.mean[21,]-tropics2.mod1.sd[21,]), 1:12, (tropics2.mod1.mean[21,]+tropics2.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics2.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (tropics2.mod2.mean[21,]-tropics2.mod2.sd[21,]), 1:12, (tropics2.mod2.mean[21,]+tropics2.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics2.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (tropics2.mod3.mean[21,]-tropics2.mod3.sd[21,]), 1:12, (tropics2.mod3.mean[21,]+tropics2.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics2.250)," mbe =", sprintf("%1.3g", mbe.mod1.tropics2.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics2.250)," mbe =", sprintf("%1.3g", mbe.mod2.tropics2.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics2.250)," mbe =", sprintf("%1.3g", mbe.mod3.tropics2.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "Tropics2") 
par(xpd=F)


plot(1:12, tropics3.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics3.mean[,11]+tropics3.sd[,11], rev(tropics3.mean[,11]-tropics3.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics3.mean[,11])
lines(1:12, tropics3.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (tropics3.mod1.mean[21,]-tropics3.mod1.sd[21,]), 1:12, (tropics3.mod1.mean[21,]+tropics3.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics3.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (tropics3.mod2.mean[21,]-tropics3.mod2.sd[21,]), 1:12, (tropics3.mod2.mean[21,]+tropics3.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics3.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (tropics3.mod3.mean[21,]-tropics3.mod3.sd[21,]), 1:12, (tropics3.mod3.mean[21,]+tropics3.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics3.250)," mbe =", sprintf("%1.3g", mbe.mod1.tropics3.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics3.250)," mbe =", sprintf("%1.3g", mbe.mod2.tropics3.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics3.250)," mbe =", sprintf("%1.3g", mbe.mod3.tropics3.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "Tropics3") 
par(xpd=F)


plot(1:12, eastus.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(eastus.mean[,11]+eastus.sd[,11], rev(eastus.mean[,11]-eastus.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(eastus.mean[,11])
lines(1:12, eastus.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (eastus.mod1.mean[21,]-eastus.mod1.sd[21,]), 1:12, (eastus.mod1.mean[21,]+eastus.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, eastus.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (eastus.mod2.mean[21,]-eastus.mod2.sd[21,]), 1:12, (eastus.mod2.mean[21,]+eastus.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, eastus.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (eastus.mod3.mean[21,]-eastus.mod3.sd[21,]), 1:12, (eastus.mod3.mean[21,]+eastus.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.eastus.250)," mbe =", sprintf("%1.3g", mbe.mod1.eastus.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.eastus.250)," mbe =", sprintf("%1.3g", mbe.mod2.eastus.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.eastus.250)," mbe =", sprintf("%1.3g", mbe.mod3.eastus.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "East US") 
#text(12,780, "Tilmes ozone sonde comparison", font=2 ) 
par(xpd=F)


plot(1:12, japan.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(japan.mean[,11]+japan.sd[,11], rev(japan.mean[,11]-japan.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(japan.mean[,11])
lines(1:12, japan.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (japan.mod1.mean[21,]-japan.mod1.sd[21,]), 1:12, (japan.mod1.mean[21,]+japan.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, japan.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (japan.mod2.mean[21,]-japan.mod2.sd[21,]), 1:12, (japan.mod2.mean[21,]+japan.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, japan.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (japan.mod3.mean[21,]-japan.mod3.sd[21,]), 1:12, (japan.mod3.mean[21,]+japan.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.japan.250)," mbe =", sprintf("%1.3g", mbe.mod1.japan.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.japan.250)," mbe =", sprintf("%1.3g", mbe.mod2.japan.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.japan.250)," mbe =", sprintf("%1.3g", mbe.mod3.japan.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "Japan") 
par(xpd=F)


plot(1:12, westeu.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(westeu.mean[,11]+westeu.sd[,11], rev(westeu.mean[,11]-westeu.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(westeu.mean[,11])
lines(1:12, westeu.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (westeu.mod1.mean[21,]-westeu.mod1.sd[21,]), 1:12, (westeu.mod1.mean[21,]+westeu.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, westeu.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (westeu.mod2.mean[21,]-westeu.mod2.sd[21,]), 1:12, (westeu.mod2.mean[21,]+westeu.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, westeu.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (westeu.mod3.mean[21,]-westeu.mod3.sd[21,]), 1:12, (westeu.mod3.mean[21,]+westeu.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.westeu.250)," mbe =", sprintf("%1.3g", mbe.mod1.westeu.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.westeu.250)," mbe =", sprintf("%1.3g", mbe.mod2.westeu.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.westeu.250)," mbe =", sprintf("%1.3g", mbe.mod3.westeu.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "West EU") 
par(xpd=F)


plot(1:12, canada.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(canada.mean[,11]+canada.sd[,11], rev(canada.mean[,11]-canada.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(canada.mean[,11])
lines(1:12, canada.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (canada.mod1.mean[21,]-canada.mod1.sd[21,]), 1:12, (canada.mod1.mean[21,]+canada.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, canada.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (canada.mod2.mean[21,]-canada.mod2.sd[21,]), 1:12, (canada.mod2.mean[21,]+canada.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, canada.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (canada.mod3.mean[21,]-canada.mod3.sd[21,]), 1:12, (canada.mod3.mean[21,]+canada.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.canada.250)," mbe =", sprintf("%1.3g", mbe.mod1.canada.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.canada.250)," mbe =", sprintf("%1.3g", mbe.mod2.canada.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.canada.250)," mbe =", sprintf("%1.3g", mbe.mod3.canada.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "Canada") 
par(xpd=F)


plot(1:12, nh.pol.e.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.e.mean[,11]+nh.pol.e.sd[,11], rev(nh.pol.e.mean[,11]-nh.pol.e.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.e.mean[,11])
lines(1:12, nh.pol.e.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (nh.pol.e.mod1.mean[21,]-nh.pol.e.mod1.sd[21,]), 1:12, (nh.pol.e.mod1.mean[21,]+nh.pol.e.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.e.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.e.mod2.mean[21,]-nh.pol.e.mod2.sd[21,]), 1:12, (nh.pol.e.mod2.mean[21,]+nh.pol.e.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.e.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (nh.pol.e.mod3.mean[21,]-nh.pol.e.mod3.sd[21,]), 1:12, (nh.pol.e.mod3.mean[21,]+nh.pol.e.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.250)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.250)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.250)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(6,680, "North Pole East") 
par(xpd=F)


plot(1:12, nh.pol.w.mean[,11], type="l", lwd=3, ylim=c(0,600), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.w.mean[,11]+nh.pol.w.sd[,11], rev(nh.pol.w.mean[,11]-nh.pol.w.sd[,11])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.w.mean[,11])
lines(1:12, nh.pol.w.mod1.mean[21,], lwd=3, col="red")
arrows( 1:12, (nh.pol.w.mod1.mean[21,]-nh.pol.w.mod1.sd[21,]), 1:12, (nh.pol.w.mod1.mean[21,]+nh.pol.w.mod1.sd[21,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.w.mod2.mean[21,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.w.mod2.mean[21,]-nh.pol.w.mod2.sd[21,]), 1:12, (nh.pol.w.mod2.mean[21,]+nh.pol.w.mod2.sd[21,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.w.mod3.mean[21,], lwd=3, col="green")
arrows( 1:12, (nh.pol.w.mod3.mean[21,]-nh.pol.w.mod3.sd[21,]), 1:12, (nh.pol.w.mod3.mean[21,]+nh.pol.w.mod3.sd[21,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.w.250)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.w.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.nh.pol.w.250)," mbe =", sprintf("%1.3g", mbe.mod2.nh.pol.w.250), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.nh.pol.w.250)," mbe =", sprintf("%1.3g", mbe.mod3.nh.pol.w.250), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
legend("bottomleft", "250 hPa",bty="n")
par(xpd=NA)
text(6,680, "North Pole West") 
par(xpd=F)


# ################################################### 500 hPa plots ################################################################################
# 500 hPa plots
plot(1:12, sh.pol.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.pol.mean[,6]+sh.pol.sd[,6], rev(sh.pol.mean[,6]-sh.pol.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.pol.mean[,6])
lines(1:12, sh.pol.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (sh.pol.mod1.mean[16,]-sh.pol.mod1.sd[16,]), 1:12, (sh.pol.mod1.mean[16,]+sh.pol.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.pol.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (sh.pol.mod2.mean[16,]-sh.pol.mod2.sd[16,]), 1:12, (sh.pol.mod2.mean[16,]+sh.pol.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.pol.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (sh.pol.mod3.mean[16,]-sh.pol.mod3.sd[16,]), 1:12, (sh.pol.mod3.mean[16,]+sh.pol.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.500)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.500)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.500)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(-4,60, "Ozone (ppbv)", srt=90)
par(xpd=F)

plot(1:12, sh.mid.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.mid.mean[,6]+sh.mid.sd[,6], rev(sh.mid.mean[,6]-sh.mid.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.mid.mean[,6])
lines(1:12, sh.mid.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (sh.mid.mod1.mean[16,]-sh.mid.mod1.sd[16,]), 1:12, (sh.mid.mod1.mean[16,]+sh.mid.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.mid.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (sh.mid.mod2.mean[16,]-sh.mid.mod2.sd[16,]), 1:12, (sh.mid.mod2.mean[16,]+sh.mid.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.mid.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (sh.mid.mod3.mean[16,]-sh.mid.mod3.sd[16,]), 1:12, (sh.mid.mod3.mean[16,]+sh.mid.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.500)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.500)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.500)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")

plot(1:12, tropics2.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics2.mean[,6]+tropics2.sd[,6], rev(tropics2.mean[,6]-tropics2.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics2.mean[,6])
lines(1:12, tropics2.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (tropics2.mod1.mean[16,]-tropics2.mod1.sd[16,]), 1:12, (tropics2.mod1.mean[16,]+tropics2.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics2.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (tropics2.mod2.mean[16,]-tropics2.mod2.sd[16,]), 1:12, (tropics2.mod2.mean[16,]+tropics2.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics2.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (tropics2.mod3.mean[16,]-tropics2.mod3.sd[16,]), 1:12, (tropics2.mod3.mean[16,]+tropics2.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics2.500)," mbe =", sprintf("%1.3g", mbe.mod1.tropics2.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics2.500)," mbe =", sprintf("%1.3g", mbe.mod2.tropics2.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics2.500)," mbe =", sprintf("%1.3g", mbe.mod3.tropics2.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")

plot(1:12, tropics3.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics3.mean[,6]+tropics3.sd[,6], rev(tropics3.mean[,6]-tropics3.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics3.mean[,6])
lines(1:12, tropics3.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (tropics3.mod1.mean[16,]-tropics3.mod1.sd[16,]), 1:12, (tropics3.mod1.mean[16,]+tropics3.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics3.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (tropics3.mod2.mean[16,]-tropics3.mod2.sd[16,]), 1:12, (tropics3.mod2.mean[16,]+tropics3.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics3.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (tropics3.mod3.mean[16,]-tropics3.mod3.sd[16,]), 1:12, (tropics3.mod3.mean[16,]+tropics3.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics3.500)," mbe =", sprintf("%1.3g", mbe.mod1.tropics3.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics3.500)," mbe =", sprintf("%1.3g", mbe.mod2.tropics3.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics3.500)," mbe =", sprintf("%1.3g", mbe.mod3.tropics3.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")

plot(1:12, eastus.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(eastus.mean[,6]+eastus.sd[,6], rev(eastus.mean[,6]-eastus.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(eastus.mean[,6])
lines(1:12, eastus.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (eastus.mod1.mean[16,]-eastus.mod1.sd[16,]), 1:12, (eastus.mod1.mean[16,]+eastus.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, eastus.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (eastus.mod2.mean[16,]-eastus.mod2.sd[16,]), 1:12, (eastus.mod2.mean[16,]+eastus.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, eastus.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (eastus.mod3.mean[16,]-eastus.mod3.sd[16,]), 1:12, (eastus.mod3.mean[16,]+eastus.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.eastus.500)," mbe =", sprintf("%1.3g", mbe.mod1.eastus.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.eastus.500)," mbe =", sprintf("%1.3g", mbe.mod2.eastus.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.eastus.500)," mbe =", sprintf("%1.3g", mbe.mod3.eastus.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")

plot(1:12, japan.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(japan.mean[,6]+japan.sd[,6], rev(japan.mean[,6]-japan.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(japan.mean[,6])
lines(1:12, japan.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (japan.mod1.mean[16,]-japan.mod1.sd[16,]), 1:12, (japan.mod1.mean[16,]+japan.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, japan.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (japan.mod2.mean[16,]-japan.mod2.sd[16,]), 1:12, (japan.mod2.mean[16,]+japan.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, japan.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (japan.mod3.mean[16,]-japan.mod3.sd[16,]), 1:12, (japan.mod3.mean[16,]+japan.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.japan.500)," mbe =", sprintf("%1.3g", mbe.mod1.japan.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.japan.500)," mbe =", sprintf("%1.3g", mbe.mod2.japan.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.japan.500)," mbe =", sprintf("%1.3g", mbe.mod3.japan.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, westeu.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(westeu.mean[,6]+westeu.sd[,6], rev(westeu.mean[,6]-westeu.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(westeu.mean[,6])
lines(1:12, westeu.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (westeu.mod1.mean[16,]-westeu.mod1.sd[16,]), 1:12, (westeu.mod1.mean[16,]+westeu.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, westeu.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (westeu.mod2.mean[16,]-westeu.mod2.sd[16,]), 1:12, (westeu.mod2.mean[16,]+westeu.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, westeu.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (westeu.mod3.mean[16,]-westeu.mod3.sd[16,]), 1:12, (westeu.mod3.mean[16,]+westeu.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.westeu.500)," mbe =", sprintf("%1.3g", mbe.mod1.westeu.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.westeu.500)," mbe =", sprintf("%1.3g", mbe.mod2.westeu.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.westeu.500)," mbe =", sprintf("%1.3g", mbe.mod3.westeu.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, canada.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(canada.mean[,6]+canada.sd[,6], rev(canada.mean[,6]-canada.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(canada.mean[,6])
lines(1:12, canada.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (canada.mod1.mean[16,]-canada.mod1.sd[16,]), 1:12, (canada.mod1.mean[16,]+canada.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, canada.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (canada.mod2.mean[16,]-canada.mod2.sd[16,]), 1:12, (canada.mod2.mean[16,]+canada.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, canada.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (canada.mod3.mean[16,]-canada.mod3.sd[16,]), 1:12, (canada.mod3.mean[16,]+canada.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.canada.500)," mbe =", sprintf("%1.3g", mbe.mod1.canada.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.canada.500)," mbe =", sprintf("%1.3g", mbe.mod2.canada.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.canada.500)," mbe =", sprintf("%1.3g", mbe.mod3.canada.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, nh.pol.e.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.e.mean[,6]+nh.pol.e.sd[,6], rev(nh.pol.e.mean[,6]-nh.pol.e.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.e.mean[,6])
lines(1:12, nh.pol.e.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (nh.pol.e.mod1.mean[16,]-nh.pol.e.mod1.sd[16,]), 1:12, (nh.pol.e.mod1.mean[16,]+nh.pol.e.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.e.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.e.mod2.mean[16,]-nh.pol.e.mod2.sd[16,]), 1:12, (nh.pol.e.mod2.mean[16,]+nh.pol.e.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.e.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (nh.pol.e.mod3.mean[16,]-nh.pol.e.mod3.sd[16,]), 1:12, (nh.pol.e.mod3.mean[16,]+nh.pol.e.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.500)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.500)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.500)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, nh.pol.w.mean[,6], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.w.mean[,6]+nh.pol.w.sd[,6], rev(nh.pol.w.mean[,6]-nh.pol.w.sd[,6])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.w.mean[,6])
lines(1:12, nh.pol.w.mod1.mean[16,], lwd=3, col="red")
arrows( 1:12, (nh.pol.w.mod1.mean[16,]-nh.pol.w.mod1.sd[16,]), 1:12, (nh.pol.w.mod1.mean[16,]+nh.pol.w.mod1.sd[16,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.w.mod2.mean[16,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.w.mod2.mean[16,]-nh.pol.w.mod2.sd[16,]), 1:12, (nh.pol.w.mod2.mean[16,]+nh.pol.w.mod2.sd[16,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.w.mod3.mean[16,], lwd=3, col="green")
arrows( 1:12, (nh.pol.w.mod3.mean[16,]-nh.pol.w.mod3.sd[16,]), 1:12, (nh.pol.w.mod3.mean[16,]+nh.pol.w.mod3.sd[16,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.w.500)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.w.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.nh.pol.w.500)," mbe =", sprintf("%1.3g", mbe.mod2.nh.pol.w.500), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.nh.pol.w.500)," mbe =", sprintf("%1.3g", mbe.mod3.nh.pol.w.500), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
legend("bottomleft", "500 hPa",bty="n")

# ################################################### 700 hPa plots ################################################################################
# 700 hPa plots
plot(1:12, sh.pol.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.pol.mean[,4]+sh.pol.sd[,4], rev(sh.pol.mean[,4]-sh.pol.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.pol.mean[,4])
lines(1:12, sh.pol.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (sh.pol.mod1.mean[12,]-sh.pol.mod1.sd[12,]), 1:12, (sh.pol.mod1.mean[12,]+sh.pol.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.pol.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (sh.pol.mod2.mean[12,]-sh.pol.mod2.sd[12,]), 1:12, (sh.pol.mod2.mean[12,]+sh.pol.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.pol.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (sh.pol.mod3.mean[12,]-sh.pol.mod3.sd[12,]), 1:12, (sh.pol.mod3.mean[12,]+sh.pol.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.700)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.700)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.700)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
par(xpd=NA)
text(-4,60, "Ozone (ppbv)", srt=90)
par(xpd=F)

plot(1:12, sh.mid.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.mid.mean[,4]+sh.mid.sd[,4], rev(sh.mid.mean[,4]-sh.mid.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.mid.mean[,4])
lines(1:12, sh.mid.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (sh.mid.mod1.mean[12,]-sh.mid.mod1.sd[12,]), 1:12, (sh.mid.mod1.mean[12,]+sh.mid.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.mid.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (sh.mid.mod2.mean[12,]-sh.mid.mod2.sd[12,]), 1:12, (sh.mid.mod2.mean[12,]+sh.mid.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.mid.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (sh.mid.mod3.mean[12,]-sh.mid.mod3.sd[12,]), 1:12, (sh.mid.mod3.mean[12,]+sh.mid.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.700)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.700)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.700)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")

plot(1:12, tropics2.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics2.mean[,4]+tropics2.sd[,4], rev(tropics2.mean[,4]-tropics2.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics2.mean[,4])
lines(1:12, tropics2.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (tropics2.mod1.mean[12,]-tropics2.mod1.sd[12,]), 1:12, (tropics2.mod1.mean[12,]+tropics2.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics2.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (tropics2.mod2.mean[12,]-tropics2.mod2.sd[12,]), 1:12, (tropics2.mod2.mean[12,]+tropics2.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics2.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (tropics2.mod3.mean[12,]-tropics2.mod3.sd[12,]), 1:12, (tropics2.mod3.mean[12,]+tropics2.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics2.700)," mbe =", sprintf("%1.3g", mbe.mod1.tropics2.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics2.700)," mbe =", sprintf("%1.3g", mbe.mod2.tropics2.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics2.700)," mbe =", sprintf("%1.3g", mbe.mod3.tropics2.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")

plot(1:12, tropics3.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics3.mean[,4]+tropics3.sd[,4], rev(tropics3.mean[,4]-tropics3.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics3.mean[,4])
lines(1:12, tropics3.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (tropics3.mod1.mean[12,]-tropics3.mod1.sd[12,]), 1:12, (tropics3.mod1.mean[12,]+tropics3.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics3.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (tropics3.mod2.mean[12,]-tropics3.mod2.sd[12,]), 1:12, (tropics3.mod2.mean[12,]+tropics3.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics3.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (tropics3.mod3.mean[12,]-tropics3.mod3.sd[12,]), 1:12, (tropics3.mod3.mean[12,]+tropics3.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics3.700)," mbe =", sprintf("%1.3g", mbe.mod1.tropics3.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics3.700)," mbe =", sprintf("%1.3g", mbe.mod2.tropics3.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics3.700)," mbe =", sprintf("%1.3g", mbe.mod3.tropics3.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")

plot(1:12, eastus.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(eastus.mean[,4]+eastus.sd[,4], rev(eastus.mean[,4]-eastus.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(eastus.mean[,4])
lines(1:12, eastus.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (eastus.mod1.mean[12,]-eastus.mod1.sd[12,]), 1:12, (eastus.mod1.mean[12,]+eastus.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, eastus.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (eastus.mod2.mean[12,]-eastus.mod2.sd[12,]), 1:12, (eastus.mod2.mean[12,]+eastus.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, eastus.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (eastus.mod3.mean[12,]-eastus.mod3.sd[12,]), 1:12, (eastus.mod3.mean[12,]+eastus.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.eastus.700)," mbe =", sprintf("%1.3g", mbe.mod1.eastus.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.eastus.700)," mbe =", sprintf("%1.3g", mbe.mod2.eastus.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.eastus.700)," mbe =", sprintf("%1.3g", mbe.mod3.eastus.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, japan.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(japan.mean[,4]+japan.sd[,4], rev(japan.mean[,4]-japan.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(japan.mean[,4])
lines(1:12, japan.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (japan.mod1.mean[12,]-japan.mod1.sd[12,]), 1:12, (japan.mod1.mean[12,]+japan.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, japan.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (japan.mod2.mean[12,]-japan.mod2.sd[12,]), 1:12, (japan.mod2.mean[12,]+japan.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, japan.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (japan.mod3.mean[12,]-japan.mod3.sd[12,]), 1:12, (japan.mod3.mean[12,]+japan.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.japan.700)," mbe =", sprintf("%1.3g", mbe.mod1.japan.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.japan.700)," mbe =", sprintf("%1.3g", mbe.mod2.japan.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.japan.700)," mbe =", sprintf("%1.3g", mbe.mod3.japan.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, westeu.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(westeu.mean[,4]+westeu.sd[,4], rev(westeu.mean[,4]-westeu.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(westeu.mean[,4])
lines(1:12, westeu.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (westeu.mod1.mean[12,]-westeu.mod1.sd[12,]), 1:12, (westeu.mod1.mean[12,]+westeu.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, westeu.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (westeu.mod2.mean[12,]-westeu.mod2.sd[12,]), 1:12, (westeu.mod2.mean[12,]+westeu.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, westeu.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (westeu.mod3.mean[12,]-westeu.mod3.sd[12,]), 1:12, (westeu.mod3.mean[12,]+westeu.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.westeu.700)," mbe =", sprintf("%1.3g", mbe.mod1.westeu.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.westeu.700)," mbe =", sprintf("%1.3g", mbe.mod2.westeu.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.westeu.700)," mbe =", sprintf("%1.3g", mbe.mod3.westeu.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, canada.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(canada.mean[,4]+canada.sd[,4], rev(canada.mean[,4]-canada.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(canada.mean[,4])
lines(1:12, canada.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (canada.mod1.mean[12,]-canada.mod1.sd[12,]), 1:12, (canada.mod1.mean[12,]+canada.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, canada.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (canada.mod2.mean[12,]-canada.mod2.sd[12,]), 1:12, (canada.mod2.mean[12,]+canada.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, canada.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (canada.mod3.mean[12,]-canada.mod3.sd[12,]), 1:12, (canada.mod3.mean[12,]+canada.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.canada.700)," mbe =", sprintf("%1.3g", mbe.mod1.canada.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.canada.700)," mbe =", sprintf("%1.3g", mbe.mod2.canada.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.canada.700)," mbe =", sprintf("%1.3g", mbe.mod3.canada.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, nh.pol.e.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.e.mean[,4]+nh.pol.e.sd[,4], rev(nh.pol.e.mean[,4]-nh.pol.e.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.e.mean[,4])
lines(1:12, nh.pol.e.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (nh.pol.e.mod1.mean[12,]-nh.pol.e.mod1.sd[12,]), 1:12, (nh.pol.e.mod1.mean[12,]+nh.pol.e.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.e.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.e.mod2.mean[12,]-nh.pol.e.mod2.sd[12,]), 1:12, (nh.pol.e.mod2.mean[12,]+nh.pol.e.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.e.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (nh.pol.e.mod3.mean[12,]-nh.pol.e.mod3.sd[12,]), 1:12, (nh.pol.e.mod3.mean[12,]+nh.pol.e.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.700)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.700)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.700)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")


plot(1:12, nh.pol.w.mean[,4], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.w.mean[,4]+nh.pol.w.sd[,4], rev(nh.pol.w.mean[,4]-nh.pol.w.sd[,4])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.w.mean[,4])
lines(1:12, nh.pol.w.mod1.mean[12,], lwd=3, col="red")
arrows( 1:12, (nh.pol.w.mod1.mean[12,]-nh.pol.w.mod1.sd[12,]), 1:12, (nh.pol.w.mod1.mean[12,]+nh.pol.w.mod1.sd[12,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.w.mod2.mean[12,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.w.mod2.mean[12,]-nh.pol.w.mod2.sd[12,]), 1:12, (nh.pol.w.mod2.mean[12,]+nh.pol.w.mod2.sd[12,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.w.mod3.mean[12,], lwd=3, col="green")
arrows( 1:12, (nh.pol.w.mod3.mean[12,]-nh.pol.w.mod3.sd[12,]), 1:12, (nh.pol.w.mod3.mean[12,]+nh.pol.w.mod3.sd[12,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.w.700)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.w.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.nh.pol.w.700)," mbe =", sprintf("%1.3g", mbe.mod2.nh.pol.w.700), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.nh.pol.w.700)," mbe =", sprintf("%1.3g", mbe.mod3.nh.pol.w.700), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
legend("bottomleft", "700 hPa",bty="n")

# ################################################### 900 hPa plots ################################################################################
# 900 hPa plots
plot(1:12, sh.pol.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.pol.mean[,2]+sh.pol.sd[,2], rev(sh.pol.mean[,2]-sh.pol.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.pol.mean[,2])
lines(1:12, sh.pol.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (sh.pol.mod1.mean[5,]-sh.pol.mod1.sd[5,]), 1:12, (sh.pol.mod1.mean[5,]+sh.pol.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.pol.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (sh.pol.mod2.mean[5,]-sh.pol.mod2.sd[5,]), 1:12, (sh.pol.mod2.mean[5,]+sh.pol.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.pol.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (sh.pol.mod3.mean[5,]-sh.pol.mod3.sd[5,]), 1:12, (sh.pol.mod3.mean[5,]+sh.pol.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.900)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.900)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.pol.900)," mbe =", sprintf("%1.3g", mbe.mod1.sh.pol.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
par(xpd=NA)
text(-4,60, "Ozone (ppbv)", srt=90)
par(xpd=F)

plot(1:12, sh.mid.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(sh.mid.mean[,2]+sh.mid.sd[,2], rev(sh.mid.mean[,2]-sh.mid.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(sh.mid.mean[,2])
lines(1:12, sh.mid.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (sh.mid.mod1.mean[5,]-sh.mid.mod1.sd[5,]), 1:12, (sh.mid.mod1.mean[5,]+sh.mid.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, sh.mid.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (sh.mid.mod2.mean[5,]-sh.mid.mod2.sd[5,]), 1:12, (sh.mid.mod2.mean[5,]+sh.mid.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, sh.mid.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (sh.mid.mod3.mean[5,]-sh.mid.mod3.sd[5,]), 1:12, (sh.mid.mod3.mean[5,]+sh.mid.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.900)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.900)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.sh.mid.900)," mbe =", sprintf("%1.3g", mbe.mod1.sh.mid.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)

plot(1:12, tropics2.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics2.mean[,2]+tropics2.sd[,2], rev(tropics2.mean[,2]-tropics2.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics2.mean[,2])
lines(1:12, tropics2.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (tropics2.mod1.mean[5,]-tropics2.mod1.sd[5,]), 1:12, (tropics2.mod1.mean[5,]+tropics2.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics2.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (tropics2.mod2.mean[5,]-tropics2.mod2.sd[5,]), 1:12, (tropics2.mod2.mean[5,]+tropics2.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics2.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (tropics2.mod3.mean[5,]-tropics2.mod3.sd[5,]), 1:12, (tropics2.mod3.mean[5,]+tropics2.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics2.900)," mbe =", sprintf("%1.3g", mbe.mod1.tropics2.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics2.900)," mbe =", sprintf("%1.3g", mbe.mod2.tropics2.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics2.900)," mbe =", sprintf("%1.3g", mbe.mod3.tropics2.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)

plot(1:12, tropics3.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(tropics3.mean[,2]+tropics3.sd[,2], rev(tropics3.mean[,2]-tropics3.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(tropics3.mean[,2])
lines(1:12, tropics3.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (tropics3.mod1.mean[5,]-tropics3.mod1.sd[5,]), 1:12, (tropics3.mod1.mean[5,]+tropics3.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, tropics3.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (tropics3.mod2.mean[5,]-tropics3.mod2.sd[5,]), 1:12, (tropics3.mod2.mean[5,]+tropics3.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, tropics3.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (tropics3.mod3.mean[5,]-tropics3.mod3.sd[5,]), 1:12, (tropics3.mod3.mean[5,]+tropics3.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.tropics3.900)," mbe =", sprintf("%1.3g", mbe.mod1.tropics3.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.tropics3.900)," mbe =", sprintf("%1.3g", mbe.mod2.tropics3.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.tropics3.900)," mbe =", sprintf("%1.3g", mbe.mod3.tropics3.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)

plot(1:12, eastus.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(eastus.mean[,2]+eastus.sd[,2], rev(eastus.mean[,2]-eastus.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(eastus.mean[,2])
lines(1:12, eastus.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (eastus.mod1.mean[5,]-eastus.mod1.sd[5,]), 1:12, (eastus.mod1.mean[5,]+eastus.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, eastus.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (eastus.mod2.mean[5,]-eastus.mod2.sd[5,]), 1:12, (eastus.mod2.mean[5,]+eastus.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, eastus.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (eastus.mod3.mean[5,]-eastus.mod3.sd[5,]), 1:12, (eastus.mod3.mean[5,]+eastus.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.eastus.900)," mbe =", sprintf("%1.3g", mbe.mod1.eastus.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.eastus.900)," mbe =", sprintf("%1.3g", mbe.mod2.eastus.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.eastus.900)," mbe =", sprintf("%1.3g", mbe.mod3.eastus.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)


plot(1:12, japan.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(japan.mean[,2]+japan.sd[,2], rev(japan.mean[,2]-japan.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(japan.mean[,2])
lines(1:12, japan.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (japan.mod1.mean[5,]-japan.mod1.sd[5,]), 1:12, (japan.mod1.mean[5,]+japan.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, japan.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (japan.mod2.mean[5,]-japan.mod2.sd[5,]), 1:12, (japan.mod2.mean[5,]+japan.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, japan.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (japan.mod3.mean[5,]-japan.mod3.sd[5,]), 1:12, (japan.mod3.mean[5,]+japan.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.japan.900)," mbe =", sprintf("%1.3g", mbe.mod1.japan.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.japan.900)," mbe =", sprintf("%1.3g", mbe.mod2.japan.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.japan.900)," mbe =", sprintf("%1.3g", mbe.mod3.japan.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)


plot(1:12, westeu.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(westeu.mean[,2]+westeu.sd[,2], rev(westeu.mean[,2]-westeu.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(westeu.mean[,2])
lines(1:12, westeu.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (westeu.mod1.mean[5,]-westeu.mod1.sd[5,]), 1:12, (westeu.mod1.mean[5,]+westeu.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, westeu.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (westeu.mod2.mean[5,]-westeu.mod2.sd[5,]), 1:12, (westeu.mod2.mean[5,]+westeu.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, westeu.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (westeu.mod3.mean[5,]-westeu.mod3.sd[5,]), 1:12, (westeu.mod3.mean[5,]+westeu.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.westeu.900)," mbe =", sprintf("%1.3g", mbe.mod1.westeu.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.westeu.900)," mbe =", sprintf("%1.3g", mbe.mod2.westeu.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.westeu.900)," mbe =", sprintf("%1.3g", mbe.mod3.westeu.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)


plot(1:12, canada.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(canada.mean[,2]+canada.sd[,2], rev(canada.mean[,2]-canada.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(canada.mean[,2])
lines(1:12, canada.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (canada.mod1.mean[5,]-canada.mod1.sd[5,]), 1:12, (canada.mod1.mean[5,]+canada.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, canada.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (canada.mod2.mean[5,]-canada.mod2.sd[5,]), 1:12, (canada.mod2.mean[5,]+canada.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, canada.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (canada.mod3.mean[5,]-canada.mod3.sd[5,]), 1:12, (canada.mod3.mean[5,]+canada.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.canada.900)," mbe =", sprintf("%1.3g", mbe.mod1.canada.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.canada.900)," mbe =", sprintf("%1.3g", mbe.mod2.canada.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.canada.900)," mbe =", sprintf("%1.3g", mbe.mod3.canada.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)


plot(1:12, nh.pol.e.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.e.mean[,2]+nh.pol.e.sd[,2], rev(nh.pol.e.mean[,2]-nh.pol.e.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.e.mean[,2])
lines(1:12, nh.pol.e.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (nh.pol.e.mod1.mean[5,]-nh.pol.e.mod1.sd[5,]), 1:12, (nh.pol.e.mod1.mean[5,]+nh.pol.e.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.e.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.e.mod2.mean[5,]-nh.pol.e.mod2.sd[5,]), 1:12, (nh.pol.e.mod2.mean[5,]+nh.pol.e.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.e.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (nh.pol.e.mod3.mean[5,]-nh.pol.e.mod3.sd[5,]), 1:12, (nh.pol.e.mod3.mean[5,]+nh.pol.e.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.900)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.900)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.e.900)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.e.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)


plot(1:12, nh.pol.w.mean[,2], type="l", lwd=3, ylim=c(0,120), ylab="", xlab="", yaxt="n", xaxt="n" )
grid()
polygon( c(1:12, rev(1:12)), c(nh.pol.w.mean[,2]+nh.pol.w.sd[,2], rev(nh.pol.w.mean[,2]-nh.pol.w.sd[,2])), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(nh.pol.w.mean[,2])
lines(1:12, nh.pol.w.mod1.mean[5,], lwd=3, col="red")
arrows( 1:12, (nh.pol.w.mod1.mean[5,]-nh.pol.w.mod1.sd[5,]), 1:12, (nh.pol.w.mod1.mean[5,]+nh.pol.w.mod1.sd[5,]), length = 0.0, code =2, col="red" )
lines(1:12, nh.pol.w.mod2.mean[5,], lwd=3, col="blue")
arrows( 1:12, (nh.pol.w.mod2.mean[5,]-nh.pol.w.mod2.sd[5,]), 1:12, (nh.pol.w.mod2.mean[5,]+nh.pol.w.mod2.sd[5,]), length = 0.0, code =2, col="blue" )
lines(1:12, nh.pol.w.mod3.mean[5,], lwd=3, col="green")
arrows( 1:12, (nh.pol.w.mod3.mean[5,]-nh.pol.w.mod3.sd[5,]), 1:12, (nh.pol.w.mod3.mean[5,]+nh.pol.w.mod3.sd[5,]), length = 0.0, code =2, col="green" )

legend("topleft", c(paste("r = ",sprintf("%1.3g", cor.mod1.nh.pol.w.900)," mbe =", sprintf("%1.3g", mbe.mod1.nh.pol.w.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod2.nh.pol.w.900)," mbe =", sprintf("%1.3g", mbe.mod2.nh.pol.w.900), " ppbv", sep=""),
paste("r = ",sprintf("%1.3g", cor.mod3.nh.pol.w.900)," mbe =", sprintf("%1.3g", mbe.mod3.nh.pol.w.900), " ppbv", sep="")), cex=0.7, text.col=c("red","blue","green"), bty="n")
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
legend("bottomleft", "900 hPa",bty="n")


dev.off()
