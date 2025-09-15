library(ape)

folder_name <- "/Users/macbook/Desktop/Phylogenetics/ruminants/dnds_pml/dn_erable_output"

setwd(folder_name)
nwk_files <- list.files(pattern = "\\.nwk$")
dn_trees <- lapply(nwk_files, read.tree)
gene_names <- sub("_erable_dn\\.length$", "", tools::file_path_sans_ext(nwk_files))
names(dn_trees) <- gene_names
class(dn_trees) <- "multiPhylo"

folder_name <- "/Users/macbook/Desktop/Phylogenetics/ruminants/dnds_pml/ds_erable_output"
setwd(folder_name)
nwk_files <- list.files(pattern = "\\.nwk$")
ds_trees <- lapply(nwk_files, read.tree)
gene_names2 <- sub("_erable_ds\\.length$", "", tools::file_path_sans_ext(nwk_files))
names(ds_trees) <- gene_names2
class(ds_trees) <- "multiPhylo"

matching_genes <- intersect(names(dn_trees), names(ds_trees))
dn_trees_clean <- dn_trees[matching_genes]
ds_trees_clean <- ds_trees[matching_genes]

save(dn_trees, ds_trees, dn_trees_clean, ds_trees_clean, file="/Users/macbook/Desktop/Phylogenetics/ruminants/ruminants_project/data/dnds_trees.Rdata")
