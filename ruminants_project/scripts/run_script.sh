#!/bin/bash

#extracting dn and ds using codeml and paml -server
#./clean_dnds_paml_script-23.07.25.sh 

#creating dn and ds matrices from the extracted dn and ds values
#cd /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/dnds_pml
#./dn_dist_mat_script.sh
#./ds_dist_mat_script.sh

#running erable on dn and ds matrices
#cd /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/dnds_pml
#./run_erable_script.sh
#./run_ds_erable_script.sh  

#grouping and copying erable output files to separate folders
#cd /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/dnds_pml
#./erable_folder_dn.sh
#./erable_folder.sh

#moving erable output files to separate folders
#/Users/qjs599/Desktop/ruminants/ruminants_project/scripts/dnds_pml
#./erable_folder_dn.sh
#./erable_folder.sh

#converting to multiphylo object
cd /Users/qjs599/Desktop/ruminants/
Rscript /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/nwks_scripts.R	

#10/0925
#running R scripts for further analysis and plotting
#Rscript /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/nwks_scripts.R	

#Rscript /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/filter_lengths.R

#Rscript /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/dnds_ratio_script.R

#cd /Users/qjs599/Desktop/ruminants/
#Rscript /Users/qjs599/Desktop/ruminants/ruminants_project/scripts/clean_trees_script.R
