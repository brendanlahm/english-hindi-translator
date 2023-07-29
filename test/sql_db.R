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
return <- dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", your, "'"), "LIMIT 5"))
paste(unlist(return), collapse=' / ')

h <- dbGetQuery(hindi_db, "SELECT hword FROM dict WHERE eword LIKE 'I'")
h <- paste(unlist(h), collapse=' / ')

if(h == ''){print(dbGetQuery(hindi_db, "SELECT hword FROM dict WHERE eword LIKE 'lin%'"))
  
  }

g <- dbGetQuery(hindi_db, "SELECT egrammar FROM dict WHERE eword LIKE 'He'")

############################# Translate a Sentence
entry <- "He is short"
entry <- strsplit(entry, " ")
enoun <- unlist(entry)[1]
everb <- unlist(entry)[2]
eadjective <- unlist(entry)[3]

hnoun <- unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", enoun, "'"))))
hnoun

hverb <- unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", everb, "'"))))
hverb

hadjective <- unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", eadjective, "'"))))
hadjective

paste(hnoun[1], hadjective[1], hverb[1])

############################# Determine Grammar
entry <- "He is"
entry_unlist <- unlist(strsplit(entry, " "))

egrammar <- list()
for (a in seq(entry_unlist)) {
  
  egrammar[[a]] <- dbGetQuery(hindi_db, paste("SELECT egrammar FROM dict WHERE eword LIKE", paste0("'", entry_unlist[a], "'")))
  egrammar[[a]] <- egrammar[[a]][["egrammar"]][1]
  
}

enoun <- entry_unlist[which(egrammar == "Noun"|egrammar == "Pronoun")]
eadjective <- entry_unlist[which(egrammar == "Adjective")]
everb <- entry_unlist[which(egrammar == "Verb")]


############################# W/ Class
setClass("sentence", slots = list(h_noun = 'character', h_adjective = 'character', h_verb = 'character'))

sentence <- new("sentence", 
                h_noun = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", enoun, "'"))))[1],
                h_verb = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", everb, "'"))))[1],
                h_adjective = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", eadjective, "'"))))[1]
                )

paste(sentence@h_noun, sentence@h_adjective, sentence@h_verb, sep = " ")

str_remove(paste(sentence@h_noun, sentence@h_adjective, sentence@h_verb, sep = " "), "NA ")

# setMethod("show", "sentence", function(object) {
#   
#   cat(sentence@h_noun, sentence@h_adjective, sentence@h_verb)
#   
# })
# 
# sentence








