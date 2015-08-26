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
dat1  <- subset(dat, dat$V3<=0.2)
dat2  <- subset(dat, dat$V3>=0.2 & dat$V3<=0.4)
dat3  <- subset(dat, dat$V3>=0.4 & dat$V3<=0.6)
dat4  <- subset(dat, dat$V3>=0.6 & dat$V3<=0.8)
dat5  <- subset(dat, dat$V3>=0.8 & dat$V3<=1.0)
dat6  <- subset(dat, dat$V3>=1.0 & dat$V3<=1.5)
dat7  <- subset(dat, dat$V3>=1.5 & dat$V3<=2.0)
dat8  <- subset(dat, dat$V3>=2.0 & dat$V3<=3.0)
dat9  <- subset(dat, dat$V3>=3.0 & dat$V3<=4.0)
dat10 <- subset(dat, dat$V3>=4.0 & dat$V3<=5.0)
dat11 <- subset(dat, dat$V3>=5.0 & dat$V3<=6.0)
dat12 <- subset(dat, dat$V3>=6.0 & dat$V3<=7.0)
dat13 <- subset(dat, dat$V3>=7.0 & dat$V3<=8.0)
dat14 <- subset(dat, dat$V3>=8.0 & dat$V3<=9.0)
dat15 <- subset(dat, dat$V3>=9.0 & dat$V3<=10.0)
dat16 <- subset(dat, dat$V3>=10.0 & dat$V3<=11.0)
dat17 <- subset(dat, dat$V3>=11.0 & dat$V3<=12.0)
dat18 <- subset(dat, dat$V3>=12.0 & dat$V3<=13.0)
dat19 <- subset(dat, dat$V3>=13.0 & dat$V3<=14.0)
dat20 <- subset(dat, dat$V3>=14.0 & dat$V3<=15.0)
dat21 <- subset(dat, dat$V3>=15.0 & dat$V3<=16.0)
dat22 <- subset(dat, dat$V3>=16.0 & dat$V3<=17.0)
dat23 <- subset(dat, dat$V3>=17.0 & dat$V3<=18.0)
dat24 <- subset(dat, dat$V3>=18.0 & dat$V3<=19.0)
dat25 <- subset(dat, dat$V3>=19.0 & dat$V3<=20.0)
dat26 <- subset(dat, dat$V3>=20.0 & dat$V3<=21.0)
dat27 <- subset(dat, dat$V3>=21.0 & dat$V3<=22.0)
dat28 <- subset(dat, dat$V3>=22.0 & dat$V3<=23.0)
dat29 <- subset(dat, dat$V3>=23.0 & dat$V3<=24.0)
dat30 <- subset(dat, dat$V3>=24.0 & dat$V3<=25.0)
dat31 <- subset(dat, dat$V3>=25.0 & dat$V3<=26.0)
dat32 <- subset(dat, dat$V3>=26.0 & dat$V3<=27.0)
dat33 <- subset(dat, dat$V3>=27.0 & dat$V3<=28.0)
dat34 <- subset(dat, dat$V3>=28.0 & dat$V3<=29.0)
dat35 <- subset(dat, dat$V3>=30.0)

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

# combine the heights and reform the data
data <- rbind(dat1, dat2, dat3, dat4, dat5, dat6, dat7, dat8, dat9, dat10, dat11, dat12, dat13, 
dat14, dat15, dat16, dat17, dat18, dat19, dat20, dat21, dat22, dat23, dat24, dat25, dat26, dat27, 
dat28, dat29, dat30, dat31, dat32, dat33, dat34, dat35)

#plot(data[,i], 1:35, xlim=c(0,0.15))

