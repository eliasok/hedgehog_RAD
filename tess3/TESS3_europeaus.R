# TESS3
# Performs spatial clustering of individuals
# available here: https://github.com/cayek/TESS3/tree/master/tess3r


install.packages(c("fields","RColorBrewer","mapplots"))
source("http://bioconductor.org/biocLite.R")
biocLite("LEA", dependencies=T)

install.packages("devtools", dependencies = TRUE)
devtools::install_github("bcm-uga/TESS3_encho_sen")

library(LEA)
library(mapplots)
library(RColorBrewer)
library(fields)
library(maps)
library(tess3r)


source("http://membres-timc.imag.fr/Olivier.Francois/Conversion.R")
source("http://membres-timc.imag.fr/Olivier.Francois/POPSutilities.R")

# SNP data
# populations stacks converts the data into to structure format
# other necessary changes: to remove first two lines (sed -i 1,2d filename), 
# second column (sed -i -r 's/\S+//2' filename) and change missing data to -9 (sed -i 's/0/-9/g' filename)


struct2geno(file = "EuropaeusMaxMiss63.recode.p.structure", TESS = FALSE, diploid = TRUE, FORMAT = 2,
            extra.row = 0, extra.col = 1, output = "europaeus.geno")



obj.at = snmf("europaeus.geno", K = 1:10, ploidy = 2, entropy = T, CPU = 1, project = "new")
plot(obj.at, col = "blue4", cex = 1.4, pch = 19)


qmatrix = Q(obj.at, K = 3)

#if I have no ascii

source("POPSutilities.r")

asc.raster="http://membres-timc.imag.fr/Olivier.Francois/RasterMaps/Europe.asc"
grid=createGridFromAsciiRaster(asc.raster)
constraints=getConstraintsFromAsciiRaster(asc.raster, cell_value_min=0)
coord.at = read.table("eur_coord.txt")

plot(coord.at, pch = 19,  xlab= "Longitude", ylab = "Latitude")
map(add = T, interior = F, col = "white")

grid=createGrid(-27.00, 19.00, 37.00, 55.50, 1000, 1000)

lColorGradients = list( c("gray95",brewer.pal(9,"Blues")),
  c("gray95",brewer.pal(9,"Purples")),
  c("gray95",brewer.pal(9,"Reds")),
  c("gray95",brewer.pal(9,"YlOrBr")),
  c("gray95",brewer.pal(9,"RdPu")),
  c("gray95",brewer.pal(9,"Purples")),
  c("gray95",brewer.pal(9,"Greys")),
  c("gray95",brewer.pal(9,"OrRd")),
  c("gray95",brewer.pal(9,"BuPu")))



maps(matrix = qmatrix, coord.at, grid, constraints = NULL, method = "max",
     main = "Ancestry coefficients", xlab = "Longitude", ylab = "Latitude", cex = .5, colorGradientsList=lColorGradients)

map(add = T, interior = F, col = "white")

# to see ancestry coefficient

show.key = function(cluster=4,colorGradientsList=lColorGradients){
  ncolors=length(colorGradientsList[[cluster]])
  barplot(matrix(rep(1/10,10)),col=colorGradientsList[[cluster]][(ncolors-9):ncolors],main=paste("Cluster",cluster))}

par(ps = 16)
for(k in 1:9){show.key(k)}