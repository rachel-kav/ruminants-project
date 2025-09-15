library(ape)
library(tidyverse)
library(readr)
library(phylolm)
library(devtools)
library(ClockstaRX)

setwd("/Users/macbook/Desktop/Phylogenetics/ruminants/ruminants_project")
output_dir <-"outputs"

ruminants_trees <- load("data/dnds_ratio_trees.Rdata")
rumsptimetr <- read.tree("data/rumsptimetr.nwk")

#remove outgroup
dnds_trees <- lapply(ratio_trees, function(tree) {
    drop.tip(tree, "KillerWhal")  })
rumsptimetr_filtered <- drop.tip(rumsptimetr, "KillerWhal")

dnds_ratio_clock_analysis <- diagnose.clocks(loctrs = dnds_trees, 
    sptr = rumsptimetr_filtered, 
    sp.time.tree=TRUE,
    ncore = 10,
    clustering.boot.samps = 5,
    mds = FALSE,
    pdf.file = file.path(output_dir,"dnds_ratio_ncore10_mdsf_b5.clockstarx")
    )

save(dnds_ratio_clock_analysis, file = file.path(output_dir, "dnds_ratio_clock_29.07.25.RData"))

