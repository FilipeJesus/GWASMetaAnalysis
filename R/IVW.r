#! /project/soft/linux64/R/R-3.4.0/bin/Rscript 
library(dplyr)
args <- c("~/scratch/Project3/Mening/UK_Cohort/UK-Cohorts.results/complete.res", "~/scratch/Project3/Mening/Spain_Cohort/Spain-Cohort.results/complete.res", "~/scratch/Project3/Mening/Central_EU_Cohort/Central-EU-Cohort.results/complete.res")

tmp <- read.table(args[1], sep = "\t", header=TRUE, stringsAsFactors = FALSE)
W = (tmp$SE^2)^(-1)
df <- data.frame("id" = paste0(tmp$ID,":",tmp$CHROM), "W" = W, "X" = tmp$BETA, "chrom" = tmp$CHROM, stringsAsFactors = FALSE)
df <- na.omit(df)
ID <- df[,"id"]
for(x in 2:length(args)){
	tmp <- read.table(args[x], sep = "\t", header=TRUE, stringsAsFactors = FALSE)
	W = (tmp$SE^2)^(-1)
	df2 <- data.frame("id" = paste0(tmp$ID,":",tmp$CHROM), "W" = W, "X" = tmp$BETA, "chrom" = tmp$CHROM, stringsAsFactors = FALSE)
	df <- rbind(df, df2, by="id") %>% na.omit()
}
cat("check 1")

results <- df %>%
		group_by(id) %>%
		summarise(
			n = n(),
			beta = sum(as.numeric(W)*as.numeric(X))/sum(as.numeric(W)),
			z_score = sum(as.numeric(X)*as.numeric(W))/sqrt(sum(as.numeric(W))),
			p_val = 2*pnorm(-abs(sum(as.numeric(X)*as.numeric(W))/sqrt(sum(as.numeric(W)))))
			chrom = chrom
		) %>%
		na.omit()
cat("check 2")
write.table(results,"meta_tmp2.tsv", sep="\t", row.names=FALSE)
