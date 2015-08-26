# R script to read and subset the EPA CASTNET 
# data

# Alex Archibald, CAS, February 2012
# Zadie Stock, CAS, 21 May 2012

# source the obs data
source(paste(obs.dir, "EMEP/read_stations.R", sep=""))
source(paste(obs.dir, "EMEP/read_o3.R", sep=""))

# loop vars and constants
conv <- 1E9
j <- NULL ; i <- NULL ; k <- NULL

# merge the 133 stations
data <- merge(stations, emep.o3, by="code")

# split the stations based on the Latitude (use three bands)
n.data <- subset(data, Lat>50.0 & Lat<70.0) 
c.data <- subset(data, Lat>40.0 & Lat<50.0)
s.data <- subset(data, Lat>30.0 & Lat<40.0)

# Northern data
n.JanO3<-mean(n.data$jan,na.rm=TRUE)
n.FebO3<-mean(n.data$feb,na.rm=TRUE)
n.MarO3<-mean(n.data$mar,na.rm=TRUE)
n.AprO3<-mean(n.data$apr,na.rm=TRUE)
n.MayO3<-mean(n.data$may,na.rm=TRUE)
n.JunO3<-mean(n.data$jun,na.rm=TRUE)
n.JulO3<-mean(n.data$jul,na.rm=TRUE)
n.AugO3<-mean(n.data$aug,na.rm=TRUE)
n.SepO3<-mean(n.data$sep,na.rm=TRUE)
n.OctO3<-mean(n.data$oct,na.rm=TRUE)
n.NovO3<-mean(n.data$nov,na.rm=TRUE)
n.DecO3<-mean(n.data$dec,na.rm=TRUE)

n.sd.JanO3<-sd(n.data$jan,na.rm=TRUE)
n.sd.FebO3<-sd(n.data$feb,na.rm=TRUE)
n.sd.MarO3<-sd(n.data$mar,na.rm=TRUE)
n.sd.AprO3<-sd(n.data$apr,na.rm=TRUE)
n.sd.MayO3<-sd(n.data$may,na.rm=TRUE)
n.sd.JunO3<-sd(n.data$jun,na.rm=TRUE)
n.sd.JulO3<-sd(n.data$jul,na.rm=TRUE)
n.sd.AugO3<-sd(n.data$aug,na.rm=TRUE)
n.sd.SepO3<-sd(n.data$sep,na.rm=TRUE)
n.sd.OctO3<-sd(n.data$oct,na.rm=TRUE)
n.sd.NovO3<-sd(n.data$nov,na.rm=TRUE)
n.sd.DecO3<-sd(n.data$dec,na.rm=TRUE)

# combine the obs into one data frame
n.data.months<-abind(n.JanO3,n.FebO3,n.MarO3,n.AprO3,n.MayO3,n.JunO3,n.JulO3,n.AugO3,n.SepO3,n.OctO3,n.NovO3,n.DecO3)/2.0 # convert ug/m3 to ppbv mean
n.sd.data.months<-abind(n.sd.JanO3,n.sd.FebO3,n.sd.MarO3,n.sd.AprO3,n.sd.MayO3,n.sd.JunO3,n.sd.JulO3,n.sd.AugO3,n.sd.SepO3,n.sd.OctO3,n.sd.NovO3,n.sd.DecO3)/2.0 # convert ug/m3 to ppbv standard deviation

# Central data
c.JanO3<-mean(c.data$jan,na.rm=TRUE)
c.FebO3<-mean(c.data$feb,na.rm=TRUE)
c.MarO3<-mean(c.data$mar,na.rm=TRUE)
c.AprO3<-mean(c.data$apr,na.rm=TRUE)
c.MayO3<-mean(c.data$may,na.rm=TRUE)
c.JunO3<-mean(c.data$jun,na.rm=TRUE)
c.JulO3<-mean(c.data$jul,na.rm=TRUE)
c.AugO3<-mean(c.data$aug,na.rm=TRUE)
c.SepO3<-mean(c.data$sep,na.rm=TRUE)
c.OctO3<-mean(c.data$oct,na.rm=TRUE)
c.NovO3<-mean(c.data$nov,na.rm=TRUE)
c.DecO3<-mean(c.data$dec,na.rm=TRUE)

