# R control file used to run various
# model obs comparison scripts, useful for model evaluation.

# Alex Archibald, CAS, February 2012
# Modified February 2014

# ##############################################################

#    ##   ##   ##   #   ######       ##
#    ##   ##   ##  #    ######     ##  ##
#    ##   ##   ## #     ##        ##    ##
#    ##   ##   ###      ##       ##      ##
#    ##   ##   ###      ##       ###########
#    #######   ## ##    ######   ##       ## 
#    #######   ##  ##   ######   ##       ##

# ##############################################################

# load the required libraries for the evaluation.
# These should be installed on the Linux system
library(ncdf4)
library(abind)
library(fields)
library(plotrix)
library(maps)
library(gdata)
library(RColorBrewer)
library(here)
# Set paths to scripts and observations
script.dir <- here("/")
obs.dir    <- here("Obs/")
ancil.dir  <- here("ancils/")

# Required variables -- and variable/dimension names (NOT stash codes):
# latitude (degrees) -- 
lat.dim.name <- "latitude"
# longitude (degrees) -- 
lon.dim.name <- "longitude"
# height (m) -- 
hgt.dim.name <- "hybrid_ht"
# time (days) -- 
time.dim.name <- "t"

# The scripts should be able to deal with N48 and N96 model resolution, 
# potentially other resolutions should be fine but some plots (e.g. 
# comparison to ERA data will not work
# The time series plots expect that there are 12 months of data. 
# In general all ouput is expected to be on the model grid (vertical hybrid_ht as z co-ord).
# The STASH codes of variables are assigned variable names  in the script below
# which you may want/need to change depending on your output..
#source(paste(script.dir, "tracer_var_codes_CheST.R", sep=""))
source("tracer_var_codes_xinyk.R")

# For CheT runs only!!! 
# set the fraction of CH4 in model run (can get from UMUI)
f.ch4 <- 9.75E-7
# ##############################################################

# Option to loop through several sets of model output
# list of exps
#exp.list <- c("xgywe", "xgywf", "xgywk", "xgywl", "xgywu", "xgyws", "xhtry")
#for (ee in 1:length(exp.list)) {
  
# enter name of model run and some info for legends 
#mod1.name <- exp.list[ee]
mod1.name <- "xgywn"
mod1.meta <- "CheST" # Anything you like..
mod1.type <- "CheST" # CheS, CheST or CheT
open.ncdf <- nc_open
get.var.ncdf <- ncvar_get

##
## NC1 should be an input file of 12x60x73x96 dimension
##

# give locations of netcdf files for input
#nc1 <- open.ncdf("~//xgywn_evaluation_output.nc")
#nc1 <- open.ncdf(paste("~/Desktop/AurelienQuiquet/data/",mod1.name,"_pmclim.nc", sep=""), readunlim=FALSE) 
nc1 <- open.ncdf(paste(here("data/"),mod1.name,"/",mod1.name,"_evaluation_output_clim.nc", sep=""), readunlim=FALSE) 
#nc0 <- nc1
# set the working directory for output (default to directory of this script)

out.dir <- here("out/")

# set the directory where the R scripts are saved
run.path <- here()

# ##############################################################

# source a list of the molecular masses used in UKCA for tracers
source(paste(script.dir, "get_mol_masses.R", sep=""))

# check the dimensions of the model output to determine which ancil files
# to use
source(paste(script.dir,"get_model_dims.R", sep=""))
source(paste(script.dir,"/", "check_model_dims.R", sep=""))

# source some useful functions for plotting:
source(paste(script.dir, "ukca_eval_functions.R", sep=""))

# set plotting colors
o3.col.cols  <- colorRampPalette(c("purple", "lightblue", "green", "yellow", "orange", "red","darkred"))
col.cols  <- colorRampPalette(c("white","purple", "lightblue", "green", "yellow", "orange", "red"))
lgt.cols  <- colorRampPalette(c("white","mistyrose", "lightblue", "green", "yellow", "orange", "red"))
temp.cols <- colorRampPalette(c("white","blue","green","yellow","red"))
heat.cols <- colorRampPalette(c("blue","white", "red"))
ecmwf.cols <- colorRampPalette(c("blue", "green", "white", "yellow", "red"))
cool.cols <- colorRampPalette(c("red","white", "blue"))
tau.cols  <- colorRampPalette(c("white", "yellow", "red"))
# ##############################################################
# Select which plots you want to make.
# plot O3 column?
source(paste(script.dir,"plot_total_o3_col_eval.R", sep=""))

# plot O3 column?
source(paste(script.dir,"plot_total_o3_col_eval_mod.R", sep=""))

#} # end loop over exp's

# remove all data from current session!
# rm(list=ls())
# q()

# plot surf O3?
# source(paste(script.dir,"plot_surf_o3_range_eval.R", sep=""))
# source(paste(script.dir,"plot_surf_o3_eval.R", sep=""))
# source(paste(script.dir,"plot_O3_GAW_WDCGG_eval.R", sep=""))

