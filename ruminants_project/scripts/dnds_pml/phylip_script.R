args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) stop("Usage: Rscript phylip_script.R input.rds output.txt")

input_file <- args[1]
output_file <- args[2]

mat <- readRDS(input_file)

write_phylip <- function(mat, file) {
  if (!is.matrix(mat)) stop("Input must be a matrix.")
  if (is.null(rownames(mat))) stop("Matrix must have row names.")

  taxa <- rownames(mat)
  ntaxa <- length(taxa)

  lines <- character(ntaxa + 2)
  lines[1] <- "1"
  lines[2] <- paste(ntaxa, "1")

  taxa_padded <- sprintf("%-10s", substr(taxa, 1, 10))
  
  for (i in 1:ntaxa) {
    dists <- sprintf("%.6f", mat[i, ])
    lines[i + 2] <- paste(taxa_padded[i], paste(dists, collapse = " "))
  }

  writeLines(lines, con = file)
}

write_phylip(mat, output_file)

