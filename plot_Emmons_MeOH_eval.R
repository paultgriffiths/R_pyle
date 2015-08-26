# R scrip to plot aircraft methanol vs model

# Can be used as part of UKCA evaluation

# Alex Archibald, CAS, July 2012

# exract the physical dimensions from the two files 
lon  <- get.var.ncdf(nc1, "longitude")
lat  <- get.var.ncdf(nc1, "latitude")
hgt  <- get.var.ncdf(nc1, "hybrid_ht")
time <- get.var.ncdf(nc1, "t")

# determine the grid spacing
xmax <- length(lon)
ymax <- length(lat)

dlon <- lon[2] - lon[1]
dlat <- lat[2] - lat[1]

# height in km's to pass to plots
hgt <- hgt/1000.
hgt.10 <- which(hgt>=10.0)[1]
# ##################################################################################
#  
# The plots compare the model runs with statistical 
# data compiled from aircraft campaigns
source(paste(script.dir, "read_campaign_dat.R", sep=""))

conv  <- 1E9 # units in ppbv or ppt

data <- "intex.na.ec"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.na.ec.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.na.ec.mod.m1 <- apply(intex.na.ec.mod.1,c(3),quantile)

data <- "intex.na.ct"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.na.ct.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.na.ct.mod.m1 <- apply(intex.na.ct.mod.1,c(3),quantile)

data <- "intex.na.ne"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.na.ne.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.na.ne.mod.m1 <- apply(intex.na.ne.mod.1,c(3),quantile)

data <- "intex.na.wc"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.na.wc.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.na.wc.mod.m1 <- apply(intex.na.wc.mod.1,c(3),quantile)

data <- "op3"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
op3.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
op3.mod.m1 <- apply(op3.mod.1,c(3),quantile)

data <- "gabriel"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
gab.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
gab.mod.m1 <- apply(gab.mod.1,c(3),quantile)

data <- "intex.b.ca"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.b.ca.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.b.ca.mod.m1 <- apply(intex.b.ca.mod.1,c(3),quantile)

data <- "intex.b.goa"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.b.goa.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.b.goa.mod.m1 <- apply(intex.b.goa.mod.1,c(3),quantile)

data <- "intex.b.hi"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.b.hi.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.b.hi.mod.m1 <- apply(intex.b.hi.mod.1,c(3),quantile)

data <- "intex.b.np"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
intex.b.np.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
intex.b.np.mod.m1 <- apply(intex.b.np.mod.1,c(3),quantile)

data <- "trace.p.c"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
trace.p.c.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
trace.p.c.mod.m1 <- apply(trace.p.c.mod.1,c(3),quantile)

data <- "trace.p.j"
source(paste(script.dir, "extract_emmons_coords.R", sep=""))
trace.p.j.mod.1 <- get.var.ncdf(nc1,meoh.code,start=c(lon1,lat1,1,mon),count=c(d.lon1,d.lat1,60,d.mon))*(conv/mm.meoh)
trace.p.j.mod.m1 <- apply(trace.p.j.mod.1,c(3),quantile)


# ################## read obs ##################################################### #
intex.na.ec.data <- read.table(paste(obs.dir, "INTEX-NA/INTEX-NA_EC_MeOH.stat", sep=""))
# set the data to ppbv
intex.na.ec.data$V5 <- intex.na.ec.data$V5*1E-3
intex.na.ec.data$V6 <- intex.na.ec.data$V6*1E-3
intex.na.ec.dat.sd1 = intex.na.ec.data$V5 + intex.na.ec.data$V6
intex.na.ec.dat.sd2 = intex.na.ec.data$V5 - intex.na.ec.data$V6

intex.na.ct.data <- read.table(paste(obs.dir, "INTEX-NA/INTEX-NA_CT_MeOH.stat", sep=""))
# set the data to ppbv
intex.na.ct.data$V5 <- intex.na.ct.data$V5*1E-3
intex.na.ct.data$V6 <- intex.na.ct.data$V6*1E-3
intex.na.ct.dat.sd1 = intex.na.ct.data$V5 + intex.na.ct.data$V6
intex.na.ct.dat.sd2 = intex.na.ct.data$V5 - intex.na.ct.data$V6

