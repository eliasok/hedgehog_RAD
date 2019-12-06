# Adegenet
# available here: https://github.com/bcm-uga/TESS3_encho_sen
# export data as a matrix (012) by vcftools:
#
# vcftools --vcf ErinMaxMiss63_r10e10c4.vcf --012 --out erinaceus
#
# prepare data (Adegenet requires NA mark for missing data, but f.e. vcftools creates 
# format 012 with missing data marked as -1)
#
# sed -i 's/-1/NA/g' erinaceus.012
#
# to cut first column doesnt containig SNP data
# awk '{$1=""; print $0}' erinaceus.012 > SNP
#
# open R
# get Adegenet package:

install.packages("adegenet", dep=TRUE)

# get libraries:

library("ape")
library("pegas")
library("seqinr")
library("ggplot2")

# get Adegenet library:

library("adegenet")

# export data to genelight object and avoid read the first column of a file (which is integer!) as a SNP:

SNP <- read.csv(file="SNP", header=FALSE, sep=" ", colClasses=c("NULL", rep("integer", 125299)))

# to create new object z:

z <- new("genlight", SNP)

# load individual names:
indNames(z)
indNames(z)[1] <- "newLocusName" # to add names one by one
# or add as a file, first necessary to transponate the original indiv file in bash
# awk '{RS=OFS;$1=$1}1' indiv > indiv.reverse
# necessary to check first line
# then in R:
indNames(z) <- as.matrix(read.table("indiv.reverse", sep=" "))
# add position
positions <- read.table("erinaceus.012.pos", header=FALSE, col.names=c("chr", "pos"))
chromosome(z) <- positions$chr
position(z) <- positions$pos

# principal component analysis:

pca1 <- glPca(z)

scatter(pca1, posi="bottomleft", grid=3, bg="#ebebeb", transp=TRUE)
title("Erinaceus")


# pca1$eig shows eigenvalues
# sum(pca1$eig) shows sum of eigenvalues
# pca1$eig[PC axe I wanna know]/sum(pca1$eig)
# e.g.:pca1$eig[1]/sum(pca1$eig) for first PC

# number of axis:(x)

scatter(pca1, posi="bottomleft")
ordiplot(pca1,type="none") # udela graf bez bodu
# locator(n = 20, type = "n") it tells coordinates of each dot
# it will do dots and legends, specifies paramentr air
orditorp(pca1,display = "sites",pch=3, air=3)
# show me coordinates of individuals
scores(pca1)


myCol <- colorplot(pca1$scores,pca1$scores, transp=TRUE, cex=4)
abline(h=0,v=0, col="grey")
title("")

# plotting NJ tree

library(ape)
tre <- nj(dist(as.matrix(z)))

plot(tre, typ="phylogram", cex=0.9)
title("Erinaceus")

plot(tre, typ="fan", show.tip=FALSE)
tiplabels(pch=20, col=myCol, cex=4)
title("Erinaceus_tree_color")

# to visualize SNP index of each individual:

glPlot(z, col=bluepal(3))

glPlot(z, posi="topleft")

# to count discrimant component analysis, individuals need to be sorted to populations. To find populations via find.clusters:

grp <- find.clusters(z, n.clust=NULL, n.pca=3, max.n.clust=10, stat=("BIC"))

plot(grp$Kstat, type="b", col="blue")
title("Erinaceus clusters")

# if populations known, must be placed to genelight object:

population <- read.table("popmap.txt", header=FALSE, col.names=c("indv", "pop"))
pop(z) <- population$pop

# counting DPCA: 
dapc1 <- dapc(z)
# number PCa retain: 3 (tricky part)

# plot DPCA:

scatter(dapc1,scree.da=FALSE, bg="white", posi.pca="topright", col=c("red","blue"))
title("Erinaceus DAPC")


myCol <- c("red","blue","green", "green","purple")

scatter(dapc1, bg="white", pch=17:22, cstar=0, col=myCol, scree.pca=TRUE, posi.pca="bottomleft")

scatter(dapc1, scree.da=FALSE, bg="white", pch=20, cell=0, cstar=0, col=myCol,
cex=3,clab=0, leg=TRUE, txt.leg=paste("Cluster",1:2))

scatter(dapc1, ratio.pca=0.3, bg="white", pch=20, cell=0,
cstar=0, col=myCol, solid=.4, cex=3, clab=0,
mstree=TRUE, scree.da=FALSE, posi.pca="bottomright",
leg=TRUE, txt.leg=paste("Cluster",1:2))

scatter(dapc1,1,1, col=myCol, bg="white",
scree.da=FALSE, legend=TRUE, solid=.4)

# posterior membership probabilities. manual: "Note that this is most useful for groups defined by an external
# criteria, i.e. defined biologically, as opposed to identified by k-means. It is less useful for
# groups identified using find.clusters, since we expect k-means to provide optimal groups
# for DAPC, and therefore both classifications to be mostly consistent. Membership probabilities are based on the retained discriminant #functions. They are stored in dapc objects in the slot posterior: class(dapc1$posterior)" the values are stored in $assign.per.pop
# accessible: summary(dapc1). To plot:

assignplot(dapc1, subset=1:22)

compoplot(dapc1, posi="bottomright",
txt.leg=paste("Cluster", 1:2), lab="",
ncol=1, xlab="individuals", col=funky(3))