# plot T bias?
# source(paste(script.dir,"plot_zonal_mean_temp_ERA_eval.R", sep=""))

# plot specific humidity bias?
# source(paste(script.dir,"plot_zonal_mean_q_ERA_eval.R", sep=""))

# plot zonal winds?
# source(paste(script.dir,"plot_zonal_mean_u_ERA_eval.R", sep=""))

# plot O3 column?
source(paste(script.dir,"plot_total_o3_col_eval.R", sep=""))

# plot O3 trop column?
source(paste(script.dir,"plot_trop_o3_col_eval.R", sep=""))

# plot comparison to Tilmes ozone sondes
source(paste(script.dir,"plot_tilmes_eval.R", sep=""))

# plot O3 profiles vs SHADOZ data?
source(paste(script.dir,"plot_shadoz_ts_hybrid_hgt_eval.R", sep=""))

# plot NO2 trop column?
source(paste(script.dir,"plot_trop_no2_col_eval.R", sep=""))

# plot HCHO trop column?
source(paste(script.dir,"plot_trop_hcho_col_eval.R", sep=""))

# plot NO2 strat column?
source(paste(script.dir,"plot_strat_no2_col_eval.R", sep=""))

# plot tropospheric OH Lawrence style?
source(paste(script.dir,"plot_trop_oh_lawrence_eval.R", sep=""))

# plot model profiles against Sat data?
source(paste(script.dir,"plot_tracer_profiles_eval.R", sep=""))

# plot Emmons type plots?
source(paste(script.dir,"plot_UKCA_Emmons_eval.R", sep=""))

# plot the tropospheric Ox budget?
source(paste(script.dir,"plot_ox_budget_eval.R", sep=""))
#source(paste(script.dir,"plot_ox_budget_wesley_eval.R", sep=""))

# plot the stratospheric ox budget?
source(paste(script.dir,"plot_strat_ox_budget_eval.R", sep=""))

# plot the tropospheric methane lifetime?
source(paste(script.dir,"plot_tau_ch4_eval.R", sep=""))

# plot the age of air?
source(paste(script.dir,"plot_age_of_air_eval.R", sep=""))

# plot zonal O3?
# source(paste(script.dir,"plot_zonal_mean_o3_ERA_eval.R", sep=""))
# 
# # plot zonal ClO?
# source(paste(script.dir,"plot_zonal_mean_clo_ERA_eval.R", sep=""))
# 
# # plot zonal HONO2?
# source(paste(script.dir,"plot_zonal_mean_hono2_ERA_eval.R", sep=""))

# plot zonal HCl?
# source(paste(script.dir,"plot_zonal_mean_hcl_ERA_eval.R", sep=""))

# plot zonal NO2?
source(paste(script.dir,"plot_zonal_mean_no2_eval.R", sep=""))

# plot zonal CH4?
# source(paste(script.dir,"plot_zonal_mean_ch4_ERA_eval.R", sep=""))

# plot surf O3?
#source(paste(script.dir,"plot_surf_o3_eval.R", sep=""))

# plot surf O3 against obs?
source(paste(script.dir,"plot_JPN_O3_tseries_eval.R", sep=""))
source(paste(script.dir,"plot_CASTNET_O3_tseries_eval.R", sep=""))
source(paste(script.dir,"plot_EMEP_O3_tseries_eval.R", sep=""))

# plot CARIBIC CO-O3?
source(paste(script.dir,"plot_caribic_ozone_co_eval.R", sep=""))

# plot CO CMDL comparison
source(paste(script.dir,"plot_CO_CMDL_eval.R", sep=""))

# plot ethane propane CMDL comparison
source(paste(script.dir,"plot_ethane_propane_CMDL_eval.R", sep=""))

# plot the ozone bias relative to the UM climatology
source(paste(script.dir,"plot_ros_o3_bias_eval.R", sep=""))

# plot comparison to surface methanol
#source(paste(script.dir,"plot_srf_meoh_comparison.R", sep=""))

# plot comparison to vertical methanol
#source(paste(script.dir,"plot_Emmons_MeOH_eval.R", sep=""))

# plot zonal O3 tendency?
source(paste(script.dir,"plot_zonal_mean_o3_tendency_ERA_eval.R", sep=""))

# plot total ozone column polar
source(paste(script.dir,"plot_total_o3_col_polar_eval.R", sep=""))

# plot lightning NOx emissions
source(paste(script.dir,"plot_lightning_nox_eval.R", sep=""))

#q()

# # plot the tropospheric NOx lifetime?
#source(paste(script.dir,"plot_nox_lifetime_eval.R", sep=""))


# # plot NOy profiles?
#source(paste(script.dir,"plot_zonal_noy_eval.R", sep=""))
