# R script to extract SHADOZ data and write to files

# Alex Archibald, CAS, May 2012

# set the directory where the R scripts are saved
run.path <- getwd()

library(ncdf)
nc1 <- open.ncdf("/data/ata27/xeqra/xeqra_temp.nc")
hgt <- get.var.ncdf(nc1, "hybrid_ht")*1E-3 # in km

# extract the data from fiji
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/fiji"
source("get_shadoz_data_hybrid_hgt_eval.R")
fiji.dat<- as.data.frame(data )
names(fiji.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from ascen
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/ascen"
source("get_shadoz_data_hybrid_hgt_eval.R")
ascen.dat <- as.data.frame(data )
names(ascen.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from cotonou
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/cotonou"
source("get_shadoz_data_hybrid_hgt_eval.R")
cotonou.dat <- as.data.frame(data )
names(cotonou.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from java
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/java"
source("get_shadoz_data_hybrid_hgt_eval.R")
java.dat <- as.data.frame(data )
names(java.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from kuala
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/kuala"
source("get_shadoz_data_hybrid_hgt_eval.R")
kuala.dat <- as.data.frame(data )
names(kuala.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from samoa
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/samoa"
source("get_shadoz_data_hybrid_hgt_eval.R")
samoa.dat <- as.data.frame(data )
names(samoa.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from natal
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/natal"
source("get_shadoz_data_hybrid_hgt_eval.R")
natal.dat <- as.data.frame(data )
names(natal.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from samoa
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/reunion"
source("get_shadoz_data_hybrid_hgt_eval.R")
reunion.dat <- as.data.frame(data )
names(reunion.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from sancr
dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/sancr"
source("get_shadoz_data_hybrid_hgt_eval.R")
sancr.dat <- as.data.frame(data )
names(sancr.dat) <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
setwd(run.path)

# extract the data from alajuela
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/alajuela"
#source("get_shadoz_data_hybrid_hgt_eval.R")
#alajuela.dat <- data 
#setwd(run.path)

# extract the data from nairobi
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/nairobi"
#source("get_shadoz_data_hybrid_hgt_eval.R")
#nairobi.dat <- data 
#setwd(run.path)

# extract the data from param
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/param"
#source("get_shadoz_data_hybrid_hgt_eval.R")
#param.dat <- data 
#setwd(run.path)

# extract the data from irene
#dir.path <- "/shared/scout1/eo/Sondes/SHADOZ/data/irene"
#source("get_shadoz_data_hybrid_hgt_eval.R")
#irene.dat <- data 
#setwd(run.path)


# write out files in csv format. One file for each station. One column for each month and rows 
# of hybrid_ht
write.table(fiji.dat, file=paste(obs.dir, "shadoz/fiji_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(fiji.dat$Jan)], sep=",")
write.table(samoa.dat, file=paste(obs.dir, "shadoz/samoa_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(samoa.dat$Jan)], sep=",")
write.table(natal.dat, file=paste(obs.dir, "shadoz/natal_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(natal.dat$Jan)], sep=",")
write.table(reunion.dat, file=paste(obs.dir, "shadoz/reunion_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(reunion.dat$Jan)], sep=",")
write.table(sancr.dat, file=paste(obs.dir, "shadoz/sancr_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(sancr.dat$Jan)], sep=",")
write.table(kuala.dat, file=paste(obs.dir, "shadoz/kuala_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(kuala.dat$Jan)], sep=",")
write.table(java.dat, file=paste(obs.dir, "shadoz/java_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(java.dat$Jan)], sep=",")
write.table(cotonou.dat, file=paste(obs.dir, "shadoz/cotonou_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(cotonou.dat$Jan)], sep=",")
write.table(ascen.dat, file=paste(obs.dir, "shadoz/ascen_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(ascen.dat$Jan)], sep=",")
#write.table(param.dat, file=paste(obs.dir, "shadoz/param_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(.dat$Jan)], sep=",")
#write.table(nairobi.dat, file=paste(obs.dir, "shadoz/nairobi_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(.dat$Jan)], sep=",")
#write.table(alajuela.dat, file=paste(obs.dir, "shadoz/alajuela_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(.dat$Jan)], sep=",")
#write.table(irene.dat, file=paste(obs.dir, "shadoz/irene_hgt.dat", sep=""), col.names=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"), row.names=hgt[1:length(.dat$Jan)], sep=",")

rm(data)
q()
