# detectRuns Workflow Script version 1.0
# Authors: Hernan Morales
# Date: 
#
# Input Files:
#   PED/MAP file(s) 
# Output Files:
#   PNG of SNPs in Runs

# Install packages on demand
list.of.packages <- c("detectRUNS")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='http://cran.us.r-project.org')

library(detectRUNS)
#help(detectRUNS)
#genotypeFilePath <- "Kijas2016_Sheep_subset.ped"
#mapFilePath <- "Kijas2016_Sheep_subset.map"

#
# Input parameters
#

# Used for prefix files
prjName <- "Crsaav"
maxChr <- 29
imgXSize <- 1500
imgYSize <- 1000
setwd("C:\\Hernan\\detectRuns.2018\\src")
genotypeFilePath <- "pedmaps\\CRSAAV.ped"
mapFilePath <- "pedmaps\\CRSAAV.map"

# Sliding-window parameters are: 
# windowSize, 
# threshold (to call a SNP "in run"), 
# minSNP (minimum number of homozygous/heterozygous SNP in the window), 
# maxOppWindow (maximum number of SNP with opposite genotype: heterozygous/homozygous) and 
# maxMissWindow (maximum number of missing genotypes).
slidingRuns <- slidingRUNS.run(
  genotypeFile = genotypeFilePath, 
  mapFile = mapFilePath, 
  windowSize = 15, 
  threshold = 0.05,
  minSNP = 20, 
  ROHet = FALSE, 
  maxOppWindow = 1, 
  maxMissWindow = 1,
  maxGap = 10^6, 
  minLengthBps = 250000, 
  minDensity = 1/10^3, # SNP/kbps
  maxOppRun = NULL,
  maxMissRun = NULL
) 

# By setting ROHet=TRUE, runs of heterozygosity (a.k.a. heterozygosity-rich genomic regions) are detected instead. Again, the usert can choose whether to use the sliding-window or the consecutive method.
# Search genomic blocks which the homozigocity is null. These blocks may contain lethal genes.
slidingRuns_het <- slidingRUNS.run(
  genotypeFile = genotypeFilePath, 
  mapFile = mapFilePath, 
  windowSize = 10, 
  threshold = 0.05,
  minSNP = 10, 
  ROHet = TRUE, 
  maxOppWindow = 2, 
  maxMissWindow = 1,
  maxGap = 10^6, 
  minLengthBps = 10000, 
  minDensity = 1/10^6, # SNP/kbps
  maxOppRun = NULL,
  maxMissRun = NULL
) 

# The function summaryRuns() takes in input the dataframe with results from runs detection and calculates a number of basic descriptive statistics on runs. Additional necessary parameters are the paths to the Plink ped and map files. Class and snpInRuns are optional arguments.

summaryList <- summaryRuns(
  runs = slidingRuns, 
  mapFile = mapFilePath, 
  genotypeFile = genotypeFilePath, 
  Class = 6, 
  snpInRuns = TRUE)

# Plot SNPs in Runs
for (chr in 1:maxChr){
  imgFilename <- paste0("snpsInRuns-chr", chr ,".png")
  png(imgFilename, imgXSize, imgYSize, pointsize = 20)
  plot_SnpsInRuns(
    runs = slidingRuns[slidingRuns$chrom==chr,], 
    genotypeFile = genotypeFilePath, 
    mapFile = mapFilePath)
  dev.off()
}

# We can see from the plots above, that in the Jacob sheep breed a region with a "peakk"" of ROH can be spotted approximately halfway on chromosome 2 (OAR2) in the Jacob breed. This corresponds to the strong GWAS signals found by Kijas et al. (2016) on OAR2 associated with the four-horns phenotype.

# To identify the position of a runs (ROH in this case) peak, e.g. from plot_SnpsInRuns(), one can conveniently use the function detectRUNS::tableRuns(): this requests as input, besides the runs dataframe, also the paths to the original ped/map files, and the threshold above which we want information on such "peaks" (e.g. only peaks where SNP are inside runs in more than 70% of the individuals in that population/group). 
topRuns <- tableRuns(
  runs = slidingRuns, 
  genotypeFile = genotypeFilePath, 
  mapFile = mapFilePath, 
  threshold = 0.7)


# The information on the proportion of times each SNP falls inside a run, can also be plotted against SNP positions in all chromosomes together, similarly to the familiar GWAS Manhattan plots:
runsFilename <- paste0(prjName,".sliding.csv") 
write.table(x = slidingRuns, file = runsFilename, quote = F, sep = ";")
runsDF <- readExternalRuns(inputFile = runsFilename, program = "detectRUNS")
#   runs = slidingRuns[slidingRuns$group=="Jacobs",], 

plot_manhattanRuns(
    runs = runsDF,
    genotypeFile = genotypeFilePath, 
    mapFile = mapFilePath,
    outputName = "Manhattan.png",
    plotTitle = "Titulo")

head(
  Froh_inbreeding(
    runs = slidingRuns,
    mapFile = mapFilePath,
    genome_wide = TRUE))

plot_InbreedingChr(
  runs = slidingRuns, 
  mapFile = mapFilePath, 
  style = "FrohBoxPlot")