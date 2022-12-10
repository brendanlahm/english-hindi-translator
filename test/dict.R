####################################### Data Tests
library(stringr)

dict <- read.csv('../English-Hindi Dictionary.csv')

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