intex.na.ne.data <- read.table(paste(obs.dir, "INTEX-NA/INTEX-NA_NE_MeOH.stat", sep=""))
# set the data to ppbv
intex.na.ne.data$V5 <- intex.na.ne.data$V5*1E-3
intex.na.ne.data$V6 <- intex.na.ne.data$V6*1E-3
intex.na.ne.dat.sd1 = intex.na.ne.data$V5 + intex.na.ne.data$V6
intex.na.ne.dat.sd2 = intex.na.ne.data$V5 - intex.na.ne.data$V6

intex.na.wc.data <- read.table(paste(obs.dir, "INTEX-NA/INTEX-NA_WC_MeOH.stat", sep=""))
# set the data to ppbv
intex.na.wc.data$V5 <- intex.na.wc.data$V5*1E-3
intex.na.wc.data$V6 <- intex.na.wc.data$V6*1E-3
intex.na.wc.dat.sd1 = intex.na.wc.data$V5 + intex.na.wc.data$V6
intex.na.wc.dat.sd2 = intex.na.wc.data$V5 - intex.na.wc.data$V6

op3.data <- read.csv(paste(obs.dir, "OP3/OP3_methanol.stat", sep=""), header = F, skip=1)
op3.data$V5 <- op3.data$V5*1E-3
op3.data$V6 <- op3.data$V6*1E-3
op3.dat.sd1 = op3.data$V5 + op3.data$V6
op3.dat.sd2 = op3.data$V5 - op3.data$V6

gab.data <- read.table(paste(obs.dir, "GABRIEL/GABRIEL_data_archibald/Merge/GABRIEL_meoh.stat", sep=""))
gab.dat.sd1 = gab.data$V5 + gab.data$V6
gab.dat.sd2 = gab.data$V5 - gab.data$V6

intex.b.ca.data <- read.csv(paste(obs.dir, "INTEX-B/INTEX-B_CA_methanol.stat", sep=""), header = F, skip=1)
# set the data to ppbv
intex.b.ca.data$V5 <- intex.b.ca.data$V5*1E-3
intex.b.ca.data$V6 <- intex.b.ca.data$V6*1E-3
intex.b.ca.dat.sd1 = intex.b.ca.data$V5 + intex.b.ca.data$V6
intex.b.ca.dat.sd2 = intex.b.ca.data$V5 - intex.b.ca.data$V6

intex.b.goa.data <- read.csv(paste(obs.dir, "INTEX-B/INTEX-B_GOA_methanol.stat", sep=""), header = F, skip=1)
# set the data to ppbv
intex.b.goa.data$V5 <- intex.b.goa.data$V5*1E-3
intex.b.goa.data$V6 <- intex.b.goa.data$V6*1E-3
intex.b.goa.dat.sd1 = intex.b.goa.data$V5 + intex.b.goa.data$V6
intex.b.goa.dat.sd2 = intex.b.goa.data$V5 - intex.b.goa.data$V6

intex.b.hi.data <- read.csv(paste(obs.dir, "INTEX-B/INTEX-B_HI_methanol.stat", sep=""), header = F, skip=1)
# set the data to ppbv
intex.b.hi.data$V5 <- intex.b.hi.data$V5*1E-3
intex.b.hi.data$V6 <- intex.b.hi.data$V6*1E-3
intex.b.hi.dat.sd1 = intex.b.hi.data$V5 + intex.b.hi.data$V6
intex.b.hi.dat.sd2 = intex.b.hi.data$V5 - intex.b.hi.data$V6