c.sd.JanO3<-sd(c.data$jan,na.rm=TRUE)
c.sd.FebO3<-sd(c.data$feb,na.rm=TRUE)
c.sd.MarO3<-sd(c.data$mar,na.rm=TRUE)
c.sd.AprO3<-sd(c.data$apr,na.rm=TRUE)
c.sd.MayO3<-sd(c.data$may,na.rm=TRUE)
c.sd.JunO3<-sd(c.data$jun,na.rm=TRUE)
c.sd.JulO3<-sd(c.data$jul,na.rm=TRUE)
c.sd.AugO3<-sd(c.data$aug,na.rm=TRUE)
c.sd.SepO3<-sd(c.data$sep,na.rm=TRUE)
c.sd.OctO3<-sd(c.data$oct,na.rm=TRUE)
c.sd.NovO3<-sd(c.data$nov,na.rm=TRUE)
c.sd.DecO3<-sd(c.data$dec,na.rm=TRUE)

# combine the obs into one data frame
c.data.months<-abind(c.JanO3,c.FebO3,c.MarO3,c.AprO3,c.MayO3,c.JunO3,c.JulO3,c.AugO3,c.SepO3,c.OctO3,c.NovO3,c.DecO3)/2.0 # convert ug/m3 to ppbv mean
c.sd.data.months<-abind(c.sd.JanO3,c.sd.FebO3,c.sd.MarO3,c.sd.AprO3,c.sd.MayO3,c.sd.JunO3,c.sd.JulO3,c.sd.AugO3,c.sd.SepO3,c.sd.OctO3,c.sd.NovO3,c.sd.DecO3)/2.0 # convert ug/m3 to ppbv standard deviation

# Southern data
s.JanO3<-mean(s.data$jan,na.rm=TRUE)
s.FebO3<-mean(s.data$feb,na.rm=TRUE)
s.MarO3<-mean(s.data$mar,na.rm=TRUE)
s.AprO3<-mean(s.data$apr,na.rm=TRUE)
s.MayO3<-mean(s.data$may,na.rm=TRUE)
s.JunO3<-mean(s.data$jun,na.rm=TRUE)
s.JulO3<-mean(s.data$jul,na.rm=TRUE)
s.AugO3<-mean(s.data$aug,na.rm=TRUE)
s.SepO3<-mean(s.data$sep,na.rm=TRUE)
s.OctO3<-mean(s.data$oct,na.rm=TRUE)
s.NovO3<-mean(s.data$nov,na.rm=TRUE)
s.DecO3<-mean(s.data$dec,na.rm=TRUE)

s.sd.JanO3<-sd(s.data$jan,na.rm=TRUE)
s.sd.FebO3<-sd(s.data$feb,na.rm=TRUE)
s.sd.MarO3<-sd(s.data$mar,na.rm=TRUE)
s.sd.AprO3<-sd(s.data$apr,na.rm=TRUE)
s.sd.MayO3<-sd(s.data$may,na.rm=TRUE)
s.sd.JunO3<-sd(s.data$jun,na.rm=TRUE)
s.sd.JulO3<-sd(s.data$jul,na.rm=TRUE)
s.sd.AugO3<-sd(s.data$aug,na.rm=TRUE)
s.sd.SepO3<-sd(s.data$sep,na.rm=TRUE)
s.sd.OctO3<-sd(s.data$oct,na.rm=TRUE)
s.sd.NovO3<-sd(s.data$nov,na.rm=TRUE)
s.sd.DecO3<-sd(s.data$dec,na.rm=TRUE)

# combine the obs into one data frame
s.data.months<-abind(s.JanO3,s.FebO3,s.MarO3,s.AprO3,s.MayO3,s.JunO3,s.JulO3,s.AugO3,s.SepO3,s.OctO3,s.NovO3,s.DecO3)/2.0 # convert ug/m3 to ppbv mean
s.sd.data.months<-abind(s.sd.JanO3,s.sd.FebO3,s.sd.MarO3,s.sd.AprO3,s.sd.MayO3,s.sd.JunO3,s.sd.JulO3,s.sd.AugO3,s.sd.SepO3,s.sd.OctO3,s.sd.NovO3,s.sd.DecO3)/2.0 # convert ug/m3 to ppbv standard deviation

