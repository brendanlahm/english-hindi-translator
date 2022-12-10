################## Build the SQL DB
library(stringr)
library(DBI)

# Import data from https://github.com/bdrillard/english-hindi-dictionary
dict <- read.csv('../English-Hindi Dictionary.csv')

########################################### Cleaning up the data table
dict$egrammar[15394] <- "Noun"
dict$egrammar[65232] <- "Adjective"
dict$egrammar <- gsub('Adjective\"', replacement='Adjective', x=dict$egrammar)
substr(dict$egrammar, 1, 1) <- str_to_upper(substr(dict$egrammar, 1, 1))
dict$eword <- str_replace_all(dict$eword, "^[:space:]", "")


########## Establish connection & write
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")

dbWriteTable(hindi_db, "dict", dict, overwrite=F)






