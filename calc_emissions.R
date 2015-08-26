# R script to check emissions files

# Alex Archibald, Sept 2012

library(ncdf)     

# field 531 = NOx
# field 532 = CH4
# field 533 = CO
# field 534 = HCHO
# field 535 = C2H6
# field 536 = C3H8
# field 537 = Me2CO
# field 538 = MeCHO
# field 539 = C5H8
# field 540 = MeOH
# field 555 = NOx air

# load emissions data
nc1 <- open.ncdf("/home/ata27/data/emissions/AR5_MeOH_surfems_2000_N48.nc")
nc2 <- open.ncdf("/home/ata27/data/emissions/NOx_air_emis.nc")

# check the dimensions of the model output
source(paste(script.dir, "check_model_dims.R", sep=""))

# conversion factor (Tg/yr)
conv <- 86400*30*1E-9

# emissions data are in kg m-2 s-1. Emissions are monthly means so we sum along the time dimension.
# for air emissions, these are in kg grid box-1 s-1 so can just sum up and convert.
nox   <- apply(get.var.ncdf(nc1, "field531"), c(1,2), sum)
ch4   <- apply(get.var.ncdf(nc1, "field532"), c(1,2), sum)
co    <- apply(get.var.ncdf(nc1, "field533"), c(1,2), sum)
hcho  <- apply(get.var.ncdf(nc1, "field534"), c(1,2), sum)
c2h6  <- apply(get.var.ncdf(nc1, "field535"), c(1,2), sum)
c3h8  <- apply(get.var.ncdf(nc1, "field536"), c(1,2), sum)
me2co <- apply(get.var.ncdf(nc1, "field537"), c(1,2), sum)
mecho <- apply(get.var.ncdf(nc1, "field538"), c(1,2), sum)
c5h8  <- apply(get.var.ncdf(nc1, "field539"), c(1,2), sum)
meoh  <- apply(get.var.ncdf(nc1, "field540"), c(1,2), sum)
airnox<- get.var.ncdf(nc2, "field555")

print(sum(nox*gb.sa*conv))
print(sum(ch4*gb.sa*conv))
print(sum(co*gb.sa*conv))
print(sum(hcho*gb.sa*conv))
print(sum(c2h6*gb.sa*conv))
print(sum(c3h8*gb.sa*conv))
print(sum(me2co*gb.sa*conv))
print(sum(mecho*gb.sa*conv))
print(sum(c5h8*gb.sa*conv))
print(sum(meoh*gb.sa*conv))
print(sum(airnox*conv))

