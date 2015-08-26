# R script to compare the model ozone with SHADOZ data

# Alex Archibald, CAS, May 2012

# constants and loop variables
i    <- NULL
conv <- 1E6 

# ################# Extract Variables ######################################
lat  <- get.var.ncdf(nc1, "latitude")
hgt  <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
lon  <- get.var.ncdf(nc1, "longitude")
time <- get.var.ncdf(nc1, "t")

# list of the heights the data is binned onto
data.heights <- c(0.1,0.3,0.5,0.7,0.9,1.25,1.75,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,
12.5,13.5,14.5,15.5,16.5,17.5,18.5,19.5,20.5,21.5,22.5,23.5,24.5,25.5,26.5,27.5,28.5,29.5)

data.pres <- c(1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,
500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10)#,7,5,3,2,1)

# extract the data from fiji
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/fiji"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
fiji.dat <- data 
dat.lat  <- -18.13
dat.lon  <- +178.40
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
fiji.mod <- model.o3

# extract the data from alajuela
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/alajuela"
#source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
#alajuela.dat <- data 
#dat.lat  <- 9.98
#dat.lon  <- -84.21
#source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
#alajuela.mod <- model.o3

# extract the data from ascen
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/ascen"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
ascen.dat <- data 
dat.lat  <- -7.98
dat.lon  <- -14.42
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
ascen.mod <- model.o3

# extract the data from cotonou
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/cotonou"
#source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
#cotonou.dat <- data 
#dat.lat  <- +6.21
#dat.lon  <- +2.23
#source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
#cotonou.mod <- model.o3

# extract the data from irene
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/irene"
#source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
#irene.dat <- data 
#dat.lat  <- -25.90
#dat.lon  <- +28.22
#setwd(run.path)
#source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
#irene.mod <- model.o3

# extract the data from java
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/java"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
java.dat <- data 
dat.lat  <- -7.50
dat.lon  <- +112.6
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
java.mod <- model.o3

# extract the data from kuala
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/kuala"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
kuala.dat <- data 
dat.lat  <- +2.73
dat.lon  <- +101.7
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
kuala.mod <- model.o3

# extract the data from nairobi
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/nairobi"
#source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
#nairobi.dat <- data 
#dat.lat  <- -1.27
#dat.lon  <- +36.80
#setwd(run.path)
#source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
#nairobi.mod <- model.o3

# extract the data from samoa
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/samoa"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
samoa.dat <- data 
dat.lat  <- -14.23
dat.lon  <- -170.56
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
samoa.mod <- model.o3

# extract the data from natal
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/natal"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
natal.dat <- data 
dat.lat  <- -5.42
dat.lon  <- -35.38
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
natal.mod <- model.o3

# extract the data from param
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/param"
#source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
#param.dat <- data 
#dat.lat  <- +5.81
#dat.lon  <- -55.21
#setwd(run.path)
#source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
#param.mod <- model.o3

# extract the data from samoa
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/reunion"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
reunion.dat <- data 
dat.lat  <- -21.06
dat.lon  <- +55.48
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
reunion.mod <- model.o3

# extract the data from sancr
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/sancr"
source(paste(script.dir, "get_shadoz_data_eval.R", sep=""))
sancr.dat <- data 
dat.lat  <- -0.92
dat.lon  <- -89.60
setwd(run.path)
source(paste(script.dir, "get_model_o3_sonde_eval.R", sep=""))
sancr.mod <- model.o3

# ##########################################################################################################################################
pdf(file=paste(out.dir,mod1.name,"_SHADOZ_comparison.eps", sep=""), 

#width=6,height=8,paper="special",onefile=TRUE,pointsize=12)
#
#par(mfrow=c(4,2))
#par(oma=c(0,0,1,0)) 
#par(mgp = c(2, 1, 0))
width=16,height=24,pointsize=24)
#
par(mfrow=c(4,2))
par(oma=c(0,0,1,0)) 
par(mgp = c(2, 1, 0))

plot(fiji.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Fiji")
for (i in 1:12) {
lines(fiji.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(fiji.mod[,i], hgt, col="black", lwd=2 ) }
#legend("bottomright", c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), lwd=1, col=c(1:12), bty="n", cex=0.85 )
#legend("bottomright", c(mod1.name,"Data"), lwd=2, lty=c(1,2), col=gray, bty="n", cex=0.85 )
grid()

plot(kuala.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Kuala")
for (i in 1:12) {
lines(kuala.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(kuala.mod[,i], hgt, col="black", lwd=2 ) }
grid()

plot(samoa.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Samoa")
for (i in 1:12) {
lines(samoa.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(samoa.mod[,i], hgt, col="black", lwd=2 ) }
grid()

plot(java.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Java")
for (i in 1:12) {
lines(java.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(java.mod[,i], hgt, col="black", lwd=2 ) }
grid()

plot(ascen.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Ascen")
for (i in 1:12) {
lines(ascen.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(ascen.mod[,i], hgt, col="black", lwd=2 ) }
grid()

plot(natal.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Natal")
for (i in 1:12) {
lines(natal.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(natal.mod[,i], hgt, col="black", lwd=2 ) }
grid()

plot(reunion.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Reunion")
for (i in 1:12) {
lines(reunion.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(reunion.mod[,i], hgt, col="black", lwd=2 ) }
grid()

plot(sancr.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Sancr")
for (i in 1:12) {
lines(sancr.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
lines(sancr.mod[,i], hgt, col="black", lwd=2 ) }
grid()

#plot(param.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Param")
#for (i in 1:12) {
#lines(param.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
#lines(param.mod[,i], hgt, col="black", lwd=2 ) }
#grid()

#plot(irene.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Irene")
#for (i in 1:12) {
#lines(irene.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
#lines(irene.mod[,i], hgt, col="black", lwd=2 ) }
#grid()

#plot(nairobi.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Nairobi")
#for (i in 1:12) {
#lines(nairobi.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
#lines(nairobi.mod[,i], hgt, col="gray", lwd=2 ) }
#grid()

#plot(cotonou.dat[,1], data.heights, xlim=c(0,0.10), col="white", xlab="Ozone (ppm)", ylab="Altitude (km)", ylim=c(0,10), main="Cotonou")
#for (i in 1:12) {
#lines(cotonou.dat[,i], data.heights, xlim=c(0,0.10), col="gray", lwd=2, lty=2)
#lines(cotonou.mod[,i], hgt, col="gray", lwd=2 ) }
#grid()


dev.off()