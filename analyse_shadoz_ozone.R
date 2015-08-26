# R script to extract SHADOZ data and write to files

# Alex Archibald, CAS, May 2012

# set the directory where the R scripts are saved
run.path <- getwd()

data.pres <- c(1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,
500,450,400,350,300,250,225,200,175,150,125,100,70,50,30,20,10)

# extract the data from costa rica
dir.path <- "/scratch/ata27/costarica"
source("get_shadoz_data_V05_era_levs_eval.R")
heredia.dat <- data 
setwd(run.path)

# extract the data from param
dir.path <- "/scratch/ata27/paramaribo"
source("get_shadoz_data_V05_era_levs_eval.R")
param.dat <- data 
setwd(run.path)

# extract the data from nairobi
dir.path <- "/scratch/ata27/nairobi"
source("get_shadoz_data_V05_era_levs_eval.R")
nairobi.dat <- data 
setwd(run.path)

# extract the data from irene
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/irene"
source("get_shadoz_data_era_levs_eval.R")
irene.dat <- data 
setwd(run.path)

# extract the data from fiji
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/fiji"
source("get_shadoz_data_era_levs_eval.R")
fiji.dat <- data 
setwd(run.path)

# extract the data from ascen
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/ascen"
source("get_shadoz_data_era_levs_eval.R")
ascen.dat <- data 
setwd(run.path)

# extract the data from cotonou
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/cotonou"
source("get_shadoz_data_era_levs_eval.R")
cotonou.dat <- data 
setwd(run.path)

# extract the data from java
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/java"
source("get_shadoz_data_era_levs_eval.R")
java.dat <- data 
setwd(run.path)

# extract the data from kuala
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/kuala"
source("get_shadoz_data_era_levs_eval.R")
kuala.dat <- data 
setwd(run.path)

# extract the data from samoa
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/samoa"
source("get_shadoz_data_era_levs_eval.R")
samoa.dat <- data 
setwd(run.path)

# extract the data from natal
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/natal"
source("get_shadoz_data_era_levs_eval.R")
natal.dat <- data 
setwd(run.path)

# extract the data from samoa
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/reunion"
source("get_shadoz_data_era_levs_eval.R")
reunion.dat <- data 
setwd(run.path)

# extract the data from sancr
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/sancr"
source("get_shadoz_data_era_levs_eval.R")
sancr.dat <- data 
setwd(run.path)

# extract the data from malindi
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/malindi"
source("get_shadoz_data_era_levs_eval.R")
malindi.dat <- data 
setwd(run.path)

# extract the data from hilo
dir.path <- "/scratch/ata27/hilo"
source("get_shadoz_data_era_levs_eval.R")
hilo.dat <- data 
setwd(run.path)

# extract the data from alajuela
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/alajuela"
#source("get_shadoz_data_era_levs_eval.R")
#alajuela.dat <- data 
#setwd(run.path)

# write out files in csv format. One file for each station. One column for each month and rows 
# of pressure level (1000-10 hPa)
write.table(fiji.dat, file=paste(obs.dir,"shadoz/fiji.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(samoa.dat, file=paste(obs.dir,"shadoz/samoa.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(natal.dat, file=paste(obs.dir,"shadoz/natal.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(reunion.dat, file=paste(obs.dir,"shadoz/reunion.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(sancr.dat, file=paste(obs.dir,"shadoz/sancr.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(kuala.dat, file=paste(obs.dir,"shadoz/kuala.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(java.dat, file=paste(obs.dir,"shadoz/java.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(cotonou.dat, file=paste(obs.dir,"shadoz/cotonou.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(ascen.dat, file=paste(obs.dir,"shadoz/ascen.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(heredia.dat, file=paste(obs.dir,"shadoz/heredia.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres[4:31], sep=",")
write.table(nairobi.dat[2:26,], file=paste(obs.dir,"shadoz/nairobi.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres[7:31], sep=",")
write.table(irene.dat, file=paste(obs.dir,"shadoz/irene.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres[6:31], sep=",")
write.table(malindi.dat, file=paste(obs.dir,"shadoz/malindi.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
write.table(hilo.dat, file=paste(obs.dir,"shadoz/hilo.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
#write.table(alajuela.dat, file=paste(obs.dir,"shadoz/alajuela.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")
#write.table(param.dat, file=paste(obs.dir,"shadoz/param.dat",sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=data.pres, sep=",")

rm(data)
q()
