# R script to plot and calculate the contribution of
# different ozone loss reactions to the total loss

# Alex Archibald, July 2012

# loop vars
i <- NULL; j <- NULL
nav         <- 6.02214179E23 
conv.factor <- 60*60*24*30*48*(1e-12)

# extract/define variables
lon   <- get.var.ncdf(nc1, "longitude")
lat   <- get.var.ncdf(nc1, "latitude")
hgt   <- get.var.ncdf(nc1, "hybrid_ht")*1E-3
time  <- get.var.ncdf(nc1, "t")

# define empty arrays to hold data
for (i in 1:12) {
assign(paste("l",i,".std", sep=""), array(NA, dim=c(length(lon), length(lat), length(hgt), length(time)) ) ) }

# Check to see if a trop. mask and mass exist?
if ( exists("mask") == TRUE) print("Tropospheric Mask exists, carrying on") else (source(paste(script.dir, "calc_trop_mask.R", sep="")))

# copy the mask that is for the troposphere
strat.mask <- 1-(mask)

# extract the fluxes. These are based on the 12 Ox cycles 
# from Lee et al., JGR 2001
p1  <- get.var.ncdf(nc1, st.prod.code)
l1  <- get.var.ncdf(nc1, st.loss1.code)
l2  <- get.var.ncdf(nc1, st.loss2.code)
l3  <- get.var.ncdf(nc1, st.loss3.code)
l4  <- get.var.ncdf(nc1, st.loss4.code)
l5  <- get.var.ncdf(nc1, st.loss5.code)
l6  <- get.var.ncdf(nc1, st.loss6.code)
l7  <- get.var.ncdf(nc1, st.loss7.code)
l8  <- get.var.ncdf(nc1, st.loss8.code)
l9  <- get.var.ncdf(nc1, st.loss9.code)
l10 <- get.var.ncdf(nc1, st.loss10.code)
l11 <- get.var.ncdf(nc1, st.loss11.code)
l12 <- get.var.ncdf(nc1, st.loss12.code)


# calculate the total fluxes in Tg/y
# in the stratosphere
production <- sum( (p1*strat.mask) )*conv.factor
cyc1       <- sum( (l1*strat.mask) )*conv.factor
cyc1       <- sum( (l1*strat.mask) )*conv.factor
cyc2       <- sum( (l2*strat.mask) )*conv.factor
cyc3       <- sum( (l3*strat.mask) )*conv.factor
cyc4       <- sum( (l4*strat.mask) )*conv.factor
cyc5       <- sum( (l5*strat.mask) )*conv.factor
cyc6       <- sum( (l6*strat.mask) )*conv.factor
cyc7       <- sum( (l7*strat.mask) )*conv.factor
cyc8       <- sum( (l8*strat.mask) )*conv.factor
cyc9       <- sum( (l9*strat.mask) )*conv.factor
cyc10      <- sum( (l10*strat.mask) )*conv.factor
cyc11      <- sum( (l11*strat.mask) )*conv.factor
cyc12      <- sum( (l12*strat.mask) )*conv.factor

# convert from moles/gridbox/s -> molecules/cm3/s
for (i in 1:length(time) ) {
l1.std[,,,i] <- ( l1[,,,i]/(vol*1E6))*nav
l2.std[,,,i] <- ( l2[,,,i]/(vol*1E6))*nav
l3.std[,,,i] <- ( l3[,,,i]/(vol*1E6))*nav
l4.std[,,,i] <- ( l4[,,,i]/(vol*1E6))*nav
l5.std[,,,i] <- ( l5[,,,i]/(vol*1E6))*nav
l6.std[,,,i] <- ( l6[,,,i]/(vol*1E6))*nav
l7.std[,,,i] <- ( l7[,,,i]/(vol*1E6))*nav
l8.std[,,,i] <- ( l8[,,,i]/(vol*1E6))*nav
l9.std[,,,i] <- ( l9[,,,i]/(vol*1E6))*nav
l10.std[,,,i] <- ( l10[,,,i]/(vol*1E6))*nav
l11.std[,,,i] <- ( l11[,,,i]/(vol*1E6))*nav
l12.std[,,,i] <- ( l12[,,,i]/(vol*1E6))*nav }

# find mid latitude grid box and do a zonal mean
mid.lat <- which(lat >=37.50)[1]

cyc.1  <- apply(l1.std[,mid.lat,,4], c(2), mean)
cyc.2  <- apply(l2.std[,mid.lat,,4], c(2), mean)
cyc.3  <- apply(l3.std[,mid.lat,,4], c(2), mean)
cyc.4  <- apply(l4.std[,mid.lat,,4], c(2), mean)
cyc.5  <- apply(l5.std[,mid.lat,,4], c(2), mean)
cyc.6  <- apply(l6.std[,mid.lat,,4], c(2), mean)
cyc.7  <- apply(l7.std[,mid.lat,,4], c(2), mean)
cyc.8  <- apply(l8.std[,mid.lat,,4], c(2), mean)
cyc.9  <- apply(l9.std[,mid.lat,,4], c(2), mean)
cyc.10 <- apply(l10.std[,mid.lat,,4], c(2), mean)
cyc.11 <- apply(l11.std[,mid.lat,,4], c(2), mean)
cyc.12 <- apply(l12.std[,mid.lat,,4], c(2), mean)

