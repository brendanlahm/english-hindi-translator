################## Build the SQL DB
library(stringr)
library(DBI)

# Import data from https://github.com/bdrillard/english-hindi-dictionary
dict <- read.csv('../English-Hindi Dictionary.csv')

########################################### Cleaning up the data table
dict$egrammar <- gsub('Adjective\"', replacement='Adjective', x=dict$egrammar)
substr(dict$egrammar, 1, 1) <- str_to_upper(substr(dict$egrammar, 1, 1))
dict$eword <- str_replace_all(dict$eword, "^[:space:]", "")
dict$hword <- str_replace_all(dict$hword, "^[:space:]", "")
dict$eword <- str_replace_all(dict$eword, "[:space:]{2}", " ")
dict$hword <- str_replace_all(dict$hword, "[:space:]{2}", " ")

############################# Remove duplicate rows
dict <- unique(dict[,1:3])

############################# Remove empty rows
dict <- dict[-c(1:2),]

############################# Correcting Grammar
dict[which(dict$eword == 'black francolin'), 3] <- "Noun"
dict[which(dict$eword == 'haughty'), 3] <- "Adjective"
dict[which(dict$eword == 'short'), 3][1] <- "Adjective"

############################# Fixing 'the'
dict[which(dict$eword == 'the'), 1][1] <- "the best"
dict <- dict[-c(which(dict$eword == 'the')),]

############################# Add translation for 'sadness'
sadness <- data.frame("sadness", "\u095a\u092e", "Noun")
colnames(sadness) <- c("eword", "hword", "egrammar")
dict <- rbind(dict[1:which(dict$eword == 'sadness')[1]-1,], sadness, dict[which(dict$eword == 'sadness'):nrow(dict),])

############################# Correct translation for 'is'
is <- data.frame("is", "\u0939\u0947", "Verb")
colnames(is) <- c("eword", "hword", "egrammar")
dict[which(dict$eword == 'is'),] <- is

############################# Add translation for 'are'
are <- data.frame("are", "\u0939\u0948\u0902", "Verb")
colnames(are) <- c("eword", "hword", "egrammar")
dict <- rbind(dict[1:which(dict$eword == 'are')[1]-1,], are, dict[(which(dict$eword == 'are')[1]):nrow(dict),])

############################# Fixing 'you'
dict <- rbind(dict[1:which(dict$eword == 'you')[1]-1,], dict[which(dict$eword == 'you')[1]+1,], dict[(which(dict$eword == 'you')[1]),], dict[(which(dict$eword == 'you')[1]+2):nrow(dict),])

############################# Correct translation for 'I'
dict <- rbind(dict[1:which(dict$eword == 'i')[1]-1,], dict[max(which(dict$eword == 'i')),], dict[(which(dict$eword == 'i')[1]+1):(which(dict$eword == 'i')[1]+5),], dict[(max(which(dict$eword == 'i'))+1):nrow(dict),])

############################# Correct translation for 'man'
dict <- rbind(dict[1:which(dict$eword == 'man')[1]-1,], dict[which(dict$eword == 'man')[3],], dict[which(dict$eword == 'man')[4]:nrow(dict),])

############################# Correct translation for 'woman'
dict <- rbind(dict[1:which(dict$eword == 'woman')[1]-1,], dict[which(dict$eword == 'woman')[4],], dict[which(dict$eword == 'woman')[2],], dict[(which(dict$eword == 'woman')[6]):nrow(dict),])

############################# Correct translation for 'cat'
dict <- dict[-c(which(dict$eword == 'cat')[1:5]),]

############################# Correct translation for 'nose'
dict[which(dict$eword == 'nose')[1], 1] <- 'curiosity'
dict[which(dict$eword == 'nose')[1], 1] <- 'to defeat'
dict <- rbind(dict[1:which(dict$eword == 'nose')[1]-1,], dict[which(dict$eword == 'nose')[5],], dict[(which(dict$eword == 'nose')[1]):(which(dict$eword == 'nose')[4]),], dict[(which(dict$eword == 'nose')[6]):nrow(dict),])

########## Establish connection & write
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")

dbWriteTable(hindi_db, "dict", dict, overwrite=F)

########## For overwriting
dbDisconnect(hindi_db)
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")

dbWriteTable(hindi_db, "dict", dict, overwrite=T)