intex.b.np.data <- read.csv(paste(obs.dir, "INTEX-B/INTEX-B_NP_methanol.stat", sep=""), header = F, skip=1)
# set the data to ppbv
intex.b.np.data$V5 <- intex.b.np.data$V5*1E-3
intex.b.np.data$V6 <- intex.b.np.data$V6*1E-3
intex.b.np.dat.sd1 = intex.b.np.data$V5 + intex.b.np.data$V6
intex.b.np.dat.sd2 = intex.b.np.data$V5 - intex.b.np.data$V6

trace.p.c.data <- read.table(paste(obs.dir, "emmons_data/regional/TRACE-P/TRACE-P_DC8_methanol_China.stat", sep=""))
# set the data to ppbv
trace.p.c.data$V5 <- trace.p.c.data$V5*1E-3
trace.p.c.data$V6 <- trace.p.c.data$V6*1E-3
trace.p.c.dat.sd1 = trace.p.c.data$V5 + trace.p.c.data$V6
trace.p.c.dat.sd2 = trace.p.c.data$V5 - trace.p.c.data$V6

trace.p.j.data <- read.table(paste(obs.dir, "emmons_data/regional/TRACE-P/TRACE-P_DC8_methanol_Japan.stat", sep=""))
# set the data to ppbv
trace.p.j.data$V5 <- trace.p.j.data$V5*1E-3
trace.p.j.data$V6 <- trace.p.j.data$V6*1E-3
trace.p.j.dat.sd1 = trace.p.j.data$V5 + trace.p.j.data$V6
trace.p.j.dat.sd2 = trace.p.j.data$V5 - trace.p.j.data$V6


# ################ Plot data ###################################################### #
# output
pdf(file=paste(out.dir,mod1.name,"_vertical_MeOH_comparison.pdf",sep=""),width=16,height=24,pointsize=24)
#
par(mfrow=c(4,3))
par(oma=c(0,0,1,0)) 
par(mgp = c(2, 1, 0))

