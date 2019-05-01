# Connects to EIM WEB server (must have permissions)
# you can then run SQL queries indirectly through r using SQL or dplyr functions. 
# 

#Load library and establish connection
library(odbc)
conn <- dbConnect(odbc(), 
                  driver = "SQL Server", 
                  Server = "EcyDBeem", 
                  database = "EIMWEB") 

# print all table names
tables <- dbListTables(conn)

# Example queries: 
trial_query <- "SELECT UserIdentificationCode as LocationID, 
GISCalculatedLatitudeDecimal as Latitude,
GISCalculatedLongitudeDecimal as Longitude 
FROM STATION 
WHERE UserIdentificationCode 
IN ('KIT03','1-UNNAMED', '2-UNNAMED', 'LORD_HILL_3', 'LORD_HILL_4', )"
proj <- "SELECT ProjectId, ProjectName, UserIdentificationCode FROM PROJECT WHERE EcologyContactLastName = 'Raunig'"

#Run Query
Raunig <- dbGetQuery(conn, statement = proj)

# Please disconnect when finished working in EIM WEB
dbDisconnect(conn = conn)
