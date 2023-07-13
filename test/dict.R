####################################### Data Tests
library(stringr)

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

########################################### Remove duplicate rows
dict <- unique(dict[,1:3])

###########################################
dict_grammar <- unique(dict$egrammar)

##################### User Arguments
input = "run"
grammar = "Verb"
#####################
dict$hword[match(input, dict$eword)] # Return first match
dict$egrammar[match(input, dict$eword)] # Check type

dict_h <- subset(dict, dict$eword==input & dict$egrammar==grammar)
print(dict_h$hword) ### Return all matches

dict_Pronouns <- subset(dict, dict$egrammar=='Pronoun')

############################## Other way around
dict_e <- subset(dict, dict$hword=="है")
print(dict_e$eword)

Parvati <- dict$hword[match('parvati', dict$eword)]







