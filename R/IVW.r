library(dplyr)
#args <- commandArgs( trailingOnly=TRUE )
args <- c("~/scratch/Project3/Mening/UK_Cohort/UK-Cohorts.results/complete.res", "~/scratch/Project3/Mening/Spain_Cohort/Spain-Cohort.results/complete.res", "~/scratch/Project3/Mening/Central_EU_Cohort/Central-EU-Cohort.results/complete.res")

library(foreach)
library(doParallel)
registerDoParallel(4)

#ptm <- proc.time()
tmp <- read.table(args[1], sep = "\t", header=TRUE, stringsAsFactors = FALSE)
W = (tmp$SE^2)^(-1)
df <- data.frame("id" = paste0(tmp$ID,":",tmp$CHROM), "W" = W, "X" = tmp$BETA, stringsAsFactors = FALSE)
df <- na.omit(df)

for(x in 2:length(args)){
	tmp <- read.table(args[x], sep = "\t", header=TRUE, stringsAsFactors = FALSE)
	W = (tmp$SE^2)^(-1)
	df2 <- data.frame("id" = paste0(tmp$ID,":",tmp$CHROM), "W" = W, "X" = tmp$BETA, stringsAsFactors = FALSE)
	df <- left_join(df, df2, by="id") %>% na.omit()
}
#cat("Step 1 finished in ", proc.time() - ptm,"\n")
len <- ncol(df)
#df <- data.frame("id" = ID, "est_X" = NA, "Z_score" = NA, "P"=NA, stringsAsFactors = FALSE)
#cat("ID","\t","BETA","\t","Z_score","\t","P","\n")
results <- foreach (IDx=1:(nrow(df)), .combine=rbind) %dopar% {
	X_W <- df[IDx,]
        X <- sum(X_W[seq(2,len,2)]*X_W[seq(3,len,2)])
        W <- sum(X_W[seq(2,len,2)])
        z <- X/sqrt(W)
        p <- 2*pnorm(-abs(z))
	c(X_W[,1],X/W,z,p)
}

colnames(results) <- c("ID","BETA","Z_score","P")
write.table(results, "meta_tmp.tsv", sep="\t", row.names=FALSE)
#for(IDx in 1:nrow(df)){
#	X_W <- df[IDx,]
#	X <- sum(X_W[seq(2,len,2)]*X_W[seq(3,len,2)])
#	W <- sum(X_W[seq(2,len,2)])
#	z <- X/sqrt(W)
#	p <- 2*pnorm(-abs(z))
#	cat(X_W[,1],"\t",X/W,"\t",z,"\t",p,"\n")
#}

#cat("Step 2 finished in", proc.time() - ptm, "\n")

#write.table(df, "meta_tmp.tsv", sep="\t", row.names=FALSE)
