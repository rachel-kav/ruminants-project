library(ape)

folder_name <- "/Users/qjs599/Desktop/ruminants/ruminants_project/data/dn_erable_output_16.09" # nolint

nwk_files <- list.files(path = folder_name, pattern = "\\.nwk$", full.names = TRUE)
dn_trees <- lapply(nwk_files, read.tree)
gene_names <- sub("_erable_dn\\.length$", "", tools::file_path_sans_ext(nwk_files)) 
names(dn_trees) <- gene_names
class(dn_trees) <- "multiPhylo"

folder_name2 <- "/Users/qjs599/Desktop/ruminants/ruminants_project/data/ds_erable_output_16.09"

nwk_files2 <- list.files(path = folder_name2, pattern = "\\.nwk$", full.names = TRUE)
ds_trees <- lapply(nwk_files2, read.tree)
gene_names2 <- sub("_erable_ds\\.length$", "", tools::file_path_sans_ext(nwk_files))
names(ds_trees) <- gene_names2
class(ds_trees) <- "multiPhylo"

matching_genes <- intersect(names(dn_trees), names(ds_trees))
dntrs <- dn_trees[matching_genes]
dstrs <- ds_trees[matching_genes]

save(dn_trees, ds_trees, dntrs, dstrs, file="/Users/qjs599/Desktop/ruminants/ruminants_project/data/alltrs.Rdata")
