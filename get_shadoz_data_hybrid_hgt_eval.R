# R script to read in and average the SHADOZ ozone sonde data.

# You just need to pass in a path directory and you will be returned with
# a set of 12 monthly averaged height binned O3 data.

# Alex Archbiald, CAS, May 2012

# List all the files in the folder
setwd(dir.path)
files     <- list.files()

# convert file names into dates
#datetimes <- as.Date(files, "fiji_%Y%m%d")
tmp1  <- unlist(strsplit(files, "_", fixed=T))
tmp2  <- unlist(strsplit(tmp1, ".", fixed=T))
tmp3  <- as.numeric(tmp2)
tmp4  <- tmp3[complete.cases(tmp3)]
datetimes <- strptime(tmp4, format="%Y%m%d")
rm(tmp1, tmp2, tmp3, tmp4)  # clean up

# read in the data (skip the first 19 rows) and combine into a data frame 
dat       <- lapply(files, read.table, skip=19, na.strings="9000")

# loop over the number of files and add the Date to the data
for (i in 1:length(files)) {
    dat[[i]]$Date = rep(datetimes[i], nrow(dat[[i]]))
}

# combine the data into one data.frame
dat <- do.call("rbind", dat)

# subset the master data.frame by the heights (m) that the measurment was made at
for (i in 2:(length(hgt)+1) ) {
assign(paste("dat",i-1,sep=""), subset(dat, dat$V3>=hgt[i-1] & dat$V3<=hgt[i]))
}

