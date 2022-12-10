####################################### DB Tests
library(DBI)

hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")

dbListTables(hindi_db)

dbGetQuery(hindi_db, "SELECT * FROM dict LIMIT 10")
dbGetQuery(hindi_db, "SELECT * FROM dict WHERE ROWID=10")
dbGetQuery(hindi_db, "SELECT * FROM dict WHERE eword='ling'")
dbGetQuery(hindi_db, "SELECT * FROM dict WHERE eword LIKE 'your%' LIMIT 5")

############################## Other way
dbGetQuery(hindi_db, "SELECT * FROM dict WHERE hword LIKE '\u0915\u093e' LIMIT 5")
dbGetQuery(hindi_db, paste("SELECT * FROM dict WHERE hword LIKE", paste0("'", Parvati, "'")))
dbGetQuery(hindi_db, paste("SELECT * FROM dict WHERE hword LIKE '\u092a\u093e\u0930\u094d\u0935\u0924\u0940'"))

############################# For the App
your = 'your'
return <- as.list(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", your, "'"), "LIMIT 5")))
paste(unlist(return), collapse=' / ')

h <- as.list(dbGetQuery(hindi_db, "SELECT hword FROM dict WHERE eword LIKE 'lin'"))
h <- paste(unlist(h), collapse=' / ')

if(h == ''){print(as.list(dbGetQuery(hindi_db, "SELECT hword FROM dict WHERE eword LIKE 'lin%'")))
  
  }




