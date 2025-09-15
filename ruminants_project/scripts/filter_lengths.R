library(ape)

setwd("/Users/macbook/Desktop/Phylogenetics/ruminants/ruminants_project")

trees <- "data/dnds_trees.Rdata"
load(trees)
rum <- read.tree("data/rumsptimetr.nwk")

#standardise tree
rum$edge.length <- rum$edge.length / sum(rum$edge.length)
#unroot tree
rum_unroot <- unroot(rum)

filter_lengths <- function(gene_tree, time_tree) {
  # Sanity check: edge counts must match
  if (length(gene_tree$edge.length) != length(time_tree$edge.length)) {
    stop("Tree and time tree edge lengths do not match in size.")
  }

  gene_edge <- gene_tree$edge.length
  time_edge <- time_tree$edge.length
  
  # Identify good and bad branches
  is_bad <- gene_edge <= 0 | is.na(gene_edge)
  is_good <- !is_bad
  
  # Mean of good branches
  mean_good <- mean(gene_edge[is_good])
  
  # Replace bad branches
  gene_edge[is_bad] <- mean_good * time_edge[is_bad]
  
  gene_tree$edge.length <- gene_edge
  return(gene_tree)
}

dn_filtered_trees <- lapply(dn_trees_clean, filter_lengths, time_tree = rum_unroot)
class(dn_filtered_trees) <- "multiPhylo"
ds_filtered_trees <- lapply(ds_trees_clean, filter_lengths, time_tree = rum_unroot)
class(ds_filtered_trees) <- "multiPhylo"

save(dn_filtered_trees, ds_filtered_trees, file="data/dnds_filtered_trees.Rdata")

