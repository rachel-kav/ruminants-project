
library(ape)

setwd("/Users/macbook/Desktop/Phylogenetics/ruminants/ruminants_project")

trees <- "data/dnds_filtered_trees.Rdata"
load(trees)
ratio_trees <- list()

gene_list <- names(ds_filtered_trees)
  
for (gene in gene_list) {
  dn_tree <- dn_filtered_trees[[gene]]
  ds_tree <- ds_filtered_trees[[gene]]
  
  if (!all(dn_tree$edge == ds_tree$edge)) {
    warning(paste("Topology mismatch in", gene))
    next
  }
    
  ds_lengths <- ds_tree$edge.length
  dn_lengths <- dn_tree$edge.length

  ratio_lengths <- dn_lengths / ds_lengths

  if (any(!is.finite(ratio_lengths))) {
    next
  }
  ratio_tree <- dn_tree 
  ratio_tree$edge.length <- ratio_lengths
  ratio_trees[[gene]] <- ratio_tree
}

save(ratio_trees, file="data/dnds_ratio_trees.Rdata")

