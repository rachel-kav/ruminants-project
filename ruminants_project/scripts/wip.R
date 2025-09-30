
library(phangorn)
library(ClockstaRX)
load("/Users/qjs599/Desktop/ruminants/ruminants_project/data/alltrs.Rdata")

dndstrs <- dntrs
for(i in 1:length(dndstrs)){
	dndstrs[[i]]$edge.length <- dndstrs[[i]]$edge.length / dstrs[[i]]$edge.length
	if(any(is.na(dndstrs[[i]]$edge.length))) dndstrs[[i]]$edge.length[which(is.na(dndstrs[[i]]$edge.length))] <- mean(dndstrs[[i]]$edge.length[which(dndstrs[[i]]$edge.length != Inf)], na.rm = T)
	if(any(is.infinite(dndstrs[[i]]$edge.length), na.rm = T)) dndstrs[[i]]$edge.length[is.infinite(dndstrs[[i]]$edge.length)] <- mean(dndstrs[[i]]$edge.length[is.finite(dndstrs[[i]]$edge.length)], na.rm = T)
    dndstrs[[i]]$edge.length[is.finite(dndstrs[[i]]$edge.length) & dndstrs[[i]]$edge.length > 10] <- 10
    dndstrs[[i]]$edge.length[is.finite(dndstrs[[i]]$edge.length) & dndstrs[[i]]$edge.length < 1e-8] <- 1e-8
}

save(dndstrs, file="/Users/qjs599/Desktop/ruminants/ruminants_project/data/dndstrs.Rdata")