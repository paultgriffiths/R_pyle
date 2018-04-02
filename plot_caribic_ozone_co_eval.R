# R script to plot model CO and Ozone versus 
# CARIBIC observations -- subset to look at 
# 8-12 km (UTLS)

# ATA, June 2012
rm(var)
# define constants and vars
i <- NULL
conv <- 1E9

# extract observations
data <- read.table(paste(obs.dir, "CARIBIC/CARIBIC_CO-O3_All.dat", sep=""), sep="\t", header=F)

names <- c("year","month","day","UTC","FlightPhase","PosLat","PosLong","TrueHead","WindSpeed","WindDirTr","PitchAng",
"RollAng","StdAltitu","BaroAltit","TrAirSpeed","ToAirTmp","AltitRate","StcAirTmp","AngOAttck","TotPres","VertSpeed",
"GndSpeed","LocTime","pstatic","Tpot","Altitude","ozone","H_rel_TP","co")

names(data) <- names

# subset the data to focus on the UT-LS
data <- subset(data, Altitude >= 8000 & Altitude <=12000 )

data$date = ISOdate(data$year,data$month,data$day)+data$UTC

data[data==9999999]<-NA

# ##################################################################################################################################
# Extra areas based on Elias et al. ACP 2011
regions <- read.csv(paste(obs.dir, "CARIBIC/Elias_regions.dat", sep=""))

for (i in 1:length(regions$region) ) {
assign(paste(regions$region[i],".data",sep=""), subset(data, PosLat >= regions$lat1[i] & PosLat <= regions$lat2[i] & PosLong <= regions$lon2[i] & PosLong >= regions$lon1[i]) )
}

# generate means and standard deviation of the data
M.L.S.Am.means <- aggregate(M.L.S.Am.data, format(M.L.S.Am.data["date"],"%m"), mean, na.rm = TRUE)
M.L.S.Am.var   <- aggregate(M.L.S.Am.data, format(M.L.S.Am.data["date"],"%m"), var, na.rm = TRUE)

E.S.Am.means <- aggregate(E.S.Am.data, format(E.S.Am.data["date"],"%m"), mean, na.rm = TRUE)
E.S.Am.var   <- aggregate(E.S.Am.data, format(E.S.Am.data["date"],"%m"), var, na.rm = TRUE)
  
T.A.O.means <- aggregate(T.A.O.data, format(T.A.O.data["date"],"%m"), mean, na.rm = TRUE)
T.A.O.var   <- aggregate(T.A.O.data, format(T.A.O.data["date"],"%m"), var, na.rm = TRUE)

N.A.O.means <- aggregate(N.A.O.data, format(N.A.O.data["date"],"%m"), mean, na.rm = TRUE)
N.A.O.var   <- aggregate(N.A.O.data, format(N.A.O.data["date"],"%m"), var, na.rm = TRUE)

E.N.Am.means <- aggregate(E.N.Am.data, format(E.N.Am.data["date"],"%m"), mean, na.rm = TRUE)
E.N.Am.var   <- aggregate(E.N.Am.data, format(E.N.Am.data["date"],"%m"), var, na.rm = TRUE)

Eur.Med.means <- aggregate(Eur.Med.data, format(Eur.Med.data["date"],"%m"), mean, na.rm = TRUE)
Eur.Med.var   <- aggregate(Eur.Med.data, format(Eur.Med.data["date"],"%m"), var, na.rm = TRUE)

N.Euro.means <- aggregate(N.Euro.data, format(N.Euro.data["date"],"%m"), mean, na.rm = TRUE)
N.Euro.var   <- aggregate(N.Euro.data, format(N.Euro.data["date"],"%m"), var, na.rm = TRUE)

N.Asia.means <- aggregate(N.Asia.data, format(N.Asia.data["date"],"%m"), mean, na.rm = TRUE)
N.Asia.var   <- aggregate(N.Asia.data, format(N.Asia.data["date"],"%m"), var, na.rm = TRUE)

C.Asia.means <- aggregate(C.Asia.data, format(C.Asia.data["date"],"%m"), mean, na.rm = TRUE)
C.Asia.var   <- aggregate(C.Asia.data, format(C.Asia.data["date"],"%m"), var, na.rm = TRUE)

C.S.Chi.means <- aggregate(C.S.Chi.data, format(C.S.Chi.data["date"],"%m"), mean, na.rm = TRUE)
C.S.Chi.var   <- aggregate(C.S.Chi.data, format(C.S.Chi.data["date"],"%m"), var, na.rm = TRUE)

