read_data <- function(path, sep, id, chrom, beta, se = NA, var = NA){
	tmp <- read.table(path, sep = sep, header=TRUE, stringsAsFactors = FALSE)
	if(!all(c(id, chrom, beta) %in% colnames(tmp))){stop("some column name parameters do not match")}
	if(!is.na(se)){
        	W = (tmp[,se]^2)^(-1)
        } else if (!is.na(var)){
		W = (tmp[,var])^(-1)
	} else {"please provided column name information for either 'var' (variance) or 'se' (standard error), default is se"}
	df <- data.frame("id" = paste0(tmp[,id],":",tmp[,chrom]), "W" = W, "X" = tmp[,beta], "chrom" = tmp[,chrom], "cohort" = path, stringsAsFactors = FALSE)
        df <- na.omit(df)
	return(df)
}

setup_ma <- function(files, sep = "\t", id = "ID", chrom = "CHROM", beta = "BETA", se = NA, var = NA){
	if(class(files) == "character"){
		check <- lapply(files, function(x) exist(x))
		if(!all(check)){stop("one file path provided does not exist", files[!check])}
	} else {stop("expecting files of class 'character'")}
	df <- read_data(files[1], sep, id, chrom, beta, se, var)
	if(length(files) > 1){
		for(x in 2: length(files)){
			df2 <- read_data(files[x], sep, id, chrom, beta, se, var)
			df <- rbind(df, df2, by="id") %>% na.omit()
		}
	}
	return(df)
}

