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
dict$hword <- str_replace_all(dict$hword, "^[:space:]", "")
dict$eword <- str_replace_all(dict$eword, "[:space:]{2}", " ")
dict$hword <- str_replace_all(dict$hword, "[:space:]{2}", " ")

############################# Remove duplicate rows
dict <- unique(dict[,1:3])

############################# Add translation for sadness
sadness <- data.frame("sadness", "\u095a\u092e", "Noun")
colnames(sadness) <- c("eword", "hword", "egrammar")
dict <- rbind(dict[1:104806,], sadness, dict[104807:nrow(dict),])

########## Establish connection & write
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")

dbWriteTable(hindi_db, "dict", dict, overwrite=F)

########## For overwriting
dbDisconnect(hindi_db)
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")

dbWriteTable(hindi_db, "dict", dict, overwrite=T)





