get.srf.o3 <- function(in.file,option) {
  # function that reads in a data file (from GAW website) 
  # option 1 = seasonal cycle
  # option 2 = (multi) annual mean
  # option 3 = range (max - min) of (mean) monthly mean 
  # option 4 = raw time series
  # Depending on the option a data.frame of monthly mean and sd of variable with metadata
  # are returned
  # read in file
  data <- readLines(in.file)
  
  # get meta data
  lat <- grep("LATITUDE", data)
  lat <- as.numeric(unlist(strsplit(data[lat], ":"))[2])
  
  lon <- grep("LONGITUDE", data)
  lon <- as.numeric(unlist(strsplit(data[lon], ":"))[2])
  
  alt <- grep("ALTITUDE", data)
  alt <- as.numeric(unlist(strsplit(data[alt], ":"))[2])
  
  id <- grep("STATION NAME", data)
  id <- unlist(strsplit(data[id], ":"))[2]
  
  species <- grep("PARAMETER", data)
  species <- unlist(strsplit(data[species], ":"))[2]
  species <- gsub(" ", "", species)

  unit <- grep("MEASUREMENT UNIT", data)
  unit <- unlist(strsplit(data[unit], ":"))[2]
  unit <- gsub(" ", "", unit)
  
  # check to make sure that the measurements are in ppb!
  if(unit == "ppbv") unit <- "ppb"

  scat <- grep("STATION CATEGORY", data)
  scat <- unlist(strsplit(data[scat], ":"))[2]
  scat <- gsub(" ", "", scat)
  
  # check that there is a category 
  if(scat == "") scat <- "Unknown"
  
  # calc the number of comment lines
  com.lines <- grep("^[C]+", data)
  
  # read in data 
  data <- read.table(in.file, skip=length(com.lines) )
  
  # option 1
  if(option==1) {
    # format first column as POSIXct
    data$V1 <- as.POSIXct(data$V1, format="%Y-%m-%d")
    data$V5[data$V5<=0] <- NA
    data.mean <- aggregate(data["V5"], format(data["V1"], "%m"), mean, na.rm=T) 
    data.sd   <- aggregate(data["V5"], format(data["V1"], "%m"), sd, na.rm=T) 
    if(unit=="ppb") { # carry on as obs are in ppb
      data <- data.frame(rep(id, nrow(data.mean)), 
                         rep(lat, nrow(data.mean)),
                         rep(lon, nrow(data.mean)),
                         rep(alt, nrow(data.mean)),
                         rep(scat, nrow(data.mean)),
                         data.mean$V5,
                         data.sd$V5,
                         data.mean$V1)
          } else { # units are in micro grams/m3 
            data <- data.frame(rep(id, nrow(data.mean)), 
                               rep(lat, nrow(data.mean)),
                               rep(lon, nrow(data.mean)),
                               rep(alt, nrow(data.mean)),
                               rep(scat, nrow(data.mean)),
                               data.mean$V5/2,
                               data.sd$V5/2,
                               data.mean$V1)
              } # end unit check
    names(data) <- c("Station", "lat", "lon", "alt", "category", 
                     paste(species, ".mean", sep=""),
                     paste(species, ".sd", sep=""),
                     "month")
      }
  
  # option 2
  if(option==2) {
    # format first column as POSIXct
    data$V1 <- as.POSIXct(data$V1, format="%Y-%m-%d")
    data$V5[data$V5<=0] <- NA
    data.mean <- aggregate(data["V5"], format(data["V1"], "%m"), mean, na.rm=T) 
    data.mean <- mean(data.mean$V5)
    data.sd   <- aggregate(data["V5"], format(data["V1"], "%m"), sd, na.rm=T) 
    data.sd   <- mean(data.sd$V5)
    if(unit=="ppb") { # carry on as obs are in ppb
      data <- data.frame(id, 
                       lat,
                       lon,
                       alt,
                       scat,
                       data.mean,
                       data.sd)
    } else { # units are in micro grams/m3 
      data <- data.frame(id, 
                         lat,
                         lon,
                         alt,
                         scat,
                         data.mean/2,
                         data.sd/2)
          } # end unit check
    names(data) <- c("Station", "lat", "lon", "alt", "category",
                     paste(species, ".mean", sep=""),
                     paste(species, ".sd", sep=""))
  }

  # option 3 - the range of O3 values (max - min)
  if(option==3) {
    # format first column as POSIXct
    data$V1 <- as.POSIXct(data$V1, format="%Y-%m-%d")
    data$V5[data$V5<=0] <- NA
    if(unit=="ppb") { # carry on as obs are in ppb
      data.mean <- aggregate(data["V5"], format(data["V1"], "%m"), mean, na.rm=T)
      data.range <- max(as.numeric(data.mean$V5)) - min(as.numeric(data.mean$V5))
      data <- data.frame(id, 
                       lat,
                       lon,
                       alt,
                       scat,
                       data.range)
    } else { # units are in micro grams/m3 
      data.mean <- aggregate(data["V5"], format(data["V1"], "%m"), mean, na.rm=T)
      data.mean$V5 <- data.mean$V5/2
      data.range <- max(as.numeric(data.mean$V5)) - min(as.numeric(data.mean$V5))
      data <- data.frame(id, 
                         lat,
                         lon,
                         alt,
                         scat,
                         data.range)
    } # end unit check
    names(data) <- c("Station", "lat", "lon", "alt", "category",
                     paste(species, ".range", sep=""))
  }

  # option 4 - return a time series of the data
  if(option==4) {
    # format first column as POSIXct
    data$V1 <- as.POSIXct(data$V1, format="%Y-%m-%d")
    data$V5[data$V5<=0] <- NA
    if(unit=="ppb") { # carry on as obs are in ppb
      data <- data.frame(id, 
                         lat,
                         lon,
                         alt,
                         scat,
                         data$V1,
                         data$V5)
    } else { # units are in micro grams/m3 
      data <- data.frame(id, 
                         lat,
                         lon,
                         alt,
                         scat,
                         data$V1,
                         data$V5/2)
    } # end unit check
    names(data) <- c("Station", "lat", "lon", "alt", "category", "date", species)
  }
  
  return(data)
}