# Determine the grid boxes to use
Lat <- data$lat
Lon <- data$lon
dlat <- (get.var.ncdf(nc1, "latitude")[2] - get.var.ncdf(nc1, "latitude")[1])
dlon <- (get.var.ncdf(nc1, "longitude")[2] - get.var.ncdf(nc1, "longitude")[1])
gLat = (round (  ((Lat +90)/dlat)  ))+1 
gLon <- ifelse ( Lon<0, (round( (Lon+360)/dlon))+1, (round (Lon/dlon) )+1  )
gLon <- ifelse ( gLon>length(get.var.ncdf(nc1, "longitude")),1,gLon) # wrap values around

# set the times (use short times for labels)
monthNames <- format(seq(as.POSIXct("2005-01-01"),by="1 months",length=12), "%b")
times <- c(1,2,3,4,5,6,7,8,9,10,11,12)

# select model data
mod <- array(0.0,dim=c(length(gLat),length(times))) # create empty array to fill with data
for (j in 1:length(times) ){
for (i in 1:length(gLat) ) {
mod[i,j] <- get.var.ncdf(nc1, o3.code, start=c(gLon[i],gLat[i],1,times[j]), count=c(1,1,1,1) )*(conv/mm.o3) } }

n.mod <- subset(mod, Lat>50 & Lat<70)
c.mod <- subset(mod, Lat>40 & Lat<50)
s.mod <- subset(mod, Lat>30 & Lat<40)

# Northern data
n.JanO3<-mean(n.mod[,1],na.rm=TRUE)
n.FebO3<-mean(n.mod[,2],na.rm=TRUE)
n.MarO3<-mean(n.mod[,3],na.rm=TRUE)
n.AprO3<-mean(n.mod[,4],na.rm=TRUE)
n.MayO3<-mean(n.mod[,5],na.rm=TRUE)
n.JunO3<-mean(n.mod[,6],na.rm=TRUE)
n.JulO3<-mean(n.mod[,7],na.rm=TRUE)
n.AugO3<-mean(n.mod[,8],na.rm=TRUE)
n.SepO3<-mean(n.mod[,9],na.rm=TRUE)
n.OctO3<-mean(n.mod[,10],na.rm=TRUE)
n.NovO3<-mean(n.mod[,11],na.rm=TRUE)
n.DecO3<-mean(n.mod[,12],na.rm=TRUE)

n.sd.JanO3<-sd(n.mod[,1],na.rm=TRUE)
n.sd.FebO3<-sd(n.mod[,2],na.rm=TRUE)
n.sd.MarO3<-sd(n.mod[,3],na.rm=TRUE)
n.sd.AprO3<-sd(n.mod[,4],na.rm=TRUE)
n.sd.MayO3<-sd(n.mod[,5],na.rm=TRUE)
n.sd.JunO3<-sd(n.mod[,6],na.rm=TRUE)
n.sd.JulO3<-sd(n.mod[,7],na.rm=TRUE)
n.sd.AugO3<-sd(n.mod[,8],na.rm=TRUE)
n.sd.SepO3<-sd(n.mod[,9],na.rm=TRUE)
n.sd.OctO3<-sd(n.mod[,10],na.rm=TRUE)
n.sd.NovO3<-sd(n.mod[,11],na.rm=TRUE)
n.sd.DecO3<-sd(n.mod[,12],na.rm=TRUE)

n.mod.months<-abind(n.JanO3,n.FebO3,n.MarO3,n.AprO3,n.MayO3,n.JunO3,n.JulO3,n.AugO3,n.SepO3,n.OctO3,n.NovO3,n.DecO3) # means
n.sd.mod.months<-abind(n.sd.JanO3,n.sd.FebO3,n.sd.MarO3,n.sd.AprO3,n.sd.MayO3,n.sd.JunO3,n.sd.JulO3,n.sd.AugO3,n.sd.SepO3,n.sd.OctO3,n.sd.NovO3,n.sd.DecO3) # means

# Central data
c.JanO3<-mean(c.mod[,1],na.rm=TRUE)
c.FebO3<-mean(c.mod[,2],na.rm=TRUE)
c.MarO3<-mean(c.mod[,3],na.rm=TRUE)
c.AprO3<-mean(c.mod[,4],na.rm=TRUE)
c.MayO3<-mean(c.mod[,5],na.rm=TRUE)
c.JunO3<-mean(c.mod[,6],na.rm=TRUE)
c.JulO3<-mean(c.mod[,7],na.rm=TRUE)
c.AugO3<-mean(c.mod[,8],na.rm=TRUE)
c.SepO3<-mean(c.mod[,9],na.rm=TRUE)
c.OctO3<-mean(c.mod[,10],na.rm=TRUE)
c.NovO3<-mean(c.mod[,11],na.rm=TRUE)
c.DecO3<-mean(c.mod[,12],na.rm=TRUE)

