ivwa <- function(df, snp_id="id", weight="W", ef_size="X"){
	if(!c(snp_id,weight,ef_size) %in% colnames(df)){
		stop("column names provided to not match column names in the dataframe.")
	} else if(snp_id !="id" & weight != "W" & ef_size != "X") {
		colnames(df) <- colnames(df) %>% 
			gsub(snp_id, "id", .) %>%
			gsub(weight, "W", .) %>%
			gsub(ef_size, "X", .) 
	}
	
	results <- df %>%
		group_by(id) %>%
		summarise(
			n = n(),
			beta = sum(as.numeric(W)*as.numeric(X))/sum(as.numeric(W)),
			z_score = sum(as.numeric(X)*as.numeric(W))/sqrt(sum(as.numeric(W))),
			p_val = 2*pnorm(-abs(sum(as.numeric(X)*as.numeric(W))/sqrt(sum(as.numeric(W))))),
		) %>%
		na.omit()
	results <- results[results$n == max(results$n),]
	results$n <- NULL
	return(results)
}
