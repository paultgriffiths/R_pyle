calc_ideal_mass <- function(ncfile, pres, temp) {
  # R function to calculate the mass using the ideal gas equation. 
  # Comparison to the UKCA AIR MASS diagnostic shows these % differences:
  #      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
  # -59.29000  -0.95310  -0.60190  -0.52060  -0.02939  67.55000 
  # calc the air mass using the ideal gas equation
  r_cons <-  8.314472 # J/K mol
  mm.air <-  28.97*1.0E-03 # kg/mol
  # calc air density kg/m3
  air.den <- (pres*mm.air)/(r_cons*temp)

  if(sum(dim(pres))==sum(dim(temp))) {
    # assuming we are dealing with multi-dimesional arrays here...
    print("Generating mass array")
    lon <- dim(pres)[1]
    lat <- dim(pres)[2]
    time <- dim(pres)[4]
    hgt <- dim(pres)[3]
    if(!exists("vol")) stop("No volume array")
    mass.calc <- array(dim=c(length(lon), length(lat), length(hgt), length(time)), NA)
    for(i in 1:length(time)) { # loop over time
      if(dim(vol)[1]==dim(air.den[1])){ # check that the volume is the same dimension as
                                        # the new array
        mass.calc[,,,i] <- air.den[,,,i]*vol[,,]
      } # end if vol array check
    } # end loop over model time
  } # end if dimensions are the same
  return(mass.calc)
}

