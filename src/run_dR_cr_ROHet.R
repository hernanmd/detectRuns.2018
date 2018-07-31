# detectRuns Workflow Script version 1.1
# Authors: Hernán Morales
# Date: 31/7/2018
#
# Input Files:
#   PED/MAP file(s) 
# Output Files:
#   .consecutive.csv
#   snpsInRuns-chr*.png : PNG of SNPs in Runs
#   detectRUNS Manhattan Plot

# Install packages on demand
list.of.packages <- c("detectRUNS")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.us.r-project.org')

library(detectRUNS)
setwd("C:\\Hernan\\detectRuns.2018\\src")
source("input_params.R")

#################################################################
#
#     Consecutive Runs : ROHet
#
#################################################################

consecutiveRuns_het <- consecutiveRUNS.run(
  genotypeFile = genotypeFilePath,
  mapFile = mapFilePath,
  minSNP = minSNPParam,
  ROHet = FALSE,
  maxGap = 10^6,
  minLengthBps = minLengthBpsParam,
  # Depends of density of Microarray chip
  # 0 by default (55k or lower Chip)
  maxOppRun = 2,
  maxMissRun = 1
)

# The function summaryRuns() takes in input the dataframe with results from runs detection and calculates a number of basic descriptive statistics on runs. Additional necessary parameters are the paths to the Plink ped and map files. Class and snpInRuns are optional arguments.
summaryList <- summaryRuns(
  runs = consecutiveRuns_het, 
  mapFile = mapFilePath, 
  genotypeFile = genotypeFilePath, 
  Class = 6, 
  snpInRuns = TRUE)

#################################################################
#
#     Plot SNPs in Runs
#
#################################################################

for (chr in 1:maxChr){
  imgFilename <- paste0("snpsInRunsROHet-chr", chr ,".png")
  png(imgFilename, imgXSize, imgYSize, pointsize = 20)
  plot_SnpsInRuns(
    runs = consecutiveRuns_het[consecutiveRuns_het$chrom==chr,], 
    genotypeFile = genotypeFilePath, 
    mapFile = mapFilePath)
  dev.off()
}

# To identify the position of a runs (ROH in this case) peak, e.g. from plot_SnpsInRuns(), one can conveniently use the function detectRUNS::tableRuns(): this requests as input, besides the runs dataframe, also the paths to the original ped/map files, and the threshold above which we want information on such "peaks" (e.g. only peaks where SNP are inside runs in more than 70% of the individuals in that population/group). 

topRuns <- tableRuns(
  runs = consecutiveRuns_het, 
  genotypeFile = genotypeFilePath, 
  mapFile = mapFilePath, 
  # Set a lower threshold if "Error in `row.names<-.data.frame`(`*tmp*`, value = value) : invalid 'row.names' length". Defaults to 0.5  
  threshold = topRunsThreshold)

#################################################################
#
#     Manhattan Plot
#
#################################################################

# The information on the proportion of times each SNP falls inside a run, can also be plotted against SNP positions in all chromosomes together, similarly to the familiar GWAS Manhattan plots:

runsFilename <- paste0(prjName,".consecutiveROHet.csv") 
write.table(
  x = consecutiveRuns_het, 
  file = runsFilename, 
  quote = F, 
  sep = " ")

imgFilename <- paste0(prjName, ".manhattanRuns_ROHet.png")
png(imgFilename, imgXSize, imgYSize, pointsize = 20)
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
  imgFilename <- paste0(prjName, "." , style , ".InbreedingChr_ROHet.png")
  png(imgFilename, imgXSize, imgYSize, pointsize = 20)
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
