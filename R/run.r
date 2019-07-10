library(dplyr)

run_ivwa:<- function(df, snp_id="id", weight="W", ef_size="X", parallel = FALSE, cores=NA){
	if(parallel == TRUE){
		if(cores==NA){stop("if paralelle chosen please choose number of cores desired")}
		library(foreach)
		library(doParallel)
		registerDoParallel(cores)
		restults <- foreach(df.chunk = chunk(df,from = 1, to = nrow(df), by = ceiling(nrow(df)/cores)), .combine=rbind)%dopar%{
			tmp <- df[df.chunk[1]:df.chunk[2],]
			res <- ivwa(tmp)
			return(res)
		}
		return(results)
	} else if(parallel == FALSE){
		results <- ivwa(df)
		return(results)
	}
}

full_pipeline <- function(files, sep = "\t", id = "ID", chrom = "CHROM", beta = "BETA", se = NA){
	df <- setup_ma(files, sep = sep, id = id, chrom = chrom, beta = beta, se = se)
	res <- run_ivwa(df=df)
	return(res)
}
