
setwd("/Users/qjs599/Desktop/ruminants/ruminants_project")
trees <- "data/dnds_ratio_trees.Rdata"
load(trees)

library(MASS)
library(ape)

rum <- read.tree("data/rumsptimetr.nwk")

# removing the trees with >5 extremely long branches
threshold_tree <- 50
max_extreme_branches <- 5

trees_to_keep <- sapply(ratio_trees, function(tree) {
  sum(tree$edge.length > threshold_tree, na.rm = TRUE) <= max_extreme_branches
})

clean_trees <- ratio_trees[trees_to_keep]
clean_lengths <- unlist(lapply(clean_trees, function(t) t$edge.length))

#remove 99th percentile
capped_lengths <- quantile(clean_lengths, 0.98, na.rm = TRUE)
# add small constant to avoid zeros
filtered_lengths <- pmin(clean_lengths, capped_lengths)

#replace clean trees with new lengths
pos <- 1

for (i in seq_along(clean_trees)) {
  n_edges <- length(clean_trees[[i]]$edge.length)
  clean_trees[[i]]$edge.length <- filtered_lengths[pos:(pos + n_edges - 1)]
  pos <- pos + n_edges
}

# Make sure it's a multiPhylo object
filtered_trees <- structure(clean_trees, class = "multiPhylo")

# Fit a gamma distribution to the filtered lengths
fit <- fitdistr(filtered_lengths, "gamma")
threshold <- qgamma(0.95, fit$estimate["shape"],
                    fit$estimate["rate"]) * mean(filtered_lengths)
hist(filtered_lengths, breaks = 50)
summary(filtered_lengths)

collapse_extreme_branches <- function(trees, time_tree, threshold) {
  # Standardize and unroot the time tree
  time_tree$edge.length <- time_tree$edge.length / sum(time_tree$edge.length)
  time_tree <- ape::unroot(time_tree)

  collapsed_trees <- lapply(trees, function(tree) {
    if (length(tree$edge.length) != length(time_tree$edge.length)) {
      warning("Edge length mismatch between gene and time tree. Skipping tree.")
      return(tree)
    }

    gene_edge <- tree$edge.length
    time_edge <- time_tree$edge.length

    # Identify extreme branches
    is_extreme <- gene_edge > threshold
    is_valid <- !is_extreme & !is.na(gene_edge) & gene_edge > 0

    if (sum(is_valid) == 0) {
      warning("No valid branches to compute mean. Skipping replacement.")
      return(tree)
    }

    mean_valid <- mean(gene_edge[is_valid])

    # Replace extreme branches using scaled time tree
    gene_edge[is_extreme] <- mean_valid * time_edge[is_extreme]

    # **Update tree edge lengths**
    tree$edge.length <- gene_edge

    # **Return the modified tree**
    (tree)
  })

  # Return as multiPhylo object
  structure(collapsed_trees, class = "multiPhylo")
}

cleaned_dnds_trees <- collapse_extreme_branches(filtered_trees, rum, threshold)

save(cleaned_dnds_trees, file = "outputs/clean_dnds_trees.Rdata")