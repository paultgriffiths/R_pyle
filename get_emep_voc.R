# R script to be used with EMEP voc analysis.
# Takes as input a data frame of single voc 
# and an input voc.code to extract  

# split the stations based on the Latitude (use two bands)
n.data <- subset(data, Lat>lat.c & Lat<lat.n)
c.data <- subset(data, Lat>lat.s & Lat<lat.c)

n.sites <- length(unique(n.data$code))
c.sites <- length(unique(c.data$code))

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
n.data.months<-abind(n.JanO3,n.FebO3,n.MarO3,n.AprO3,n.MayO3,n.JunO3,n.JulO3,n.AugO3,n.SepO3,n.OctO3,n.NovO3,n.DecO3)/cal.fac # mean
n.sd.data.months<-abind(n.sd.JanO3,n.sd.FebO3,n.sd.MarO3,n.sd.AprO3,n.sd.MayO3,n.sd.JunO3,n.sd.JulO3,n.sd.AugO3,n.sd.SepO3,n.sd.OctO3,n.sd.NovO3,n.sd.DecO3)/cal.fac # standard deviation

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
c.data.months<-abind(c.JanO3,c.FebO3,c.MarO3,c.AprO3,c.MayO3,c.JunO3,c.JulO3,c.AugO3,c.SepO3,c.OctO3,c.NovO3,c.DecO3)/cal.fac # mean
c.sd.data.months<-abind(c.sd.JanO3,c.sd.FebO3,c.sd.MarO3,c.sd.AprO3,c.sd.MayO3,c.sd.JunO3,c.sd.JulO3,c.sd.AugO3,c.sd.SepO3,c.sd.OctO3,c.sd.NovO3,c.sd.DecO3)/cal.fac # standard deviation

# Determine the grid boxes to use
Lat <- data$lat
Lon <- data$lon
dlat <- (get.var.ncdf(nc1, "latitude")[2] - get.var.ncdf(nc1, "latitude")[1])
dlon <- (get.var.ncdf(nc1, "longitude")[2] - get.var.ncdf(nc1, "longitude")[1])
gLat = (round (  ((Lat +90)/dlat)  ))+1 
gLon <- ifelse ( Lon<0, (round( (Lon+360)/dlon))+1, (round (Lon/dlon) )+1  )
gLon <- ifelse ( gLon>length(get.var.ncdf(nc1, "longitude")),1,gLon) # wrap values around

# select model data
mod <- array(0.0,dim=c(length(gLat),length(times))) # create empty array to fill with data
for (j in 1:length(times) ){
for (i in 1:length(gLat) ) {
mod[i,j] <- get.var.ncdf(nc1, voc.code, start=c(gLon[i],gLat[i],1,times[j]), count=c(1,1,1,1) )*(conv/voc.mm) } }

n.mod <- subset(mod, Lat>lat.c & Lat<lat.n)
c.mod <- subset(mod, Lat>lat.s & Lat<lat.c)

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

# calc stats
# correlation
cor.r.n <- cor(n.data.months,n.mod.months,use="pairwise.complete.obs",method="pearson")
cor.r.c <- cor(c.data.months,c.mod.months,use="pairwise.complete.obs",method="pearson")

#Mean bias error in %
M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=n.mod.months[k]-(n.data.months[k]) }
MBE.n=(sum(M)/12)/(sum(n.data.months)/12)*100

M<-array(0,dim=c(12))
for (k in 1:length(times)){
M[k]=c.mod.months[k]-(c.data.months[k]) }
MBE.c=(sum(M)/12)/(sum(c.data.months)/12)*100