# format the data.frame such that the monthly avergaes (Jan-Dec) for each height are calculated
dat1  <- tapply(dat1$V7, format(dat1$Date, "%m"), mean, na.rm=T)
dat2  <- tapply(dat2$V7, format(dat2$Date, "%m"), mean, na.rm=T)
dat3  <- tapply(dat3$V7, format(dat3$Date, "%m"), mean, na.rm=T)
dat4  <- tapply(dat4$V7, format(dat4$Date, "%m"), mean, na.rm=T)
dat5  <- tapply(dat5$V7, format(dat5$Date, "%m"), mean, na.rm=T)
dat6  <- tapply(dat6$V7, format(dat6$Date, "%m"), mean, na.rm=T)
dat7  <- tapply(dat7$V7, format(dat7$Date, "%m"), mean, na.rm=T)
dat8  <- tapply(dat8$V7, format(dat8$Date, "%m"), mean, na.rm=T)
dat9  <- tapply(dat9$V7, format(dat9$Date, "%m"), mean, na.rm=T)
dat10 <- tapply(dat10$V7, format(dat10$Date, "%m"), mean, na.rm=T)
dat11 <- tapply(dat11$V7, format(dat11$Date, "%m"), mean, na.rm=T)
dat12 <- tapply(dat12$V7, format(dat12$Date, "%m"), mean, na.rm=T)
dat13 <- tapply(dat13$V7, format(dat13$Date, "%m"), mean, na.rm=T)
dat14 <- tapply(dat14$V7, format(dat14$Date, "%m"), mean, na.rm=T)
dat15 <- tapply(dat15$V7, format(dat15$Date, "%m"), mean, na.rm=T)
dat16 <- tapply(dat16$V7, format(dat16$Date, "%m"), mean, na.rm=T)
dat17 <- tapply(dat17$V7, format(dat17$Date, "%m"), mean, na.rm=T)
dat18 <- tapply(dat18$V7, format(dat18$Date, "%m"), mean, na.rm=T)
dat19 <- tapply(dat19$V7, format(dat19$Date, "%m"), mean, na.rm=T)
dat20 <- tapply(dat20$V7, format(dat20$Date, "%m"), mean, na.rm=T)
dat21 <- tapply(dat21$V7, format(dat21$Date, "%m"), mean, na.rm=T)
dat22 <- tapply(dat22$V7, format(dat22$Date, "%m"), mean, na.rm=T)
dat23 <- tapply(dat23$V7, format(dat23$Date, "%m"), mean, na.rm=T)
dat24 <- tapply(dat24$V7, format(dat24$Date, "%m"), mean, na.rm=T)
dat25 <- tapply(dat25$V7, format(dat25$Date, "%m"), mean, na.rm=T)
dat26 <- tapply(dat26$V7, format(dat26$Date, "%m"), mean, na.rm=T)
dat27 <- tapply(dat27$V7, format(dat27$Date, "%m"), mean, na.rm=T)
dat28 <- tapply(dat28$V7, format(dat28$Date, "%m"), mean, na.rm=T)
dat29 <- tapply(dat29$V7, format(dat29$Date, "%m"), mean, na.rm=T)
dat30 <- tapply(dat30$V7, format(dat30$Date, "%m"), mean, na.rm=T)
dat31 <- tapply(dat31$V7, format(dat31$Date, "%m"), mean, na.rm=T)
dat32 <- tapply(dat32$V7, format(dat32$Date, "%m"), mean, na.rm=T)
dat33 <- tapply(dat33$V7, format(dat33$Date, "%m"), mean, na.rm=T)
dat34 <- tapply(dat34$V7, format(dat34$Date, "%m"), mean, na.rm=T)
dat35 <- tapply(dat35$V7, format(dat35$Date, "%m"), mean, na.rm=T)
dat36 <- tapply(dat36$V7, format(dat36$Date, "%m"), mean, na.rm=T)
dat37 <- tapply(dat37$V7, format(dat37$Date, "%m"), mean, na.rm=T)
dat38 <- tapply(dat38$V7, format(dat38$Date, "%m"), mean, na.rm=T)
dat39 <- tapply(dat39$V7, format(dat39$Date, "%m"), mean, na.rm=T)
dat40 <- tapply(dat40$V7, format(dat40$Date, "%m"), mean, na.rm=T)
dat41 <- tapply(dat41$V7, format(dat41$Date, "%m"), mean, na.rm=T)
dat42 <- tapply(dat42$V7, format(dat42$Date, "%m"), mean, na.rm=T)
dat43 <- tapply(dat43$V7, format(dat43$Date, "%m"), mean, na.rm=T)
dat44 <- tapply(dat44$V7, format(dat44$Date, "%m"), mean, na.rm=T)
dat45 <- tapply(dat45$V7, format(dat45$Date, "%m"), mean, na.rm=T)
dat46 <- tapply(dat46$V7, format(dat46$Date, "%m"), mean, na.rm=T)
dat47 <- tapply(dat47$V7, format(dat47$Date, "%m"), mean, na.rm=T)
dat48 <- tapply(dat48$V7, format(dat48$Date, "%m"), mean, na.rm=T)
dat49 <- tapply(dat49$V7, format(dat49$Date, "%m"), mean, na.rm=T)
dat50 <- tapply(dat50$V7, format(dat50$Date, "%m"), mean, na.rm=T)
dat51 <- tapply(dat51$V7, format(dat51$Date, "%m"), mean, na.rm=T)
dat52 <- tapply(dat52$V7, format(dat52$Date, "%m"), mean, na.rm=T)
dat53 <- tapply(dat53$V7, format(dat53$Date, "%m"), mean, na.rm=T)
dat54 <- tapply(dat54$V7, format(dat54$Date, "%m"), mean, na.rm=T)
dat55 <- tapply(dat55$V7, format(dat55$Date, "%m"), mean, na.rm=T)
dat56 <- tapply(dat56$V7, format(dat56$Date, "%m"), mean, na.rm=T)
dat57 <- tapply(dat57$V7, format(dat57$Date, "%m"), mean, na.rm=T)
dat58 <- tapply(dat58$V7, format(dat58$Date, "%m"), mean, na.rm=T)
dat59 <- tapply(dat59$V7, format(dat59$Date, "%m"), mean, na.rm=T)
dat60 <- tapply(dat60$V7, format(dat60$Date, "%m"), mean, na.rm=T)

# combine the heights and reform the data
data <- rbind(dat1, dat2, dat3, dat4, dat5, dat6, dat7, dat8, dat9, dat10, dat11, dat12, dat13, 
dat14, dat15, dat16, dat17, dat18, dat19, dat20, dat21, dat22, dat23, dat24, dat25, dat26, dat27, 
dat28, dat29, dat30, dat31, dat32, dat33, dat34, dat35, dat36, dat37, 
dat38, dat39, dat40, dat41, dat42, dat43, dat44, dat45, dat46, dat47, 
dat48, dat49, dat50, dat51, dat52, dat53, dat54, dat55, dat56, dat57, 
dat58, dat59, dat60 )

#plot(data[,i], 1:35, xlim=c(0,0.15))

