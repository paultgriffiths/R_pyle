# R script to plot model profiles vs observations
# Alex Archibald, February,  2012



# Subset the model and obs into three domains:
# -80:-30, -30:30, 30:80
# Mean over time and longitude (the obs are generally
# zonal means)

# function to find the index in the input file 
# for the latitude bands
find.lat <- function(lat, x) {
which(lat>=x)[1]	
}

# Extract model variables and define constants, 
# loop vars
source(paste(script.dir, "get_model_dims.R", sep=""))
hgt  <- hgt*1E-3 # conver to km

ppm  <- 1E6
ppb  <- 1E9
ppt  <- 1E12

if ( (mod1.type=="CheS") | (mod1.type=="CheST") ) {
top.height <- which(hgt>=60.)[1] }

if ( (mod1.type=="CheT") ) {
top.height <- which(hgt>=60.)[1] }


# define the latitudes to extract data over:
sh.min   <- -90; sh.max   <- -60
mh.min   <- -60; mh.max   <- -30
trop.min <- -30; trop.max <- 30
nh.min   <-  30; nh.max   <- 60
uh.min   <-  60; uh.max   <- 90
# ###################################################################################################################################
# S. Hemisphere subsets: Pass into generic script
first.lat <- sh.min
last.lat  <- sh.max
location  <- "sh"
source(paste(script.dir, "get_model_profiles.R", sep=""))
source(paste(script.dir, "get_ace_profiles.R", sep=""))
source(paste(script.dir, "get_uars_profiles.R", sep=""))
source(paste(script.dir, "get_mipas_profiles.R", sep=""))
source(paste(script.dir, "get_tes_profiles.R", sep=""))
source(paste(script.dir, "get_mls_profiles.R", sep=""))

# N. Hemisphere subsets: Pass into generic script
first.lat <- nh.min
last.lat  <- nh.max
location  <- "nh"
source(paste(script.dir, "get_model_profiles.R", sep=""))
source(paste(script.dir, "get_ace_profiles.R", sep=""))
source(paste(script.dir, "get_uars_profiles.R", sep=""))
source(paste(script.dir, "get_mipas_profiles.R", sep=""))
source(paste(script.dir, "get_tes_profiles.R", sep=""))
source(paste(script.dir, "get_mls_profiles.R", sep=""))

# Tropical subsets: Pass into generic script
first.lat <- trop.min
last.lat  <- trop.max
location  <- "trop"
source(paste(script.dir, "get_model_profiles.R", sep=""))
source(paste(script.dir, "get_ace_profiles.R", sep=""))
source(paste(script.dir, "get_uars_profiles.R", sep=""))
source(paste(script.dir, "get_mipas_profiles.R", sep=""))
source(paste(script.dir, "get_tes_profiles.R", sep=""))
source(paste(script.dir, "get_mls_profiles.R", sep=""))

# S. Hemisphere mid latitude subsets: Pass into generic script
first.lat <- mh.min
last.lat  <- mh.max
location  <- "mh"
source(paste(script.dir, "get_model_profiles.R", sep=""))
source(paste(script.dir, "get_ace_profiles.R", sep=""))
source(paste(script.dir, "get_uars_profiles.R", sep=""))
source(paste(script.dir, "get_mipas_profiles.R", sep=""))
source(paste(script.dir, "get_tes_profiles.R", sep=""))
source(paste(script.dir, "get_mls_profiles.R", sep=""))

# N. Hemisphere mid latitude subsets: Pass into generic script
first.lat <- uh.min
last.lat  <- uh.max
location  <- "uh"
source(paste(script.dir, "get_model_profiles.R", sep=""))
source(paste(script.dir, "get_ace_profiles.R", sep=""))
#source(paste(script.dir, "get_uars_profiles.R", sep=""))
#source(paste(script.dir, "get_mipas_profiles.R", sep=""))
source(paste(script.dir, "get_tes_profiles.R", sep=""))
#source(paste(script.dir, "get_mls_profiles.R", sep=""))
# ###################################################################################################################################
pdf(paste(out.dir,mod1.name,"_profiles.pdf", sep=""),width=21,height=14,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(1.0,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:10, 2, 5, byrow = TRUE))

