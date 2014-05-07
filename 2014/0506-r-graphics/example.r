# For demo only.
# Please refer to Paul Murrells R Graphics for precise and detailed info.

set.seed(55)
true.expr = round(exp(rgamma(5000, shape=5, rate=1)))
names(true.expr) = paste("gene_", 1:length(true.expr))
head(true.expr)

# ---- D. melanogaster data 
melan.fem = true.expr
mal.scal = rep(c(4, 0.25, 1), c(500, 500, 4000))
melan.mal = true.expr * mal.scal
col.melan.sex = ifelse(mal.scal==4, "red", 
                       ifelse(mal.scal==0.25, "yellow", "gray40"))
table(col.melan.sex)

# ---- D. persimilis data
pers.fem = true.expr * rep(c(2, 1), c(200, 4800))
pers.mal = true.expr * rep(c(4, 0.25, 2, 1), c(500, 200, 300, 4000))
fc = rep(c(4, 0.25, 2, 1), c(500, 200, 300, 4000)) / rep(c(2, 1), c(200, 4800))
table(fc)
col.pers.sex = ifelse(fc==0.25, "blue", 
                       ifelse(fc==2, "green", 
                              ifelse(fc==4, "gray60", "gray40")))
table(col.pers.sex)

# --- Plot real expression levels
# (x, y) plot: difficult to read 
plot(log2(melan.fem), log2(melan.mal),
     col=col.melan.sex,
     main="melan.fem - melan.mal = 0 ?")

plot(log2(pers.fem), log2(pers.mal),
     col=col.pers.sex, 
     main="pers.fem - pers.mal = 0 ?")

# MA-plot: Easy to interpret vertical deviation
M = log2(melan.fem) - log2(melan.mal)
A = 0.5*(log2(melan.mal) + log2(melan.mal))
plot(A, M, col=col.melan.sex,
     main="melan.fem - melan.mal = 0 ?")

M = log2(pers.fem) - log2(pers.mal)
A = 0.5*(log2(pers.fem) + log2(pers.mal))
plot(A, M, col=col.pers.sex,
     main="melan.fem - melan.mal = 0 ?")

# Add noise
melan.fem.x = rnbinom(length(melan.fem), mu=melan.fem, size=1/0.1)
melan.mal.x = rnbinom(length(melan.mal), mu=melan.mal, size=1/0.1)

# (x, y) plot: difficult to read 
plot(log2(melan.fem.x), log2(melan.mal.x),
     col=densCols(log2(melan.fem.x), log2(melan.mal.x)),
     cex=0.3, pch=19)
points(log2(melan.fem.x)[1:1000], log2(melan.mal.x)[1:1000],
       col=col.melan.sex[1:1000], cex=0.8)
abline(a=0, b=1, col="red")

# MA-plot: Easy to interpret vertical deviation
M = log2(melan.fem.x) - log2(melan.mal.x)
A = 0.5*(log2(melan.mal.x) + log2(melan.mal.x))
plot(A, M, col=densCols(A, M), pch=19, cex=0.3)
points(A[1:1000], M[1:1000], col=col.melan.sex[1:1000],
       cex=0.8)
abline(h=c(-2, -1, 0, 1, 2), lty=c(3, 2, 1, 2, 3))
box("figure", col="red")

# change background
plot(0, 0, 
     ylim=c(-4.5, 4.5),
     xlim=c(0, 25),
     col=densCols(A, M), pch=19, cex=0.3,
     main="melan.fem - melan.mal = 0 ?")

rect(par("usr")[1],
     par("usr")[3],
     par("usr")[2],
     par("usr")[4], 
     col="gray30")

points(A, M, col=densCols(A, M), pch=19, cex=0.5)
points(A[1:1000], M[1:1000], col=col.melan.sex[1:1000])
abline(h=c(-2, -1, 0, 1, 2), lty=c(2, 2, 1, 2, 2),
       col="gray80")
box("figure", col="red")

# change margin
par("mar") # see default
par(mar=c(2.5, 2.5, 1, 0.5)) 
plot(A, M, col=densCols(A, M), pch=19, cex=0.3,
     main="melan.fem - melan.mal = 0 ?",
     xaxt="none", yaxt="none",
     xlab="", ylab="")

rect(par("usr")[1],
     par("usr")[3],
     par("usr")[2],
     par("usr")[4], 
     col="gray30")

points(A, M, col=densCols(A, M), pch=19, cex=0.5)
points(A[1:1000], M[1:1000], col=col.melan.sex[1:1000])
abline(h=c(-2, -1, 0, 1, 2), lty=c(2, 2, 1, 2, 2),
       col="gray80")
box("figure", col="red")

# x ---margins
axis(side=1, at=seq(0, 25), labels=FALSE)
mtext(text=seq(0, 25), side=1, line=0.5, 
      at=seq(0, 25),
      cex=0.5)
mtext(text="average expr", side=1, line=1.2, cex=0.8)

# y ---margins
axis(side=2, at=seq(-4.5, 4.5), labels=FALSE)
mtext(text=seq(-4.5, 4.5), side=2, line=0.5, 
      at=seq(-4.5, 4.5),
      cex=0.5)
mtext(text="log FC", side=2, line=1.2, cex=0.8)

# add legend
rect(21, 3.7, 24.5, 4.8, col="white", cex=0.8)
points(24, 4.5, pch=19, col="yellow", cex=0.8)
points(24, 4, pch=19, col="red")
text(24, 4.5, "fem baised", pos=2, cex=0.5)
text(24, 4, "mal baised", pos=2, cex=0.5)

box("figure", col="red")
