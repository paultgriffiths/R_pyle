library(ncdf)
library(fields)
library(RColorBrewer)
library(maps)
library(mapdata)
library(png)
library(plotrix)
library(abind)
source("~/Dropbox/r_scripts/ukca_evaluation/ukca_eval_functions.R")
source("~/Dropbox/r_scripts/ukca_evaluation/get_mol_masses.R")
source("~/Dropbox/r_scripts/ukca_evaluation/get_gaw_surface_o3.R")
source("~/Dropbox/r_scripts/color.legend.x.R")
source("~/Dropbox/r_scripts/logo_add.R")
source("~/Dropbox/r_scripts/ukca_evaluation/tracer_var_codes.R")

nc1 <- open.ncdf("~/Desktop/xgywn_evaluation_output.nc")
mod1.name <- "xgywn"
out.dir <- "~/"
script.dir <- "~/Dropbox/r_scripts/ukca_evaluation/"
ancil.dir <- "~/ancils/"
#source("~/Dropbox/r_scripts/ukca_evaluation/plot_ox_budget_eval.R")


# define constants and conv. factors
conv.factor <- 60*60*24*30*48*(1e-12)
nav         <- 6.02214179E23

# extract variables
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")*1E-3 # km
time  <- get.var.ncdf(nc1, "t")

# model (UM) tropopause height
ht     <- get.var.ncdf(nc1, trop.hgt.code)
ht     <- apply(ht, c(2), mean)*1E-3 # km


source(paste(script.dir, "check_model_dims.R", sep=""))
# Check to see if a trop. mask exists?
if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source(paste(script.dir, "calc_trop_mask.R", sep="")))

# extract ozone loss terms
l1.1 <- get.var.ncdf(nc1,o1dh2o.code) * mask 
l1.2 <- get.var.ncdf(nc1,mlr.code) * mask 
l1.3 <- get.var.ncdf(nc1,ho2o3.code) * mask 
l1.4 <- get.var.ncdf(nc1,oho3.code) * mask 
l1.5 <- get.var.ncdf(nc1,o3alk.code) * mask 
l1.6 <- get.var.ncdf(nc1,n2o5h2o.code) * mask 
l1.7 <- get.var.ncdf(nc1,no3loss.code) * mask 
# 2d fields
l1.8 <- get.var.ncdf(nc1,o3.dd.code)  
l1.9 <- get.var.ncdf(nc1,noy.dd.code) 
# 3d noy wet dep
l1.10 <- get.var.ncdf(nc1,noy.wd.code) * mask 

# loop over height 
l1.8.3d <- array(0, dim=c(length(lon), length(lat), length(hgt), length(time)))
l1.9.3d <- array(0, dim=c(length(lon), length(lat), length(hgt), length(time)))
for(i in 1:length(lon)) {
  for(j in 1:length(lat)) {
    for(k in 1:length(time)) {
      l1.8.3d[i,j,1,k] <- l1.8[i,j,k]
      l1.9.3d[i,j,1,k] <- l1.9[i,j,k]
    }
  }
}


# sum the terms
#net.l <- apply((l1.1 + l1.2 + l1.3 + l1.4 + l1.5 + l1.6 + l1.7 + l1.10 + l1.8.3d + l1.9.3d), c(1,2,3,4), 
#               sum, na.rm=T)
net.l <-(l1.1 + l1.2 + l1.3 + l1.4 + l1.5 + l1.6 + l1.7 + l1.10 + l1.8.3d + l1.9.3d)

# calc the lifetime and plot.
# tau = [O3]/lossO3
mass <- get.var.ncdf(nc1, air.mass) # kg
#mass <- mass/28.8E-3 # kg / kg mol-1 -> moles
o3 <- get.var.ncdf(nc1, o3.code) # kg/kg
o3 <- o3*mass # kg o3
o3 <- o3/48E-3 # moles o3
o3 <- o3 * mask

tau <- o3 / net.l # seconds
tau <- tau/86400 # days

tau.zm <- apply(tau, c(2,3), mean, na.rm=T)

image.plot(lon, lat, tau[,,3,1])

image.plot(lat, hgt, tau.zm, zlim=c(0,1000) )

