library("GWAS_MetaAnalysis")
args <- commandArgs( trailingOnly=TRUE )
args

if("--help" %in% args){
  cat("IVWA [requires] [optional] files \n")
  cat("do not use wildcards for the file input")
  cat("\n")
  cat("the following parameters are required: \n")
  cat("'--id' \t identifier variable name in file \n")
  cat("'--chrom' \t chromosome variable name in file \n")
  cat("'--beta' \t beta/OR variable name in file \n")
  cat("'--se' \t standard error variable name in file \n")
  cat("'--sep' \t variable seperator of the file \n")
  cat("'--out' \t output file name \n")
  cat("\n")
  cat("optional parameters")
  cat("'--cores' \t number of cores to  use \n")
}

if( "--id" %in% args ){
  id.idx <- grep("--id", args)
  id <- args[ id.idx + 1 ]
  args <- args[-c(id.idx, id.idx + 1)]
} else {
  stop("please enter the path to the identifier variable with prefix '--id'")
}

if( "--chrom" %in% args ){
  chrom.idx <- grep("--chrom", args)
  chrom <- args[ chrom.idx + 1 ]
  args <- args[-c(chrom.idx, chrom.idx + 1)]
} else {
  stop("please enter the path to the chromosome variable with prefix '--chrom'")
}

if( "--beta" %in% args ){
  beta.idx <- grep("--beta", args)
  beta <- args[ beta.idx + 1 ]
  args <- args[-c(beta.idx, beta.idx + 1)]
} else {
  stop("please enter the path to the beta/OR variable with prefix '--beta'")
}

if( "--se" %in% args ){
  se.idx <- grep("--se", args)
  se <- args[ se.idx + 1 ]
  args <- args[-c(se.idx, se.idx + 1)]
} else {
  stop("please enter the path to the standard error variable with prefix '--se'")
}

if( "--sep" %in% args ){
  sep.idx <- grep("--sep", args)
  sep <- args[ sep.idx + 1 ]
  args <- args[-c(sep.idx, sep.idx + 1)]
} else {
  stop("please enter the path to the seperator with prefix '--sep'")
}

if( "--out" %in% args ){
  out.idx <- grep("--out", args)
  out <- args[ out.idx + 1 ]
  args <- args[-c(out.idx, out.idx + 1)]
} else {
  stop("please enter the path to the output name with prefix '--out'")
}

if( "--cores" %in% args ){
  cores.idx <- grep("--cores", args)
  cores <- args[ cores.idx + 1 ]
  args <- args[-c(cores.idx, cores.idx + 1)]
  par <- TRUE
} else {
  par <- FALSE
  cores <- NA
}
args

df <- full_pipeline(files = args, sep = "\t", id = id, chrom = chrom, beta = beta, se = se, parallel = par, cores = cores)
write.table(df,out,sep="\t", row.names=FALSE)

