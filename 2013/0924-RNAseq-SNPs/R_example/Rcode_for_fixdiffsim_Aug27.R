# performs 10000 draws from the binomial distribution for each transcript, given
# the lengths of the transcripts (transcrlens input)

# create an empty matrix with a row for each transcript and 10000 columns for the 
# trials.  One for the Autosomes and one for the X

setwd("yourworkingdir")

infile <- read.table("transcrlens.txt", header = FALSE)
transcrlens <- infile$V1

outmatA <- matrix(data=0,nrow=1163,ncol=10000)
outmat <- matrix(data=0,nrow=1163,ncol=10000)

j=0
# 0.000707563 is the per basepair rate of fixed differences on X linked genes
for (i in transcrlens){
	outmat[j,] <- rbinom(10000,i,0.000707563)
	j <- j+1
}
# 0.000707563 is the per basepair rate of fixed differences on Autosomal genes

for (i in transcrlens){
	outmatA[j,] <- rbinom(10000,i,1.75518E-06)
	j <- j+1
}

# create arrays that will average across the trials for each gene

Xavgs <- seq(length=10000,from=0,by=0)

for (i in 1:1218)  {
	Xavgs[i] <- mean(outmat[i,])
}

Aavgs <- seq(length=1218,from=0,by=0)

for (i in 1:1218)  {
	Aavgs[i] <- mean(outmatA[i,])
}

# create matrixes that will hold count data - we are deriving the number of 
# times that 0, 1, 2, 3, etc fixed differences were found in a single gene
# The ncol = 17 was set because looking at the resutls of my X simulation, there
# was one trial where 17 fixed differences fell into a single gene.  In the A
# simulation the highest was 3.

countsmat <- matrix(data=0,nrow=10000,ncol=17)
countsmat[1,]
countsmatA <- matrix(data=0,nrow=10000,ncol=3)

#example...  use the hist function to find the distribution of counts for each
# of the 10000 simulations...  then put those into the output matrix

histtemp <- hist(outmat[,3412],seq(0,max(outmat)+1))
histtemp$counts


for (i in 1:10000)  {
	histtemp <- hist(outmat[,i],seq(-0.5,max(outmat)+1,1),plot = FALSE)	
	countsmat[i,] <- histtemp$counts
}

for (i in 1:10000)  {
	histtemp <- hist(outmatA[,i],seq(-0.5,max(outmatA)+1,1),plot = FALSE)	
	countsmatA[i,] <- histtemp$counts
}

write.table(outmat,file="Xdata.txt")
write.table(outmatA,file="Adata.txt")  # all of the raw data

write.table(countsmat,file="Xcounts.txt",sep="\t")
write.table(countsmatA,file="Acounts.txt",sep="\t")   # the count data