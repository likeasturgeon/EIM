library(dygraphs)
library(dplyr)
library(readr)
############################ CHOOSE DIRECTORY ############################
files <- choose.files() #Choose one or more T-Series files to view
##################### CHANGE INDEX AND RUN 1 AT A TIME  ###################

graphEIM <- function(i = 1){
     df <- read.csv(file = files[i], as.is = TRUE, na.strings = "") ## Read file specified by index (i)
     df$Start_Date <- gsub(" .*$", "", df$Start_Date)                           ## TRIM DATE
     qualified <<- df %>%filter(!is.na(Result_Data_Qualifier) | Result_Data_Qualifier != "") %>% 
                select(Start_Date, Start_Time, Result_Value, Result_Unit, Result_Data_Qualifier, Comment)	## creates a table of qualified data to review
     print( list(Studies = unique(df$Study_ID),  															## prints a summary of Study ID, Location ID, field collections, matrix, and method 
               Locations = unique(df[,c(3,4)]),
               Field_Collections = unique(df[,5]),
               Matrix = unique(df[,c(10,11)]),
               Method = unique(df[,20])
               )	
          )                    
     
     ts_df <- df %>%																			## the next 4 lines convert the batch to an xts object. 
     mutate(my_time = lubridate::mdy_hms(paste(df$Start_Date, " ", df$Start_Time))) %>%
     select(my_time, Result_Value)
     ts_df <- xts::xts(ts_df$Result_Value, order.by=ts_df$my_time)
     
     qdat <- qualified %>% mutate(my_time =lubridate::mdy_hms(paste(qualified$Start_Date, " ", qualified$Start_Time))) %>%
          select(my_time, Result_Value)
     qdat <- xts::xts(qdat$Result_Value, order.by = qdat$my_time)
          
     
     dygraphs::dygraph(ts_df, 
                       main = basename(files[i]),
                       xlab = "Date_Time", 
                       ylab = paste(df$Parameter_Name[1], df$Result_Unit[1])
                       ) %>%
                 dygraphs::dyRangeSelector() 
}

graphEIM() # Default = 1. If more than one file was chosen, the first will be graphed. If only one was chosen, it will be graphed. Graph others, enter 2,3,4...etc. 

#################### If you want to highlight stuff, run the portion below and change the shading date ###################


dygraphs::dygraph(ts_df, 
                   main = basename( files[i]),
                   xlab = "Date_Time", 
                   ylab = paste(df$Parameter_Name[1], df$Result_Unit[1])) %>%
dygraphs::dyRangeSelector() %>%
dygraphs::dyShading(from = "2015-7-23", to = "2015-10-26", color = "#FFE6E6")

########################
### ACTIVITY SUMMARY ###
########################

all <- data.frame()                          ## Make empty df named all_data
for (file in files) {                        ## read each file into temp df
     df <- read.csv(file,
                    header = TRUE,
                    check.names = FALSE,
                    as.is = TRUE)
     df$batchname <- basename(file)             ## label each row with source batch file name
     all <- rbind(all, df)                      ## bind df to all data
}

all$Start_Date <- gsub(" .*$", "", all$Start_Date)
all$Start_Date <- as.Date(all$Start_Date, format ="%m/%d/%Y" )

ActivitySummary <- all %>% 
     mutate(Location_And_Parameter = paste(Location_ID, Parameter_Name)) %>%
     select(Location_And_Parameter, Start_Date) %>%
     group_by(Location_And_Parameter) %>%
     summarize(Activity_Start = min(Start_Date),  Activity_End = max(Start_Date))
