# R function for adding logorithmic minor ticks to a plot
# Taken from http://stackoverflow.com/questions/6955440/displaying-minor-logarithmic-ticks-in-x-axis-in-r

# to use do:
# minor.ticks.axis(1,9,mn=0,mx=8)
# where 1 refers to the axis (i.e. bottom==1,left==2,right==3,top==4)
# where 9 refers to the number of minor tick marks
# There are two extra parameters, mn and mx for the minimum and the maximum on the 
# logarithmic scale (mn=0 thus means the minimum is 10^0 or 1 !)

minor.ticks.axis <- function(ax,n,t.ratio=0.5,mn,mx,...){

  lims <- par("usr")
  if(ax %in%c(1,3)) lims <- lims[1:2] else lims[3:4]

  major.ticks <- pretty(lims,n=5)
  if(missing(mn)) mn <- min(major.ticks)
  if(missing(mx)) mx <- max(major.ticks)

  major.ticks <- major.ticks[major.ticks >= mn & major.ticks <= mx]

  labels <- sapply(major.ticks,function(i)
            as.expression(bquote(10^ .(i)))
          )
  axis(ax,at=major.ticks,labels=labels,...)

  n <- n+2
  minors <- log10(pretty(10^major.ticks[1:2],n))-major.ticks[1]
  minors <- minors[-c(1,n)]

  minor.ticks = c(outer(minors,major.ticks,`+`))
  minor.ticks <- minor.ticks[minor.ticks > mn & minor.ticks < mx]


  axis(ax,at=minor.ticks,tcl=par("tcl")*t.ratio,labels=FALSE)
}