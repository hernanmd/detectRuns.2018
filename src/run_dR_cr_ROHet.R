# detectRuns Workflow Script version 1.2
# Authors: Hernan Morales
# Date: 31/7/2018
#
# Input Files:
#   PED/MAP file(s) 
# Output Files:
#   .consecutiveROHet.csv
#   snpsInRuns-chr*.png : PNG of SNPs in Runs
#   detectRUNS Manhattan Plot

source("input_params.R")

#################################################################
#
#     Install packages on demand & Load libraries
#
#################################################################

list.of.packages <- c("detectRUNS")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.us.r-project.org')

library(detectRUNS)
setwd(cwd)
# Using RStudio? uncomment the following line:
# setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Create output directory
# Remove existing and create new output directory
if (file.exists(outDirROHet)){
  unlink (outDirROHet, recursive=TRUE) 
} else {
  dir.create(file.path(outDirROHet), showWarnings = FALSE)
}

## Capture messages and errors to a file.
logFile <- file(logFileROHet, open = "wt")
sink(logFile, type = "message")

#################################################################
#
#     Consecutive Runs : ROHet
#
#################################################################

consecutiveRuns_het <- consecutiveRUNS.run(
  genotypeFile = genotypeFilePath,
  mapFile = mapFilePath,
  minSNP = minSNPParam,
  ROHet = TRUE,
  maxGap = 10^6,
  minLengthBps = minLengthBpsParam,
  # Depends of density of Microarray chip
  # 0 by default (55k or lower Chip)
  maxOppRun = maxOppRun,
  maxMissRun = maxMissRun
)

if (nrow(consecutiveRuns_het) == 0) {
  ## reset message sink and close the file connection
  stopLogMsg <- "No consecutive RUNS found for ROHet"
  message(stopLogMsg)
  sink(type="message")
  close(logFile)    
  stop(stopLogMsg)
}

# The function summaryRuns() takes in input the dataframe with results from runs detection and calculates a number of basic descriptive statistics on runs. Additional necessary parameters are the paths to the Plink ped and map files. Class and snpInRuns are optional arguments.
summaryList <- summaryRuns(
  runs = consecutiveRuns_het, 
  mapFile = mapFilePath, 
  genotypeFile = genotypeFilePath, 
  Class = summaryClass, 
  snpInRuns = TRUE)

#################################################################
#
#     Plot SNPs in Runs
#
#################################################################

for (chr in 1:maxChr){
  imgFilename <- paste0(outDirROHet, "snpsInRunsROHet-chr", chr ,".png")
  png(imgFilename, imgXSize, imgYSize, pointsize = snpPointSize)
  plot_SnpsInRuns(
    runs = consecutiveRuns_het[consecutiveRuns_het$chrom==chr,], 
    genotypeFile = genotypeFilePath, 
    mapFile = mapFilePath)
  dev.off()
}

# To identify the position of a runs (ROH in this case) peak, e.g. from plot_SnpsInRuns(), one can conveniently use the function detectRUNS::tableRuns(): this requests as input, besides the runs dataframe, also the paths to the original ped/map files, and the threshold above which we want information on such "peaks" (e.g. only peaks where SNP are inside runs in more than 70% of the individuals in that population/group). 

topRunsFilename <- paste0(outDirROHet , prjName,".topRunsROHet.csv")
topRuns <- tableRuns(
  runs = consecutiveRuns_het, 
  genotypeFile = genotypeFilePath, 
  mapFile = mapFilePath, 
  # Set a lower threshold if "Error in `row.names<-.data.frame`(`*tmp*`, value = value) : invalid 'row.names' length". Defaults to 0.5  
  threshold = topRunsThreshold)
write.table(
  x = topRuns, 
  file = topRunsFilename, 
  quote = F, 
  sep = delim)

#################################################################
#
#     Manhattan Plot
#
#################################################################

# The information on the proportion of times each SNP falls inside a run, can also be plotted against SNP positions in all chromosomes together, similarly to the familiar GWAS Manhattan plots:

runsFilename <- paste0(outDirROHet, prjName,".consecutiveROHet.csv") 
write.table(
  x = consecutiveRuns_het, 
  file = runsFilename, 
  quote = F, 
  sep = delim)

imgFilename <- paste0(outDirROHet, prjName, ".manhattanRuns_ROHet.png")
png(imgFilename, imgXSize, imgYSize, pointsize = snpPointSize)
plot_manhattanRuns(
  runs = consecutiveRuns_het,
  genotypeFile = genotypeFilePath, 
  mapFile = mapFilePath)
dev.off()


#################################################################
#
# Distribution of inbreeding coefficients per chromosome and/or group
#
#################################################################

plotIC <- function(style) {
  imgFilename <- paste0(outDirROHet, prjName, "." , style , ".InbreedingChr_ROHet.png")
  png(imgFilename, imgXSize, imgYSize, pointsize = snpPointSize)
  plot_InbreedingChr(
    runs = consecutiveRuns_het, 
    mapFile = mapFilePath, 
    style = style)
  dev.off()
}

plotStyles <- 
  c("ChrBarPlot",
    "ChrBoxPlot", 
    "FrohBoxPlot")

sapply(plotStyles, plotIC)

## reset message sink and close the file connection
sink(type="message")
sink()
close(logFile)