plot(sh.mod.o3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Ozone (ppmv)", xlim=c(0,12), main="90S - 60S")
# Add the obs data
lines(sh.ace.o3.z*ppm, ace.hgt, lwd=2, col="blue")
lines(sh.uars.o3.z, uars.hgt, lwd=2, col="black")
lines(sh.mls.o3.z*ppm, mls.hgt, lwd=2, col="orange")
#lines(sh.mipas.o3.z, mipas.hgt, lwd=2, col="green")
lines(sh.tes.o3.z*ppm, tes.hgt, lwd=2, col="pink")
arrows( (sh.mod.o3.z-sh.mod.o3.z.sd), hgt, (sh.mod.o3.z+sh.mod.o3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS", "MLS", "MIPAS", "TES"), lwd=1, col=c("red","blue","black","orange","green","pink"), bty="n" )

plot(mh.mod.o3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Ozone (ppmv)", xlim=c(0,12), main="60S - 30S")
# Add the obs data
lines(mh.ace.o3.z*ppm, ace.hgt, lwd=2, col="blue")
lines(mh.uars.o3.z, uars.hgt, lwd=2, col="black")
lines(mh.mls.o3.z*ppm, mls.hgt, lwd=2, col="orange")
lines(mh.mipas.o3.z, mipas.hgt, lwd=2, col="green")
lines(mh.tes.o3.z*ppm, tes.hgt, lwd=2, col="pink")
arrows( (mh.mod.o3.z-mh.mod.o3.z.sd), hgt, (mh.mod.o3.z+sh.mod.o3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS", "MLS", "MIPAS", "TES"), lwd=1, col=c("red","blue","black","orange","green","pink"), bty="n" )

plot(trop.mod.o3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Ozone (ppmv)", xlim=c(0,12), main="30S - 30N")
# Add the obs data
lines(trop.ace.o3.z*ppm, ace.hgt, lwd=2, col="blue")
lines(trop.uars.o3.z, uars.hgt, lwd=2, col="black")
lines(trop.mls.o3.z*ppm, mls.hgt, lwd=2, col="orange")
lines(trop.mipas.o3.z, mipas.hgt, lwd=2, col="green")
lines(trop.ace.o3.z*ppm, ace.hgt, lwd=2, col="pink")
arrows( (trop.mod.o3.z-trop.mod.o3.z.sd), hgt, (trop.mod.o3.z+trop.mod.o3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS", "MLS", "MIPAS", "TES"), lwd=1, col=c("red","blue","black","orange","green","pink"), bty="n" )

plot(uh.mod.o3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Ozone (ppmv)", xlim=c(0,12), main="30N - 60N")
# Add the obs data
lines(uh.ace.o3.z*ppm, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.o3.z, uars.hgt, lwd=2, col="black")
#lines(uh.mls.o3.z*ppm, mls.hgt, lwd=2, col="orange")
#lines(uh.mipas.o3.z, mipas.hgt, lwd=2, col="green")
#lines(uh.tes.o3.z*ppm, tes.hgt, lwd=2, col="pink")
arrows( (uh.mod.o3.z-uh.mod.o3.z.sd), hgt, (uh.mod.o3.z+sh.mod.o3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS", "MLS", "MIPAS", "TES"), lwd=1, col=c("red","blue","black","orange","green","pink"), bty="n" )

plot(nh.mod.o3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Ozone (ppmv)", xlim=c(0,12), main="60N - 90N")
# Add the obs data
lines(nh.ace.o3.z*ppm, ace.hgt, lwd=2, col="blue")
lines(nh.uars.o3.z, uars.hgt, lwd=2, col="black")
lines(nh.mls.o3.z*ppm, mls.hgt, lwd=2, col="orange")
#lines(nh.mipas.o3.z, mipas.hgt, lwd=2, col="green")
lines(nh.tes.o3.z*ppm, tes.hgt, lwd=2, col="pink")
arrows( (nh.mod.o3.z-nh.mod.o3.z.sd), hgt, (nh.mod.o3.z+sh.mod.o3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS", "MLS", "MIPAS", "TES"), lwd=1, col=c("red","blue","black","orange","green","pink"), bty="n" )

plot(sh.mod.co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="CO (ppbv)", xlim=c(1,200), main="90S - 60S")
# Add the obs data
lines(sh.ace.co.z*ppb, ace.hgt, lwd=2, col="blue")
arrows( (sh.mod.co.z-sh.mod.co.z.sd), hgt, (sh.mod.co.z+sh.mod.co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(mh.mod.co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="CO (ppbv)", xlim=c(1,200), main="60S - 30S")
# Add the obs data
lines(mh.ace.co.z*ppb, ace.hgt, lwd=2, col="blue")
arrows( (mh.mod.co.z-mh.mod.co.z.sd), hgt, (mh.mod.co.z+mh.mod.co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(trop.mod.co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="CO (ppbv)", xlim=c(1,200), main="30S - 30N")
# Add the obs data
lines(trop.ace.co.z*ppb, ace.hgt, lwd=2, col="blue")
arrows( (trop.mod.co.z-trop.mod.co.z.sd), hgt, (trop.mod.co.z+trop.mod.co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(uh.mod.co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="CO (ppbv)", xlim=c(1,200), main="30N - 60N")
# Add the obs data
lines(uh.ace.co.z*ppb, ace.hgt, lwd=2, col="blue")
arrows( (uh.mod.co.z-uh.mod.co.z.sd), hgt, (uh.mod.co.z+uh.mod.co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(nh.mod.co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="CO (ppbv)", xlim=c(1,200), main="60N - 90N")
# Add the obs data
lines(nh.ace.co.z*ppb, ace.hgt, lwd=2, col="blue")
arrows( (nh.mod.co.z-nh.mod.co.z.sd), hgt, (nh.mod.co.z+nh.mod.co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(sh.mod.h2o2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O[2]," (pptv)", sep="")), xlim=c(0,1000), main="90S - 60S")
arrows( (sh.mod.h2o2.z-sh.mod.h2o2.z.sd), hgt, (sh.mod.h2o2.z+sh.mod.h2o2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(mh.mod.h2o2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O[2]," (pptv)", sep="")), xlim=c(0,1000), main="60S - 30S")
arrows( (mh.mod.h2o2.z-mh.mod.h2o2.z.sd), hgt, (mh.mod.h2o2.z+mh.mod.h2o2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(trop.mod.h2o2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O[2]," (pptv)", sep="")), xlim=c(0,1000), main="30S - 30N")
arrows( (trop.mod.h2o2.z-trop.mod.h2o2.z.sd), hgt, (trop.mod.h2o2.z+trop.mod.h2o2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(uh.mod.h2o2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O[2]," (pptv)", sep="")), xlim=c(0,1000), main="30N - 60N")
arrows( (uh.mod.h2o2.z-uh.mod.h2o2.z.sd), hgt, (uh.mod.h2o2.z+uh.mod.h2o2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(nh.mod.h2o2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O[2]," (pptv)", sep="")), xlim=c(0,1000), main="60N - 90N")
arrows( (nh.mod.h2o2.z-nh.mod.h2o2.z.sd), hgt, (nh.mod.h2o2.z+nh.mod.h2o2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(sh.mod.hno3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( HONO[2]," (ppbv)", sep="")), xlim=c(0,12), main="90S - 60S")
# Add the obs data
lines(sh.ace.hno3.z*ppb, ace.hgt, lwd=2, col="blue")
lines(sh.uars.hno3.z, uars.hgt, lwd=2, col="black")
arrows( (sh.mod.hno3.z-sh.mod.hno3.z.sd), hgt, (sh.mod.hno3.z+sh.mod.hno3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(mh.mod.hno3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( HONO[2]," (ppbv)", sep="")), xlim=c(0,12), main="60S - 30S")
# Add the obs data
lines(mh.ace.hno3.z*ppb, ace.hgt, lwd=2, col="blue")
lines(mh.uars.hno3.z, uars.hgt, lwd=2, col="black")
arrows( (mh.mod.hno3.z-mh.mod.hno3.z.sd), hgt, (mh.mod.hno3.z+mh.mod.hno3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(trop.mod.hno3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( HONO[2]," (ppbv)", sep="")), xlim=c(0,12), main="30S - 30N")
# Add the obs data
lines(trop.ace.hno3.z*ppb, ace.hgt, lwd=2, col="blue")
lines(trop.uars.hno3.z, uars.hgt, lwd=2, col="black")
arrows( (trop.mod.hno3.z-trop.mod.hno3.z.sd), hgt, (trop.mod.hno3.z+trop.mod.hno3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(uh.mod.hno3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( HONO[2]," (ppbv)", sep="")), xlim=c(0,12), main="30N - 60N")
# Add the obs data
arrows( (uh.mod.hno3.z-uh.mod.hno3.z.sd), hgt, (uh.mod.hno3.z+uh.mod.hno3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
lines(uh.ace.hno3.z*ppb, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.hno3.z, uars.hgt, lwd=2, col="black")
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(nh.mod.hno3.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( HONO[2]," (ppbv)", sep="")), xlim=c(0,12), main="60N - 90N")
# Add the obs data
lines(nh.ace.hno3.z*ppb, ace.hgt, lwd=2, col="blue")
lines(nh.uars.hno3.z, uars.hgt, lwd=2, col="black")
arrows( (nh.mod.hno3.z-nh.mod.hno3.z.sd), hgt, (nh.mod.hno3.z+nh.mod.hno3.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(sh.mod.no.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NO (ppbv)", xlim=c(0,10), main="90S - 60S")
# Add the obs data
lines(sh.ace.no.z*ppb, ace.hgt, lwd=2, col="blue")
lines(sh.uars.no.z, uars.hgt, lwd=2, col="black")
arrows( (sh.mod.no.z-sh.mod.no.z.sd), hgt, (sh.mod.no.z+sh.mod.no.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(mh.mod.no.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NO (ppbv)", xlim=c(0,10), main="60S - 30S")
# Add the obs data
lines(mh.ace.no.z*ppb, ace.hgt, lwd=2, col="blue")
lines(mh.uars.no.z, uars.hgt, lwd=2, col="black")
arrows( (mh.mod.no.z-mh.mod.no.z.sd), hgt, (mh.mod.no.z+mh.mod.no.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(trop.mod.no.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NO (ppbv)", xlim=c(0,10), main="30S - 30N")
# Add the obs data
lines(trop.ace.no.z*ppb, ace.hgt, lwd=2, col="blue")
lines(trop.uars.no.z, uars.hgt, lwd=2, col="black")
arrows( (trop.mod.no.z-trop.mod.no.z.sd), hgt, (trop.mod.no.z+trop.mod.no.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(uh.mod.no.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NO (ppbv)", xlim=c(0,10), main="30N - 60N")
# Add the obs data
lines(uh.ace.no.z*ppb, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.no.z, uars.hgt, lwd=2, col="black")
arrows( (uh.mod.no.z-uh.mod.no.z.sd), hgt, (uh.mod.no.z+uh.mod.no.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(nh.mod.no.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NO (ppbv)", xlim=c(0,10), main="60N - 90N")
# Add the obs data
lines(nh.ace.no.z*ppb, ace.hgt, lwd=2, col="blue")
lines(nh.uars.no.z, uars.hgt, lwd=2, col="black")
arrows( (nh.mod.no.z-nh.mod.no.z.sd), hgt, (nh.mod.no.z+nh.mod.no.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(sh.mod.no2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( NO[2]," (ppbv)", sep="")), xlim=c(0,10), main="90S - 60S")
# Add the obs data
lines(sh.ace.no2.z*ppb, ace.hgt, lwd=2, col="blue")
lines(sh.uars.no2.z, uars.hgt, lwd=2, col="black")
arrows( (sh.mod.no2.z-sh.mod.no2.z.sd), hgt, (sh.mod.no2.z+sh.mod.no2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(mh.mod.no2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( NO[2]," (ppbv)", sep="")), xlim=c(0,10), main="60S - 30S")
# Add the obs data
lines(mh.ace.no2.z*ppb, ace.hgt, lwd=2, col="blue")
lines(mh.uars.no2.z, uars.hgt, lwd=2, col="black")
arrows( (mh.mod.no2.z-mh.mod.no2.z.sd), hgt, (mh.mod.no2.z+mh.mod.no2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(trop.mod.no2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( NO[2]," (ppbv)", sep="")), xlim=c(0,10), main="30S - 30N")
# Add the obs data
lines(trop.ace.no2.z*ppb, ace.hgt, lwd=2, col="blue")
lines(trop.uars.no2.z, uars.hgt, lwd=2, col="black")
arrows( (trop.mod.no2.z-trop.mod.no2.z.sd), hgt, (trop.mod.no2.z+trop.mod.no2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(uh.mod.no2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( NO[2]," (ppbv)", sep="")), xlim=c(0,10), main="30N - 60N")
# Add the obs data
lines(uh.ace.no2.z*ppb, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.no2.z, uars.hgt, lwd=2, col="black")
arrows( (uh.mod.no2.z-uh.mod.no2.z.sd), hgt, (uh.mod.no2.z+uh.mod.no2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(nh.mod.no2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( NO[2]," (ppbv)", sep="")), xlim=c(0,10), main="60N - 90N")
# Add the obs data
lines(nh.ace.no2.z*ppb, ace.hgt, lwd=2, col="blue")
lines(nh.uars.no2.z, uars.hgt, lwd=2, col="black")
arrows( (nh.mod.no2.z-nh.mod.no2.z.sd), hgt, (nh.mod.no2.z+nh.mod.no2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(sh.mod.h2co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCHO (pptv)", xlim=c(0,500), main="90S - 60S")
# Add the obs data
lines(sh.ace.h2co.z*ppt, ace.hgt, lwd=2, col="blue")
arrows( (sh.mod.h2co.z-sh.mod.h2co.z.sd), hgt, (sh.mod.h2co.z+sh.mod.h2co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(mh.mod.h2co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCHO (pptv)", xlim=c(0,500), main="60S - 30S")
# Add the obs data
lines(mh.ace.h2co.z*ppt, ace.hgt, lwd=2, col="blue")
arrows( (mh.mod.h2co.z-mh.mod.h2co.z.sd), hgt, (mh.mod.h2co.z+mh.mod.h2co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(trop.mod.h2co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCHO (pptv)", xlim=c(0,500), main="30S - 30N")
# Add the obs data
lines(trop.ace.h2co.z*ppt, ace.hgt, lwd=2, col="blue")
arrows( (trop.mod.h2co.z-trop.mod.h2co.z.sd), hgt, (trop.mod.h2co.z+trop.mod.h2co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(uh.mod.h2co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCHO (pptv)", xlim=c(0,500), main="30N - 60N")
# Add the obs data
lines(uh.ace.h2co.z*ppt, ace.hgt, lwd=2, col="blue")
arrows( (uh.mod.h2co.z-uh.mod.h2co.z.sd), hgt, (uh.mod.h2co.z+uh.mod.h2co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

plot(nh.mod.h2co.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCHO (pptv)", xlim=c(0,500), main="60N - 90N")
# Add the obs data
arrows( (nh.mod.h2co.z-nh.mod.h2co.z.sd), hgt, (nh.mod.h2co.z+nh.mod.h2co.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
lines(nh.ace.h2co.z*ppt, ace.hgt, lwd=2, col="blue")
grid()
legend("bottomright", c(mod1.name, "ACE"), lwd=1, col=c("red","blue"), bty="n" )

if ( (mod1.type=="CheS") | (mod1.type=="CheST") ) {

plot(sh.mod.clono2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( ClONO[2]," (pptv)", sep="")), xlim=c(0,1000), main="90S - 60S")
# Add the obs data
lines(sh.ace.clono2.z*ppt, ace.hgt, lwd=2, col="blue")
#lines(sh.uars.clono2.z, uars.hgt, lwd=2, col="black")
arrows( (sh.mod.clono2.z-sh.mod.clono2.z.sd), hgt, (sh.mod.clono2.z+sh.mod.clono2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(mh.mod.clono2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( ClONO[2]," (pptv)", sep="")), xlim=c(0,1000), main="60S - 30S")
# Add the obs data
lines(mh.ace.clono2.z*ppt, ace.hgt, lwd=2, col="blue")
#lines(mh.uars.clono2.z, uars.hgt, lwd=2, col="black")
arrows( (mh.mod.clono2.z-mh.mod.clono2.z.sd), hgt, (mh.mod.clono2.z+mh.mod.clono2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(trop.mod.clono2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( ClONO[2]," (pptv)", sep="")), xlim=c(0,1000), main="30S - 30N")
# Add the obs data
lines(trop.ace.clono2.z*ppt, ace.hgt, lwd=2, col="blue")
#lines(trop.uars.clono2.z, uars.hgt, lwd=2, col="black")
arrows( (trop.mod.clono2.z-trop.mod.clono2.z.sd), hgt, (trop.mod.clono2.z+trop.mod.clono2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(uh.mod.clono2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( ClONO[2]," (pptv)", sep="")), xlim=c(0,1000), main="30N - 60N")
# Add the obs data
lines(uh.ace.clono2.z*ppt, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.clono2.z, uars.hgt, lwd=2, col="black")
arrows( (uh.mod.clono2.z-uh.mod.clono2.z.sd), hgt, (uh.mod.clono2.z+uh.mod.clono2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(nh.mod.clono2.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( ClONO[2]," (pptv)", sep="")), xlim=c(0,1000), main="60N - 90N")
# Add the obs data
lines(nh.ace.clono2.z*ppt, ace.hgt, lwd=2, col="blue")
#lines(nh.uars.clono2.z, uars.hgt, lwd=2, col="black")
arrows( (nh.mod.clono2.z-nh.mod.clono2.z.sd), hgt, (nh.mod.clono2.z+nh.mod.clono2.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(sh.mod.h2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O," (ppmv)", sep="")), xlim=c(0,50), main="90S - 60S")
# Add the obs data
lines(sh.ace.h2o.z*ppm, ace.hgt, lwd=2, col="blue")
lines(sh.uars.h2o.z, uars.hgt, lwd=2, col="black")
arrows( (sh.mod.h2o.z-sh.mod.h2o.z.sd), hgt, (sh.mod.h2o.z+sh.mod.h2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(mh.mod.h2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O," (ppmv)", sep="")), xlim=c(0,50), main="60S - 30S")
# Add the obs data
lines(mh.ace.h2o.z*ppm, ace.hgt, lwd=2, col="blue")
lines(mh.uars.h2o.z, uars.hgt, lwd=2, col="black")
arrows( (mh.mod.h2o.z-mh.mod.h2o.z.sd), hgt, (mh.mod.h2o.z+mh.mod.h2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(trop.mod.h2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O," (ppmv)", sep="")), xlim=c(0,50), main="30S - 30N")
# Add the obs data
lines(trop.ace.h2o.z*ppm, ace.hgt, lwd=2, col="blue")
lines(trop.uars.h2o.z, uars.hgt, lwd=2, col="black")
arrows( (trop.mod.h2o.z-trop.mod.h2o.z.sd), hgt, (trop.mod.h2o.z+trop.mod.h2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(uh.mod.h2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O," (ppmv)", sep="")), xlim=c(0,50), main="30N - 60N")
# Add the obs data
lines(uh.ace.h2o.z*ppm, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.h2o.z, uars.hgt, lwd=2, col="black")
arrows( (uh.mod.h2o.z-uh.mod.h2o.z.sd), hgt, (uh.mod.h2o.z+uh.mod.h2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(nh.mod.h2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( H[2],O," (ppmv)", sep="")), xlim=c(0,50), main="60N - 90N")
# Add the obs data
lines(nh.ace.h2o.z*ppm, ace.hgt, lwd=2, col="blue")
lines(nh.uars.h2o.z, uars.hgt, lwd=2, col="black")
arrows( (nh.mod.h2o.z-nh.mod.h2o.z.sd), hgt, (nh.mod.h2o.z+nh.mod.h2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(sh.mod.hcl.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCl (ppbv)", xlim=c(0,10), main="90S - 60S")
# Add the obs data
lines(sh.ace.hcl.z*ppb, ace.hgt, lwd=2, col="blue")
lines(sh.uars.hcl.z, uars.hgt, lwd=2, col="black")
arrows( (sh.mod.hcl.z-sh.mod.hcl.z.sd), hgt, (sh.mod.hcl.z+sh.mod.hcl.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(mh.mod.hcl.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCl (ppbv)", xlim=c(0,10), main="60S - 30S")
# Add the obs data
lines(mh.ace.hcl.z*ppb, ace.hgt, lwd=2, col="blue")
lines(mh.uars.hcl.z, uars.hgt, lwd=2, col="black")
arrows( (mh.mod.hcl.z-mh.mod.hcl.z.sd), hgt, (mh.mod.hcl.z+mh.mod.hcl.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(trop.mod.hcl.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCl (ppbv)", xlim=c(0,10), main="30S - 30N")
# Add the obs data
lines(trop.ace.hcl.z*ppb, ace.hgt, lwd=2, col="blue")
lines(trop.uars.hcl.z, uars.hgt, lwd=2, col="black")
arrows( (trop.mod.hcl.z-trop.mod.hcl.z.sd), hgt, (trop.mod.hcl.z+trop.mod.hcl.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(uh.mod.hcl.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCl (ppbv)", xlim=c(0,10), main="30N - 60N")
# Add the obs data
lines(uh.ace.hcl.z*ppb, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.hcl.z, uars.hgt, lwd=2, col="black")
arrows( (uh.mod.hcl.z-uh.mod.hcl.z.sd), hgt, (uh.mod.hcl.z+uh.mod.hcl.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(nh.mod.hcl.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="HCl (ppbv)", xlim=c(0,10), main="60N - 90N")
# Add the obs data
lines(nh.ace.hcl.z*ppb, ace.hgt, lwd=2, col="blue")
lines(nh.uars.hcl.z, uars.hgt, lwd=2, col="black")
arrows( (nh.mod.hcl.z-nh.mod.hcl.z.sd), hgt, (nh.mod.hcl.z+nh.mod.hcl.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(sh.mod.n2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( N[2],O," (ppbv)", sep="")), xlim=c(0,400), main="90S - 60S")
# Add the obs data
lines(sh.ace.n2o.z*ppb, ace.hgt, lwd=2, col="blue")
lines(sh.uars.n2o.z, uars.hgt, lwd=2, col="black")
arrows( (sh.mod.n2o.z-sh.mod.n2o.z.sd), hgt, (sh.mod.n2o.z+sh.mod.n2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(mh.mod.n2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( N[2],O," (ppbv)", sep="")), xlim=c(0,400), main="60S - 30S")
# Add the obs data
lines(mh.ace.n2o.z*ppb, ace.hgt, lwd=2, col="blue")
lines(mh.uars.n2o.z, uars.hgt, lwd=2, col="black")
arrows( (mh.mod.n2o.z-mh.mod.n2o.z.sd), hgt, (mh.mod.n2o.z+mh.mod.n2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(trop.mod.n2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( N[2],O," (ppbv)", sep="")), xlim=c(0,400), main="30S - 30N")
# Add the obs data
lines(trop.ace.n2o.z*ppb, ace.hgt, lwd=2, col="blue")
lines(trop.uars.n2o.z, uars.hgt, lwd=2, col="black")
arrows( (trop.mod.n2o.z-trop.mod.n2o.z.sd), hgt, (trop.mod.n2o.z+trop.mod.n2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(uh.mod.n2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( N[2],O," (ppbv)", sep="")), xlim=c(0,400), main="30N - 60N")
# Add the obs data
lines(uh.ace.n2o.z*ppb, ace.hgt, lwd=2, col="blue")
#lines(uh.uars.n2o.z, uars.hgt, lwd=2, col="black")
arrows( (uh.mod.n2o.z-uh.mod.n2o.z.sd), hgt, (uh.mod.n2o.z+uh.mod.n2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(nh.mod.n2o.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab=bquote(paste( N[2],O," (ppbv)", sep="")), xlim=c(0,400), main="60N - 90N")
# Add the obs data
lines(nh.ace.n2o.z*ppb, ace.hgt, lwd=2, col="blue")
lines(nh.uars.n2o.z, uars.hgt, lwd=2, col="black")
arrows( (nh.mod.n2o.z-nh.mod.n2o.z.sd), hgt, (nh.mod.n2o.z+nh.mod.n2o.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", c(mod1.name, "ACE", "UARS"), lwd=1, col=c("red","blue","black"), bty="n" )

plot(sh.mod.noy.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NOy (ppbv)", xlim=c(0,20), main="90S - 60S")
arrows( (sh.mod.noy.z-sh.mod.noy.z.sd), hgt, (sh.mod.noy.z+sh.mod.noy.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(mh.mod.noy.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NOy (ppbv)", xlim=c(0,20), main="60S - 30S")
arrows( (mh.mod.noy.z-mh.mod.noy.z.sd), hgt, (mh.mod.noy.z+mh.mod.noy.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(trop.mod.noy.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NOy (ppbv)", xlim=c(0,20), main="30S - 30N")
arrows( (trop.mod.noy.z-trop.mod.noy.z.sd), hgt, (trop.mod.noy.z+trop.mod.noy.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(uh.mod.noy.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NOy (ppbv)", xlim=c(0,20), main="30N - 60N")
arrows( (uh.mod.noy.z-uh.mod.noy.z.sd), hgt, (uh.mod.noy.z+uh.mod.noy.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(nh.mod.noy.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="NOy (ppbv)", xlim=c(0,20), main="60N - 90N")
arrows( (nh.mod.noy.z-nh.mod.noy.z.sd), hgt, (nh.mod.noy.z+nh.mod.noy.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(sh.mod.cly.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Cly (ppbv)", xlim=c(0,5), main="90S - 60S")
arrows( (sh.mod.cly.z-sh.mod.cly.z.sd), hgt, (sh.mod.cly.z+sh.mod.cly.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(mh.mod.cly.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Cly (ppbv)", xlim=c(0,5), main="60S - 30S")
arrows( (mh.mod.cly.z-mh.mod.cly.z.sd), hgt, (mh.mod.cly.z+mh.mod.cly.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(trop.mod.cly.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Cly (ppbv)", xlim=c(0,5), main="30S - 30N")
arrows( (trop.mod.cly.z-trop.mod.cly.z.sd), hgt, (trop.mod.cly.z+trop.mod.cly.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(uh.mod.cly.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Cly (ppbv)", xlim=c(0,5), main="30N - 60N")
arrows( (uh.mod.cly.z-uh.mod.cly.z.sd), hgt, (uh.mod.cly.z+uh.mod.cly.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )

plot(nh.mod.cly.z[1:top.height], hgt[1:top.height], type = "l", col="red", lwd=2,
ylab="Altitude /km", xlab="Cly (ppbv)", xlim=c(0,5), main="60N - 90N")
arrows( (nh.mod.cly.z-nh.mod.cly.z.sd), hgt, (nh.mod.cly.z+nh.mod.cly.z.sd), hgt, length = 0.0, code =2, col="red", cex=0.8 )
grid()
legend("bottomright", mod1.name, lwd=1, col=("red"), bty="n" )


} # end if CheS or CheST

dev.off()