plot(intex.na.ec.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.na.ec",1]), format(obs.dat[obs.dat$short.name=="intex.na.ec",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.na.ec",5]), "-", (obs.dat[obs.dat$short.name=="intex.na.ec",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.na.ec",7]), "-", (obs.dat[obs.dat$short.name=="intex.na.ec",8]) ) ,
xlim=c(0,5))
# add obs
arrows( (intex.na.ec.data$V5-intex.na.ec.data$V6), intex.na.ec.data$V1, (intex.na.ec.data$V5+intex.na.ec.data$V6), intex.na.ec.data$V1, length = 0.0, code =2 )
polygon(c(intex.na.ec.dat.sd1, rev(intex.na.ec.dat.sd2)), c(intex.na.ec.data$V1, rev(intex.na.ec.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.na.ec.data$V5, intex.na.ec.data$V1, lwd=1.5)
# add model1
polygon(c(intex.na.ec.mod.m1[4,1:hgt.10], rev(intex.na.ec.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.na.ec.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.na.ec.data$V1+0.1, intex.na.ec.data$V2, las=2)
grid()

legend("topright", c(mod1.name), lwd=2, col=c("red2"), bty="n", cex=0.85 )
title(main="\nEmmons MeOH comparison",outer=T, col.main="red")

plot(intex.na.ct.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.na.ct",1]), format(obs.dat[obs.dat$short.name=="intex.na.ct",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.na.ct",5]), "-", (obs.dat[obs.dat$short.name=="intex.na.ct",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.na.ct",7]), "-", (obs.dat[obs.dat$short.name=="intex.na.ct",8]) ) ,
xlim=c(0,5))
# add obs
arrows( (intex.na.ct.data$V5-intex.na.ct.data$V6), intex.na.ct.data$V1, (intex.na.ct.data$V5+intex.na.ct.data$V6), intex.na.ct.data$V1, length = 0.0, code =2 )
polygon(c(intex.na.ct.dat.sd1, rev(intex.na.ct.dat.sd2)), c(intex.na.ct.data$V1, rev(intex.na.ct.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.na.ct.data$V5, intex.na.ct.data$V1, lwd=1.5)
# add model1
polygon(c(intex.na.ct.mod.m1[4,1:hgt.10], rev(intex.na.ct.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.na.ct.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.na.ct.data$V1+0.1, intex.na.ct.data$V2, las=2)
grid()

plot(intex.na.ne.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.na.ne",1]), format(obs.dat[obs.dat$short.name=="intex.na.ne",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.na.ne",5]), "-", (obs.dat[obs.dat$short.name=="intex.na.ne",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.na.ne",7]), "-", (obs.dat[obs.dat$short.name=="intex.na.ne",8]) ) ,
xlim=c(0,5))
# add obs
arrows( (intex.na.ne.data$V5-intex.na.ne.data$V6), intex.na.ne.data$V1, (intex.na.ne.data$V5+intex.na.ne.data$V6), intex.na.ne.data$V1, length = 0.0, code =2 )
polygon(c(intex.na.ne.dat.sd1, rev(intex.na.ne.dat.sd2)), c(intex.na.ne.data$V1, rev(intex.na.ne.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.na.ne.data$V5, intex.na.ne.data$V1, lwd=1.5)
# add model1
polygon(c(intex.na.ne.mod.m1[4,1:hgt.10], rev(intex.na.ne.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.na.ne.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.na.ne.data$V1+0.1, intex.na.ne.data$V2, las=2)
grid()

plot(intex.na.wc.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.na.wc",1]), format(obs.dat[obs.dat$short.name=="intex.na.wc",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.na.wc",5]), "-", (obs.dat[obs.dat$short.name=="intex.na.wc",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.na.wc",7]), "-", (obs.dat[obs.dat$short.name=="intex.na.wc",8]) ) ,
xlim=c(0,4))
# add obs
arrows( (intex.na.wc.data$V5-intex.na.wc.data$V6), intex.na.wc.data$V1, (intex.na.wc.data$V5+intex.na.wc.data$V6), intex.na.wc.data$V1, length = 0.0, code =2 )
polygon(c(intex.na.wc.dat.sd1, rev(intex.na.wc.dat.sd2)), c(intex.na.wc.data$V1, rev(intex.na.wc.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.na.wc.data$V5, intex.na.wc.data$V1, lwd=1.5)
# add model1
polygon(c(intex.na.wc.mod.m1[4,1:hgt.10], rev(intex.na.wc.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.na.wc.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.na.wc.data$V1+0.1, intex.na.wc.data$V2, las=2)
grid()

plot(op3.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="op3",1]), format(obs.dat[obs.dat$short.name=="op3",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="op3",5]), "-", (obs.dat[obs.dat$short.name=="op3",6]),
"Lon", (obs.dat[obs.dat$short.name=="op3",7]), "-", (obs.dat[obs.dat$short.name=="op3",8]) ) ,
xlim=c(0,7))
# add obs
arrows( (op3.data$V5-op3.data$V6), op3.data$V1, (op3.data$V5+op3.data$V6), op3.data$V1, length = 0.0, code =2 )
polygon(c(op3.dat.sd1, rev(op3.dat.sd2)), c(op3.data$V1, rev(op3.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(op3.data$V5, op3.data$V1, lwd=1.5)
# add model1
polygon(c(op3.mod.m1[4,1:hgt.10], rev(op3.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(op3.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,op3.data$V1+0.1, op3.data$V2, las=2)
grid()

plot(gab.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="gabriel",1]), format(obs.dat[obs.dat$short.name=="gabriel",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="gabriel",5]), "-", (obs.dat[obs.dat$short.name=="gabriel",6]),
"Lon", (obs.dat[obs.dat$short.name=="gabriel",7]), "-", (obs.dat[obs.dat$short.name=="gabriel",8]) ) ,
xlim=c(0,7))
# add obs
arrows( (gab.data$V5-gab.data$V6), gab.data$V1, (gab.data$V5+gab.data$V6), gab.data$V1, length = 0.0, code =2 )
polygon(c(gab.dat.sd1, rev(gab.dat.sd2)), c(gab.data$V1, rev(gab.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(gab.data$V5, gab.data$V1, lwd=1.5)
# add model1
polygon(c(gab.mod.m1[4,1:hgt.10], rev(gab.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(gab.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,gab.data$V1+0.1, gab.data$V2, las=2)
grid()

plot(intex.b.ca.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.b.ca",1]), format(obs.dat[obs.dat$short.name=="intex.b.ca",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.b.ca",5]), "-", (obs.dat[obs.dat$short.name=="intex.b.ca",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.b.ca",7]), "-", (obs.dat[obs.dat$short.name=="intex.b.ca",8]) ) ,
xlim=c(0,5))
# add obs
arrows( (intex.b.ca.data$V5-intex.b.ca.data$V6), intex.b.ca.data$V1, (intex.b.ca.data$V5+intex.b.ca.data$V6), intex.b.ca.data$V1, length = 0.0, code =2 )
polygon(c(intex.b.ca.dat.sd1, rev(intex.b.ca.dat.sd2)), c(intex.b.ca.data$V1, rev(intex.b.ca.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.b.ca.data$V5, intex.b.ca.data$V1, lwd=1.5)
# add model1
polygon(c(intex.b.ca.mod.m1[4,1:hgt.10], rev(intex.b.ca.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.b.ca.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.b.ca.data$V1+0.1, intex.b.ca.data$V2, las=2)
grid()

plot(intex.b.goa.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.b.goa",1]), format(obs.dat[obs.dat$short.name=="intex.b.goa",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.b.goa",5]), "-", (obs.dat[obs.dat$short.name=="intex.b.goa",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.b.goa",7]), "-", (obs.dat[obs.dat$short.name=="intex.b.goa",8]) ) ,
xlim=c(0,3))
# add obs
arrows( (intex.b.goa.data$V5-intex.b.goa.data$V6), intex.b.goa.data$V1, (intex.b.goa.data$V5+intex.b.goa.data$V6), intex.b.goa.data$V1, length = 0.0, code =2 )
polygon(c(intex.b.goa.dat.sd1, rev(intex.b.goa.dat.sd2)), c(intex.b.goa.data$V1, rev(intex.b.goa.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.b.goa.data$V5, intex.b.goa.data$V1, lwd=1.5)
# add model1
polygon(c(intex.b.goa.mod.m1[4,1:hgt.10], rev(intex.b.goa.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.b.goa.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.b.goa.data$V1+0.1, intex.b.goa.data$V2, las=2)
grid()

plot(intex.b.hi.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.b.hi",1]), format(obs.dat[obs.dat$short.name=="intex.b.hi",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.b.hi",5]), "-", (obs.dat[obs.dat$short.name=="intex.b.hi",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.b.hi",7]), "-", (obs.dat[obs.dat$short.name=="intex.b.hi",8]) ) ,
xlim=c(0,3))
# add obs
arrows( (intex.b.hi.data$V5-intex.b.hi.data$V6), intex.b.hi.data$V1, (intex.b.hi.data$V5+intex.b.hi.data$V6), intex.b.hi.data$V1, length = 0.0, code =2 )
polygon(c(intex.b.hi.dat.sd1, rev(intex.b.hi.dat.sd2)), c(intex.b.hi.data$V1, rev(intex.b.hi.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.b.hi.data$V5, intex.b.hi.data$V1, lwd=1.5)
# add model1
polygon(c(intex.b.hi.mod.m1[4,1:hgt.10], rev(intex.b.hi.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.b.hi.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.b.hi.data$V1+0.1, intex.b.hi.data$V2, las=2)
grid()

plot(intex.b.np.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="intex.b.np",1]), format(obs.dat[obs.dat$short.name=="intex.b.np",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="intex.b.np",5]), "-", (obs.dat[obs.dat$short.name=="intex.b.np",6]),
"Lon", (obs.dat[obs.dat$short.name=="intex.b.np",7]), "-", (obs.dat[obs.dat$short.name=="intex.b.np",8]) ) ,
xlim=c(0,3))
# add obs
arrows( (intex.b.np.data$V5-intex.b.np.data$V6), intex.b.np.data$V1, (intex.b.np.data$V5+intex.b.np.data$V6), intex.b.np.data$V1, length = 0.0, code =2 )
polygon(c(intex.b.np.dat.sd1, rev(intex.b.np.dat.sd2)), c(intex.b.np.data$V1, rev(intex.b.np.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(intex.b.np.data$V5, intex.b.np.data$V1, lwd=1.5)
# add model1
polygon(c(intex.b.np.mod.m1[4,1:hgt.10], rev(intex.b.np.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(intex.b.np.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,intex.b.np.data$V1+0.1, intex.b.np.data$V2, las=2)
grid()

plot(trace.p.c.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="trace.p.c",1]), format(obs.dat[obs.dat$short.name=="trace.p.c",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="trace.p.c",5]), "-", (obs.dat[obs.dat$short.name=="trace.p.c",6]),
"Lon", (obs.dat[obs.dat$short.name=="trace.p.c",7]), "-", (obs.dat[obs.dat$short.name=="trace.p.c",8]) ) ,
xlim=c(0,5))
# add obs
arrows( (trace.p.c.data$V5-trace.p.c.data$V6), trace.p.c.data$V1, (trace.p.c.data$V5+trace.p.c.data$V6), trace.p.c.data$V1, length = 0.0, code =2 )
polygon(c(trace.p.c.dat.sd1, rev(trace.p.c.dat.sd2)), c(trace.p.c.data$V1, rev(trace.p.c.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(trace.p.c.data$V5, trace.p.c.data$V1, lwd=1.5)
# add model1
polygon(c(trace.p.c.mod.m1[4,1:hgt.10], rev(trace.p.c.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(trace.p.c.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,trace.p.c.data$V1+0.1, trace.p.c.data$V2, las=2)
grid()

plot(trace.p.j.mod.m1[3,1:hgt.10], hgt[1:hgt.10], type = "o", pch=13, col="white", lwd=1,xlab="MeOH (ppbv)",
ylab="Altitude /km", 
main=paste( (obs.dat[obs.dat$short.name=="trace.p.j",1]), format(obs.dat[obs.dat$short.name=="trace.p.j",3], "%Y %m"), "\n", 
"Lat", (obs.dat[obs.dat$short.name=="trace.p.j",5]), "-", (obs.dat[obs.dat$short.name=="trace.p.j",6]),
"Lon", (obs.dat[obs.dat$short.name=="trace.p.j",7]), "-", (obs.dat[obs.dat$short.name=="trace.p.j",8]) ) ,
xlim=c(0,3))
# add obs
arrows( (trace.p.j.data$V5-trace.p.j.data$V6), trace.p.j.data$V1, (trace.p.j.data$V5+trace.p.j.data$V6), trace.p.j.data$V1, length = 0.0, code =2 )
polygon(c(trace.p.j.dat.sd1, rev(trace.p.j.dat.sd2)), c(trace.p.j.data$V1, rev(trace.p.j.data$V1)), border=NA, col=rgb(169/256,169/256,169/256,0.5) )
lines(trace.p.j.data$V5, trace.p.j.data$V1, lwd=1.5)
# add model1
polygon(c(trace.p.j.mod.m1[4,1:hgt.10], rev(trace.p.j.mod.m1[2,1:hgt.10])), c(hgt[1:hgt.10], rev(hgt[1:hgt.10])), border=NA, col=rgb(255/256,0,0,0.5) )
lines(trace.p.j.mod.m1[3,1:hgt.10], hgt[1:hgt.10], lwd=1.5, col="red2")
axis(4,trace.p.j.data$V1+0.1, trace.p.j.data$V2, las=2)
grid()

dev.off()