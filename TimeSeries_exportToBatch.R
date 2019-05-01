###################################################
### CONVERT TIME-SERIES EXPORT BACK TO TEMPLATE ###
###################################################

# Author:      Kuba Bednarek
# Contributors:None 
# Purpose:     It is often necessary to download a timeseries batch, troubleshoot errors, and try to load it 
#              back into the loader. However, EIM makes changes to the batch CSV file that prevent it 
#              from being loaded back in directly. The loader adds columns, reformats dates, and renames fields so that 
#              batches get rejected by the loader. This simple script will read exported batch files
#              convert them back into a format that the loader will recognize. 

files <- choose.files()
setwd(dirname(files))
for (file in files) {
     df <- read.csv(file )                                               # read file
     df <- df[,-24]                                                      # remove added column
     df$Start_Date <- gsub(" .*$", "", df$Start_Date)                    # Remove string "12:00" after date
     df$Start_Date <- format(lubridate::mdy(df$Start_Date), "%m/%d/%Y")  # Format date per EIM rules
     colnames(df)[23] <- "Groundwater_Level_Measuring_Point_ID"          # Rename last column to template standard
     colnames(df)[4] <- "Study-Specific_Location_ID"                     # Rename SSLID column
     ## overwrite it original files
     write.csv(df, 
               basename(file), 
               row.names = FALSE, na = "", 
               quote = c(1,2,3,4,6,7,9,16, 19,21,22,23))
     print(paste(file, "...DONE"))                                       # keep track fo progress
}

# Future improvements needs: 
# vecotrize loop for improved efficiency. 
# Turn into a function that can be sourced and called 