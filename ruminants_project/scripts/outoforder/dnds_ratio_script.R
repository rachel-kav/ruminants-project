
library(ape)

trees <- "/Users/macbook/Desktop/Phylogenetics/ruminants/ruminants_project/data/dnds_trees.Rdata"

load(trees)

ratio_trees <- list()
epsilon <- 1e-6

gene_list <- names(dn_trees_clean)

for (gene in gene_list) {
  dn_tree <- dn_trees_clean[[gene]]
  ds_tree <- ds_trees_clean[[gene]]
  
  if (!all(dn_tree$edge == ds_tree$edge)) {
    warning(paste("Topology mismatch in", gene))
    next
  }

  ds_lengths <- ds_tree$edge.length
  ds_lengths[ds_lengths <= 0] <- epsilon

  dn_lengths <- dn_tree$edge.length
  dn_lengths[dn_lengths <= 0] <- epsilon

  ratio_lengths <- dn_lengths / ds_lengths

  if (any(!is.finite(ratio_lengths))) {
    next 
  }
  ratio_tree <- dn_tree
  ratio_tree$edge.length <- ratio_lengths
  ratio_trees[[gene]] <- ratio_tree
}

ratio_trees <- Filter(Negate(is.null), ratio_trees)
class(ratio_trees) <- "multiPhylo"


################
tree_list <- ratio_trees

# Compute total branch length for each tree
total_lengths <- sapply(tree_list, function(tr) sum(tr$edge.length, na.rm = TRUE))

# Inspect distribution
summary(total_lengths)
hist(total_lengths, main = "Total Tree Lengths", xlab = "Sum of Branch Lengths")

# Filter out trees with low total branch length (e.g., < 0.01)
min_signal_threshold <- 1e3
ratio_trees_filtered <- tree_list[total_lengths <= min_signal_threshold]

# Check how many were removed
cat(length(tree_list) - length(ratio_trees_filtered), "trees removed due to low signal.\n")

# Reassign class
class(ratio_trees_filtered) <- "multiPhylo"

###############


save(ratio_trees, ratio_trees_filtered, file="/Users/macbook/Desktop/Phylogenetics/ruminants/ruminants_project/data/clean_dnds_ratio_trees.Rdata")