c.sd.JanO3<-sd(c.mod[,1],na.rm=TRUE)
c.sd.FebO3<-sd(c.mod[,2],na.rm=TRUE)
c.sd.MarO3<-sd(c.mod[,3],na.rm=TRUE)
c.sd.AprO3<-sd(c.mod[,4],na.rm=TRUE)
c.sd.MayO3<-sd(c.mod[,5],na.rm=TRUE)
c.sd.JunO3<-sd(c.mod[,6],na.rm=TRUE)
c.sd.JulO3<-sd(c.mod[,7],na.rm=TRUE)
c.sd.AugO3<-sd(c.mod[,8],na.rm=TRUE)
c.sd.SepO3<-sd(c.mod[,9],na.rm=TRUE)
c.sd.OctO3<-sd(c.mod[,10],na.rm=TRUE)
c.sd.NovO3<-sd(c.mod[,11],na.rm=TRUE)
c.sd.DecO3<-sd(c.mod[,12],na.rm=TRUE)

c.mod.months<-abind(c.JanO3,c.FebO3,c.MarO3,c.AprO3,c.MayO3,c.JunO3,c.JulO3,c.AugO3,c.SepO3,c.OctO3,c.NovO3,c.DecO3) # means
c.sd.mod.months<-abind(c.sd.JanO3,c.sd.FebO3,c.sd.MarO3,c.sd.AprO3,c.sd.MayO3,c.sd.JunO3,c.sd.JulO3,c.sd.AugO3,c.sd.SepO3,c.sd.OctO3,c.sd.NovO3,c.sd.DecO3) # means

# Southern data
s.JanO3<-mean(s.mod[,1],na.rm=TRUE)
s.FebO3<-mean(s.mod[,2],na.rm=TRUE)
s.MarO3<-mean(s.mod[,3],na.rm=TRUE)
s.AprO3<-mean(s.mod[,4],na.rm=TRUE)
s.MayO3<-mean(s.mod[,5],na.rm=TRUE)
s.JunO3<-mean(s.mod[,6],na.rm=TRUE)
s.JulO3<-mean(s.mod[,7],na.rm=TRUE)
s.AugO3<-mean(s.mod[,8],na.rm=TRUE)
s.SepO3<-mean(s.mod[,9],na.rm=TRUE)
s.OctO3<-mean(s.mod[,10],na.rm=TRUE)
s.NovO3<-mean(s.mod[,11],na.rm=TRUE)
s.DecO3<-mean(s.mod[,12],na.rm=TRUE)

s.sd.JanO3<-sd(s.mod[,1],na.rm=TRUE)
s.sd.FebO3<-sd(s.mod[,2],na.rm=TRUE)
s.sd.MarO3<-sd(s.mod[,3],na.rm=TRUE)
s.sd.AprO3<-sd(s.mod[,4],na.rm=TRUE)
s.sd.MayO3<-sd(s.mod[,5],na.rm=TRUE)
s.sd.JunO3<-sd(s.mod[,6],na.rm=TRUE)
s.sd.JulO3<-sd(s.mod[,7],na.rm=TRUE)
s.sd.AugO3<-sd(s.mod[,8],na.rm=TRUE)
s.sd.SepO3<-sd(s.mod[,9],na.rm=TRUE)
s.sd.OctO3<-sd(s.mod[,10],na.rm=TRUE)
s.sd.NovO3<-sd(s.mod[,11],na.rm=TRUE)
s.sd.DecO3<-sd(s.mod[,12],na.rm=TRUE)

s.mod.months<-abind(s.JanO3,s.FebO3,s.MarO3,s.AprO3,s.MayO3,s.JunO3,s.JulO3,s.AugO3,s.SepO3,s.OctO3,s.NovO3,s.DecO3) # means
s.sd.mod.months<-abind(s.sd.JanO3,s.sd.FebO3,s.sd.MarO3,s.sd.AprO3,s.sd.MayO3,s.sd.JunO3,s.sd.JulO3,s.sd.AugO3,s.sd.SepO3,s.sd.OctO3,s.sd.NovO3,s.sd.DecO3) # means

