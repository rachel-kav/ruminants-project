library(MASS) 
library(ape) 
trees <- "data/dnds_ratio_trees.Rdata" 
load(trees) 
rum <- read.tree("data/rumsptimetr.nwk") 
branch_lengths <- unlist(lapply(ratio_trees, function(t) t$edge.length)) 
fit <- fitdistr(branch_lengths, "gamma") #fit gamma distrib 
shape <- fit$estimate["shape"] 
rate <- fit$estimate["rate"] # 95% quantile 
threshold <- qgamma(0.95, shape = shape, rate = rate) 
collapse_extreme_branches <- function(trees, time_tree, threshold) 
{ # Standardize and unroot the time tree 
time_tree$edge.length <- time_tree$edge.length / sum(time_tree$edge.length) time_tree <- unroot(time_tree) 
collapsed_trees <- lapply(trees, function(tree) 
{ if (length(tree$edge.length) != length(time_tree$edge.length)) 
{ warning("Edge length mismatch between gene tree and time tree. Skipping tree.") return(tree) } 
gene_edge <- tree$edge.length 
time_edge <- time_tree$edge.length 
# Identify extreme branches 
is_extreme <- gene_edge > threshold is_valid <- !is_extreme & !is.na(gene_edge) & gene_edge > 0 
if (sum(is_valid) == 0) { warning("No valid branches to compute mean. Skipping replacement.") return(tree) } 
mean_valid <- mean(gene_edge[is_valid]) 
# Replace extreme branches using scaled time tree 
gene_edge[is_extreme] <- mean_valid * time_edge[is_extreme] 
tree$edge.length <- gene_edge return(tree) }) 
return(structure(collapsed_trees, class = "multiPhylo")) } 

clean_trees <- collapse_extreme_branches(ratio_trees, rum, threshold) 
save(clean_trees, file="data/clean_dnds_trees.Rdata")