# ###################################################################################################################################
# plot a mid latitude profile of the different cycles
pdf(file=paste(out.dir,mod1.name,"_strat_o3_loss.pdf", sep=""),width=8,height=6,paper="special",onefile=TRUE,pointsize=12)

par(mfrow=c(1,2))
## Is this just repetition?? ##
cyc.1  <- apply(l1.std[,mid.lat,,4], c(2), mean)
cyc.2  <- apply(l2.std[,mid.lat,,4], c(2), mean)
cyc.3  <- apply(l3.std[,mid.lat,,4], c(2), mean)
cyc.4  <- apply(l4.std[,mid.lat,,4], c(2), mean)
cyc.5  <- apply(l5.std[,mid.lat,,4], c(2), mean)
cyc.6  <- apply(l6.std[,mid.lat,,4], c(2), mean)
cyc.7  <- apply(l7.std[,mid.lat,,4], c(2), mean)
cyc.8  <- apply(l8.std[,mid.lat,,4], c(2), mean)
cyc.9  <- apply(l9.std[,mid.lat,,4], c(2), mean)
cyc.10 <- apply(l10.std[,mid.lat,,4], c(2), mean)
cyc.11 <- apply(l11.std[,mid.lat,,4], c(2), mean)
cyc.12 <- apply(l12.std[,mid.lat,,4], c(2), mean)

# plot the data 
plot(log10(cyc.1), hgt, type="l", col="red", ylim=c(10,52), xlim=c(0,8), xaxt="n", ylab="Altitude (km)", xlab="Rate of Ox loss", lwd=1.5)
lines(log10(cyc.2), hgt, col="red", lty=2, lwd=1.5)
lines(log10(cyc.3), hgt, col="blue", lty=1, lwd=1.5)
lines(log10(cyc.4), hgt, col="red", lty=3, lwd=1.5)
lines(log10(cyc.5), hgt, col="purple", lty=1, lwd=1.5)
lines(log10(cyc.6), hgt, col="red", lty=4, lwd=1.5)
lines(log10(cyc.7), hgt, col="green", lty=1, lwd=1.5)
lines(log10(cyc.8), hgt, col="purple", lty=2, lwd=1.5)
lines(log10(cyc.9), hgt, col="blue", lty=2, lwd=1.5)
lines(log10(cyc.10), hgt, col="blue", lty=3, lwd=1.5)
lines(log10(cyc.11), hgt, col="green", lty=3, lwd=1.5)
lines(log10(cyc.12), hgt, col="black", lty=1, lwd=1.5)
minor.ticks.axis(1,9,mn=0,mx=8)
grid()
legend("bottomright", 
c( expression(paste(h,nu,+Cl[2],O[2], sep="")), "ClO+BrO", expression(paste(HO[2],+O[3], sep="")), expression(paste(ClO+HO[2], sep="")),
expression(paste(BrO+HO[2], sep="")), "ClO+O", expression(paste(NO[2],"+O", sep="")), "BrO+O", expression(paste(HO[2],"+O", sep="")),
expression(paste(H+O[3], sep="")), expression(paste(h,nu,+NO[3], sep="")), expression(paste(O[3],"+O", sep="")) ),
col=c("red","red","blue","red","purple","red","green","purple","blue","blue","green","black"), lty=c(1,2,1,3,1,4,1,2,2,3,3,1), bty="n", cex=0.8 )
par(xpd=NA)
text(4,3, expression(paste("(molecules cm"^"-3"," s"^"-1",")", sep="") ))
text(12,60, paste("37.5N, March, stratospheric Ox loss:",mod1.name, sep=" "))
par(xpd=FALSE)

total <- rowSums(cbind(cyc.1, cyc.2, cyc.3, cyc.4, cyc.5, cyc.6, cyc.7, cyc.8, cyc.8, cyc.9, cyc.10, cyc.11, cyc.12) )
clox  <- rowSums(cbind(cyc.1, cyc.2, cyc.4, cyc.6) ) / total
hox   <- rowSums(cbind(cyc.3, cyc.9, cyc.10) ) / total
brox  <- rowSums(cbind(cyc.5, cyc.8) ) / total
nox   <- rowSums(cbind(cyc.7, cyc.11) ) / total
ox    <- cyc.12 / total

ox.loss <- data.frame(clox, hox, brox, nox, ox)

plot(ox.loss$clox*100, hgt, ylim=c(10,52), xlim=c(0,100), lwd=2, col="red", type="l", yaxt="n", xlab="Percentage", ylab="")
lines(ox.loss$hox*100, hgt, lwd=2, col="blue")
lines(ox.loss$brox*100, hgt, lwd=2, col="purple")
lines(ox.loss$nox*100, hgt, lwd=2, col="green")
lines(ox.loss$ox*100, hgt, lwd=2, col="black")
grid()
legend(70,30, c( expression(paste(ClO[x], sep="")), expression(paste(HO[x], sep="")), expression(paste(BrO[x], sep="")), expression(paste(NO[x], sep="")), expression(paste(O[x], sep="")) ), 
col=c("red","blue","purple","green","black"), lty=c(1,1,1,1,1), bty="n", cex=0.8)

dev.off()