# calc stats
# correlation
cor.r.n <- cor(n.data.months,n.mod.months,use="pairwise.complete.obs",method="pearson")
cor.r.c <- cor(c.data.months,c.mod.months,use="pairwise.complete.obs",method="pearson")
cor.r.s <- cor(s.data.months,s.mod.months,use="pairwise.complete.obs",method="pearson")

#Mean bias error in %
M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=n.mod.months[k]-(n.data.months[k]) }
MBE.n=(sum(M)/12)/(sum(n.data.months)/12)*100

M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=c.mod.months[k]-(c.data.months[k]) }
MBE.c=(sum(M)/12)/(sum(c.data.months)/12)*100

M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=s.mod.months[k]-(s.data.months[k]) }
MBE.s=(sum(M)/12)/(sum(s.data.months)/12)*100

# ###############################################################################################
pdf(file=paste(out.dir, mod1.name, "_EMEP_O3_comparison.pdf", sep=""),width=8,height=7,paper="special",
onefile=FALSE,pointsize=14)

  par (fig=c(0,1,0,1), # Figure region in the device display region (x1,x2,y1,y2)
       omi=c(0,0,0.3,0), # global margins in inches (bottom, left, top, right)
       mai=c(0.4,0.6,0.35,0.1)) # subplot margins in inches (bottom, left, top, right)
  layout(matrix(1:6, 3, 2, byrow = TRUE))

#par(mfrow=c(3,2))

plot(n.data.months,col="Black",xlab="", lwd=4, ylab="Ozone (ppbv)",type="o",ylim=c(0,60), xaxt="n", main="North Europe (50-70N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((n.data.months)-(n.sd.data.months)),  1:12, ((n.data.months)+(n.sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,n.mod.months,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((n.mod.months)-(n.sd.mod.months)),  1:12, ((n.mod.months)+(n.sd.mod.months)), length = 0.0, code =2, col="red" )
legend("topleft",c("EMEP (2005)",mod1.name),col=c("black","red"),lty=c(1,1),lwd=4,bty="n")
legend("bottomright",c("# sites = 66"),box.lty=0,cex=0.9)
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.r.n)," MBE = ", sprintf("%1.3g", MBE.n), "%", sep="")), cex=0.9)
grid()

barplot( (n.mod.months - (n.data.months)), col="red", names.arg=monthNames, las=1, ylim=c(-20,20), xlab="", ylab=expression( paste(Delta, " Ozone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(c.data.months,col="Black",xlab="", lwd=4, ylab="Ozone (ppbv)",type="o",ylim=c(0,60), xaxt="n", main="Central Europe (40-50N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((c.data.months)-(c.sd.data.months)),  1:12, ((c.data.months)+(c.sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,c.mod.months,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((c.mod.months)-(c.sd.mod.months)),  1:12, ((c.mod.months)+(c.sd.mod.months)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 57"),box.lty=0,cex=0.9)
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.r.c)," MBE = ", sprintf("%1.3g", MBE.c), "%", sep="")), cex=0.9)
grid()

barplot( (c.mod.months - (c.data.months)), col="red", names.arg=monthNames, las=1, ylim=c(-20,20), xlab="", ylab=expression( paste(Delta, " Ozone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

plot(s.data.months,col="Black",xlab="", lwd=4, ylab="Ozone (ppbv)",type="o",ylim=c(0,60), xaxt="n", main="South Europe (30-40N), (-10-33E)",cex.main=0.9)
arrows( 1:12, ((s.data.months)-(s.sd.data.months)),  1:12, ((s.data.months)+(s.sd.data.months)), length = 0.0, code =2 )
axis(side=1, 1:12,   labels=monthNames, tick=TRUE, las=1)
lines(times,s.mod.months,type="o",col="red",lwd=4,lty=1)
arrows( 1:12, ((s.mod.months)-(s.sd.mod.months)),  1:12, ((s.mod.months)+(s.sd.mod.months)), length = 0.0, code =2, col="red" )
legend("bottomright",c("# sites = 9"),box.lty=0,cex=0.9)
text(6,10, c(paste("r = ",sprintf("%1.3g", cor.r.s)," MBE = ", sprintf("%1.3g", MBE.s), "%", sep="")), cex=0.9)
grid()

barplot( (s.mod.months - (s.data.months)), col="red", names.arg=monthNames, las=1, ylim=c(-20,20), xlab="", ylab=expression( paste(Delta, " Ozone (ppbv)", sep="") ), axis.lty=1 )
abline(h=0)
box()
grid()

dev.off()
