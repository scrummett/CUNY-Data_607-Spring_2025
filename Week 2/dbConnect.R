# Load the RMySQL package
library(RMySQL)

# Create a connection to the database
con <- dbConnect(MySQL(), 
                 user = "pkowalchuk", 
                 password = "Landmark1", 
                 dbname = "pkowalchuk", 
                 host = "cuny607sql.mysql.database.azure.com", 
                 port = 3306)

# Check if the connection is successful
if(!dbIsValid(con)) {
  stop("Connection failed")
} else {
  print("Connection successful")
}

# Example query to fetch data
query <- "SHOW tables"
result <- dbGetQuery(con, query)

# View the result
print(result)

# Close the connection
dbDisconnect(con)
