###################################################################
###   Converts a lims batch into batches ready for EIM upload   ###
###################################################################
filenames <- choose.files()
newpath <- paste0(dirname(filenames[1]), "/EIMify_results")
dir.create(path = newpath)
setwd(newpath)
ldf <- lapply(filenames, read.csv, as.is = TRUE)
ldf2 <- lapply(ldf, subset, Field_Collection_Type != "QC")
ops <- function(x){
     x <- x[,-c(1,57:80)]
     x[,1] <- "SSB_WQ"
     x[,25] <- "Fresh/Surface Water"
     x[,5] <- "Ecology"
     x[,2] <- x$Study_Specific_Location_ID
     x[,22] <- "U"
     x[,40] <- "#/100ml"
     x #important, must call x after operations otherwise df will become the last operation result
}
ldf3 <- lapply(ldf2, ops )

names(ldf3) <- basename(filenames) #name each df in list based on it's OG filename
lapply(1:length(ldf3), function(i) write.csv(ldf3[[i]], 
                                             file = paste0(names( ldf3[i] ) ),
                                             row.names = FALSE, na = "") )