S.Chi.S.means <- aggregate(S.Chi.S.data, format(S.Chi.S.data["date"],"%m"), mean, na.rm = TRUE)
S.Chi.S.var   <- aggregate(S.Chi.S.data, format(S.Chi.S.data["date"],"%m"), var, na.rm = TRUE)
# ##################################################################################################################################

# extract data from model
for (i in 1:length(regions$region) ) {
first.lat <- regions$lat1[i]
last.lat  <- regions$lat2[i]
first.lon <- regions$lon1[i]
last.lon  <- regions$lon2[i]
location  <- regions$region[i]
source(paste(script.dir, "get_model_caribic.R", sep=""))
}

monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")
# ##################################################################################################################################
# Plot data
pdf(file=paste(out.dir,mod1.name,"_CARIBIC_O3_comparison.pdf", sep=""),width=21,height=14,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.6,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:12, 4, 3, byrow = TRUE))

plot(1:12, M.L.S.Am.mod.o3.mean, ylim=c(30,150), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="M.L.S.Am", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, M.L.S.Am.mod.o3.mean-(M.L.S.Am.mod.o3.var)^{1/2},  1:12, M.L.S.Am.mod.o3.mean+(M.L.S.Am.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(M.L.S.Am.means$month, M.L.S.Am.means$ozone, col="black", pch=1)
arrows( M.L.S.Am.means$month, M.L.S.Am.means$ozone-(M.L.S.Am.var$ozone)^{1/2},  M.L.S.Am.means$month, M.L.S.Am.means$ozone+(M.L.S.Am.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )
legend("topleft", c(mod1.name,"CARIBIC"), lwd=1, col=c("red","black"), bty="n")

plot(1:12, E.S.Am.mod.o3.mean, ylim=c(30,100), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="E.S.Am", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, E.S.Am.mod.o3.mean-(E.S.Am.mod.o3.var)^{1/2},  1:12, E.S.Am.mod.o3.mean+(E.S.Am.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(E.S.Am.means$month, E.S.Am.means$ozone, col="black", pch=1)
arrows( E.S.Am.means$month, E.S.Am.means$ozone-(E.S.Am.var$ozone)^{1/2},  E.S.Am.means$month, E.S.Am.means$ozone+(E.S.Am.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, T.A.O.mod.o3.mean, ylim=c(30,100), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="T.A.O", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, T.A.O.mod.o3.mean-(T.A.O.mod.o3.var)^{1/2},  1:12, T.A.O.mod.o3.mean+(T.A.O.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(T.A.O.means$month, T.A.O.means$ozone, col="black", pch=1)
arrows( T.A.O.means$month, T.A.O.means$ozone-(T.A.O.var$ozone)^{1/2},  T.A.O.means$month, T.A.O.means$ozone+(T.A.O.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, N.A.O.mod.o3.mean, ylim=c(30,250), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="N.A.O", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, N.A.O.mod.o3.mean-(N.A.O.mod.o3.var)^{1/2},  1:12, N.A.O.mod.o3.mean+(N.A.O.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(N.A.O.means$month, N.A.O.means$ozone, col="black", pch=1)
arrows( N.A.O.means$month, N.A.O.means$ozone-(N.A.O.var$ozone)^{1/2},  N.A.O.means$month, N.A.O.means$ozone+(N.A.O.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, E.N.Am.mod.o3.mean, ylim=c(30,250), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="E.N.Am", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, E.N.Am.mod.o3.mean-(E.N.Am.mod.o3.var)^{1/2},  1:12, E.N.Am.mod.o3.mean+(E.N.Am.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(E.N.Am.means$month, E.N.Am.means$ozone, col="black", pch=1)
arrows( E.N.Am.means$month, E.N.Am.means$ozone-(E.N.Am.var$ozone)^{1/2},  E.N.Am.means$month, E.N.Am.means$ozone+(E.N.Am.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, Eur.Med.mod.o3.mean, ylim=c(30,250), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="Eur.Med", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, Eur.Med.mod.o3.mean-(Eur.Med.mod.o3.var)^{1/2},  1:12, Eur.Med.mod.o3.mean+(Eur.Med.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(Eur.Med.means$month, Eur.Med.means$ozone, col="black", pch=1)
arrows( Eur.Med.means$month, Eur.Med.means$ozone-(Eur.Med.var$ozone)^{1/2},  Eur.Med.means$month, Eur.Med.means$ozone+(Eur.Med.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, N.Euro.mod.o3.mean, ylim=c(30,350), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="N.Euro", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, N.Euro.mod.o3.mean-(N.Euro.mod.o3.var)^{1/2},  1:12, N.Euro.mod.o3.mean+(N.Euro.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(N.Euro.means$month, N.Euro.means$ozone, col="black", pch=1)
arrows( N.Euro.means$month, N.Euro.means$ozone-(N.Euro.var$ozone)^{1/2},  N.Euro.means$month, N.Euro.means$ozone+(N.Euro.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, N.Asia.mod.o3.mean, ylim=c(30,350), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="N.Asia", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, N.Asia.mod.o3.mean-(N.Asia.mod.o3.var)^{1/2},  1:12, N.Asia.mod.o3.mean+(N.Asia.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(N.Asia.means$month, N.Asia.means$ozone, col="black", pch=1)
arrows( N.Asia.means$month, N.Asia.means$ozone-(N.Asia.var$ozone)^{1/2},  N.Asia.means$month, N.Asia.means$ozone+(N.Asia.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, C.Asia.mod.o3.mean, ylim=c(30,250), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="C.Asia", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, C.Asia.mod.o3.mean-(C.Asia.mod.o3.var)^{1/2},  1:12, C.Asia.mod.o3.mean+(C.Asia.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(C.Asia.means$month, C.Asia.means$ozone, col="black", pch=1)
arrows( C.Asia.means$month, C.Asia.means$ozone-(C.Asia.var$ozone)^{1/2},  C.Asia.means$month, C.Asia.means$ozone+(C.Asia.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, C.S.Chi.mod.o3.mean, ylim=c(30,150), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="C.S.Chi", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, C.S.Chi.mod.o3.mean-(C.S.Chi.mod.o3.var)^{1/2},  1:12, C.S.Chi.mod.o3.mean+(C.S.Chi.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(C.S.Chi.means$month, C.S.Chi.means$ozone, col="black", pch=1)
arrows( C.S.Chi.means$month, C.S.Chi.means$ozone-(C.S.Chi.var$ozone)^{1/2},  C.S.Chi.means$month, C.S.Chi.means$ozone+(C.S.Chi.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, S.Chi.S.mod.o3.mean, ylim=c(30,100), type="o", lwd=1.6, lty=1,  xlab="",  ylab="Ozone (ppbv)", main="S.Chi.S", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, S.Chi.S.mod.o3.mean-(S.Chi.S.mod.o3.var)^{1/2},  1:12, S.Chi.S.mod.o3.mean+(S.Chi.S.mod.o3.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(S.Chi.S.means$month, S.Chi.S.means$ozone, col="black", pch=1)
arrows( S.Chi.S.means$month, S.Chi.S.means$ozone-(S.Chi.S.var$ozone)^{1/2},  S.Chi.S.means$month, S.Chi.S.means$ozone+(S.Chi.S.var$ozone)^{1/2}, length = 0.0, code =2, col="black" )

# add a plot of the regions?
quilt.plot(data$PosLong, data$PosLat, data$Altitude, xlim=c(-180,180), ylim=c(-60,90), add.legend=FALSE )
world(add=T, col="black")
grid()
rect(xleft=-72,ybottom=-35,xright=-46,ytop=-23.5)
text(-60,-30,"M.L.S.Am", cex=1.0,col="black")

rect(xleft=-48,ybottom=-23.5,xright=-20,ytop=0)
text(-30,-15,"E.S.Am.", cex=1.0,col="black")

rect(xleft=-45,ybottom=0,xright=-10,ytop=24)
text(-35,15,"T.A.O", cex=1.0,col="black")

rect(xleft=-55,ybottom=24,xright=-10,ytop=60)
text(-20,45,"N.A.O", cex=1.0,col="black")

rect(xleft=-100,ybottom=25,xright=-55,ytop=60)
text(-70,45,"E.N.Am.", cex=1.0,col="black")

rect(xleft=-10,ybottom=30,xright=40,ytop=51)
text(25,45,"Eur.Med.", cex=1.0,col="black")

rect(xleft=-10,ybottom=51,xright=40,ytop=60)
text(25,55,"N.Euro.", cex=1.0,col="black")

rect(xleft=40,ybottom=50,xright=90,ytop=60)
text(65,55,"N.Asia.", cex=1.0,col="black")

rect(xleft=40,ybottom=30,xright=90,ytop=50)
text(70,40,"C.Asia", cex=1.0,col="black")

rect(xleft=90,ybottom=20,xright=113,ytop=40)
text(105,30,"C.S.Chi", cex=1.0,col="black")

rect(xleft=113,ybottom=14,xright=125,ytop=25)
text(120,20,"S.Chi.S", cex=1.0,col="black")


dev.off()

# ##################################################################################################################################
# Plot data
pdf(file=paste(out.dir,mod1.name,"_CARIBIC_CO_comparison.pdf", sep=""),width=21,height=14,paper="special",onefile=TRUE,pointsize=22)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.6,1.0,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:12, 4, 3, byrow = TRUE))


plot(1:12, M.L.S.Am.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="M.L.S.Am", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, M.L.S.Am.mod.co.mean-(M.L.S.Am.mod.co.var)^{1/2},  1:12, M.L.S.Am.mod.co.mean+(M.L.S.Am.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(M.L.S.Am.means$month, M.L.S.Am.means$co, col="black", pch=1)
arrows( M.L.S.Am.means$month, M.L.S.Am.means$co-(M.L.S.Am.var$co)^{1/2},  M.L.S.Am.means$month, M.L.S.Am.means$co+(M.L.S.Am.var$co)^{1/2}, length = 0.0, code =2, col="black" )
legend("topleft", c(mod1.name,"CARIBIC"), lwd=1, col=c("red","black"), bty="n")

plot(1:12, E.S.Am.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="E.S.Am", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, E.S.Am.mod.co.mean-(E.S.Am.mod.co.var)^{1/2},  1:12, E.S.Am.mod.co.mean+(E.S.Am.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(E.S.Am.means$month, E.S.Am.means$co, col="black", pch=1)
arrows( E.S.Am.means$month, E.S.Am.means$co-(E.S.Am.var$co)^{1/2},  E.S.Am.means$month, E.S.Am.means$co+(E.S.Am.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, T.A.O.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="T.A.O", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, T.A.O.mod.co.mean-(T.A.O.mod.co.var)^{1/2},  1:12, T.A.O.mod.co.mean+(T.A.O.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(T.A.O.means$month, T.A.O.means$co, col="black", pch=1)
arrows( T.A.O.means$month, T.A.O.means$co-(T.A.O.var$co)^{1/2},  T.A.O.means$month, T.A.O.means$co+(T.A.O.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, N.A.O.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="N.A.O", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, N.A.O.mod.co.mean-(N.A.O.mod.co.var)^{1/2},  1:12, N.A.O.mod.co.mean+(N.A.O.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(N.A.O.means$month, N.A.O.means$co, col="black", pch=1)
arrows( N.A.O.means$month, N.A.O.means$co-(N.A.O.var$co)^{1/2},  N.A.O.means$month, N.A.O.means$co+(N.A.O.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, E.N.Am.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="E.N.Am", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, E.N.Am.mod.co.mean-(E.N.Am.mod.co.var)^{1/2},  1:12, E.N.Am.mod.co.mean+(E.N.Am.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(E.N.Am.means$month, E.N.Am.means$co, col="black", pch=1)
arrows( E.N.Am.means$month, E.N.Am.means$co-(E.N.Am.var$co)^{1/2},  E.N.Am.means$month, E.N.Am.means$co+(E.N.Am.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, Eur.Med.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="Eur.Med", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, Eur.Med.mod.co.mean-(Eur.Med.mod.co.var)^{1/2},  1:12, Eur.Med.mod.co.mean+(Eur.Med.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(Eur.Med.means$month, Eur.Med.means$co, col="black", pch=1)
arrows( Eur.Med.means$month, Eur.Med.means$co-(Eur.Med.var$co)^{1/2},  Eur.Med.means$month, Eur.Med.means$co+(Eur.Med.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, N.Euro.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="N.Euro", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, N.Euro.mod.co.mean-(N.Euro.mod.co.var)^{1/2},  1:12, N.Euro.mod.co.mean+(N.Euro.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(N.Euro.means$month, N.Euro.means$co, col="black", pch=1)
arrows( N.Euro.means$month, N.Euro.means$co-(N.Euro.var$co)^{1/2},  N.Euro.means$month, N.Euro.means$co+(N.Euro.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, N.Asia.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="N.Asia", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, N.Asia.mod.co.mean-(N.Asia.mod.co.var)^{1/2},  1:12, N.Asia.mod.co.mean+(N.Asia.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(N.Asia.means$month, N.Asia.means$co, col="black", pch=1)
arrows( N.Asia.means$month, N.Asia.means$co-(N.Asia.var$co)^{1/2},  N.Asia.means$month, N.Asia.means$co+(N.Asia.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, C.Asia.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="C.Asia", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, C.Asia.mod.co.mean-(C.Asia.mod.co.var)^{1/2},  1:12, C.Asia.mod.co.mean+(C.Asia.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(C.Asia.means$month, C.Asia.means$co, col="black", pch=1)
arrows( C.Asia.means$month, C.Asia.means$co-(C.Asia.var$co)^{1/2},  C.Asia.means$month, C.Asia.means$co+(C.Asia.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, C.S.Chi.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="C.S.Chi", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, C.S.Chi.mod.co.mean-(C.S.Chi.mod.co.var)^{1/2},  1:12, C.S.Chi.mod.co.mean+(C.S.Chi.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(C.S.Chi.means$month, C.S.Chi.means$co, col="black", pch=1)
arrows( C.S.Chi.means$month, C.S.Chi.means$co-(C.S.Chi.var$co)^{1/2},  C.S.Chi.means$month, C.S.Chi.means$co+(C.S.Chi.var$co)^{1/2}, length = 0.0, code =2, col="black" )

plot(1:12, S.Chi.S.mod.co.mean, ylim=c(20,180), type="o", lwd=1.6, lty=1,  xlab="",  ylab="CO (ppbv)", main="S.Chi.S", cex=0.7, xaxt="n", tck=0.03, col="red")
grid()
axis(side=1, 1:12, labels=monthNames, tick=TRUE, las=1, tck=0.03)
arrows( 1:12, S.Chi.S.mod.co.mean-(S.Chi.S.mod.co.var)^{1/2},  1:12, S.Chi.S.mod.co.mean+(S.Chi.S.mod.co.var)^{1/2}, length = 0.0, code =2, col="red" )
# add the obs
points(S.Chi.S.means$month, S.Chi.S.means$co, col="black", pch=1)
arrows( S.Chi.S.means$month, S.Chi.S.means$co-(S.Chi.S.var$co)^{1/2},  S.Chi.S.means$month, S.Chi.S.means$co+(S.Chi.S.var$co)^{1/2}, length = 0.0, code =2, col="black" )

# add a plot of the regions?
quilt.plot(data$PosLong, data$PosLat, data$Altitude, xlim=c(-180,180), ylim=c(-60,90), add.legend=FALSE )
world(add=T, col="black")
grid()
rect(xleft=-72,ybottom=-35,xright=-46,ytop=-23.5)
text(-60,-30,"M.L.S.Am", cex=1.0,col="black")

rect(xleft=-48,ybottom=-23.5,xright=-20,ytop=0)
text(-30,-15,"E.S.Am.", cex=1.0,col="black")

rect(xleft=-45,ybottom=0,xright=-10,ytop=24)
text(-35,15,"T.A.O", cex=1.0,col="black")

rect(xleft=-55,ybottom=24,xright=-10,ytop=60)
text(-20,45,"N.A.O", cex=1.0,col="black")

rect(xleft=-100,ybottom=25,xright=-55,ytop=60)
text(-70,45,"E.N.Am.", cex=1.0,col="black")

rect(xleft=-10,ybottom=30,xright=40,ytop=51)
text(25,45,"Eur.Med.", cex=1.0,col="black")

rect(xleft=-10,ybottom=51,xright=40,ytop=60)
text(25,55,"N.Euro.", cex=1.0,col="black")

rect(xleft=40,ybottom=50,xright=90,ytop=60)
text(65,55,"N.Asia.", cex=1.0,col="black")

rect(xleft=40,ybottom=30,xright=90,ytop=50)
text(70,40,"C.Asia", cex=1.0,col="black")

rect(xleft=90,ybottom=20,xright=113,ytop=40)
text(105,30,"C.S.Chi", cex=1.0,col="black")

rect(xleft=113,ybottom=14,xright=125,ytop=25)
text(120,20,"S.Chi.S", cex=1.0,col="black")


dev.off()
