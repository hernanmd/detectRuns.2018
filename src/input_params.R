#################################################################
#
#     Input parameters
#
#################################################################

# Used for prefix files
prjName <- "CRSAAV"
# Output directory
outDirROHom <- "CRSAAV.ROHom.out/"
outDirROHet <- "CRSAAV.ROHet.out/"
# Log file names
logFileROHom <- paste0(outDirROHom, "logROHom.Rout")
logFileROHet <- paste0(outDirROHet, "logROHet.Rout")
# Input files
genotypeFilePath <- "CRSAAV.ped"
mapFilePath <- "CRSAAV.map"
maxChr <- 29

# Output files separator
delim <- "\t"
# Get current script directory (only works outside RStudio)
cwd <- dirname(sys.frame(1)$ofile)

# Exported image X/Y size
imgXSize <- 1000
imgYSize <- 700
snpPointSize <- 20

#################################################################
#
#     consecutiveRUNS.run parameters
#
#################################################################
minLengthBpsParam <- 500000
minSNPParam <- 25
topRunsThreshold <- 0.5
# Depends of density of Microarray chip
# 0 by default (55k or lower Chip)
maxOppRun = 1
maxMissRun = 1

#################################################################
#
#     summaryRuns parameters
#
#################################################################
# Group of length (in Mbps) by class (default: 0-2, 2-4, 4-8, 8-16, >16)
summaryClass <- 6
