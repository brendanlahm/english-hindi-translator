############################################# Translator App: English -> Hindi
### Translates a single word between English & Hindi
## Hindi entries must be in Devanagari script
# Can translate some English sentences into Hindi

library(shiny)
library(shinyWidgets)
library(DBI)
library(stringr)

########################################### Establishing DB connection
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")


ui <- fluidPage(

    titlePanel("English -> हिन्दी (Hindi)"),

    switchInput(inputId = "switch", label = "Swap Languages"),
    
    sidebarLayout(
        sidebarPanel(
            textInput("input_word", label=NULL
                        ),
        ),

        mainPanel(
          uiOutput("output_word")
        )
    ),
    
    sidebarLayout(
      sidebarPanel(
            textInput("input_sentence", label = "Translate a Sentence", value = "He is a short man")
    ),
    
        mainPanel(
          uiOutput("output_sentence")
        )
    ),
    
    
    tags$head(tags$style("#output_word{font-size: 20px;
                                 }",
                         "#output_sentence{font-size: 20px;
                                 }"))
)


server <- function(input, output, session=session) {
    
  input_word <- reactive({
    
    input_word1 <- input$input_word
    input_word1
    
  })
  
  input_sentence <- reactive({
    
    input_sentence1 <- input$input_sentence
    input_sentence1
    
  })
  
    observeEvent(input$input_word, {
      
      isolate({
        
        print(input_word())
        
      })
      
    })
    
    observeEvent(input$input_sentence, {
      
      isolate({
        
        print(input_sentence())
        
      })
      
    })
  
  output$output_word <- renderUI({
    
    # SQL Statement for a single word
    
    if(input$switch == 1) {
    
      answer <- dbGetQuery(hindi_db, paste("SELECT eword FROM dict WHERE hword LIKE", paste0("'", input_word(), "'")))
      paste(unlist(answer), collapse=' / ')
      
    } else {
      
      answer <- dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", input_word(), "'")))
      paste(unlist(answer), collapse=' / ')
    
    }
    
  })
  
  ##################################### Translating a Sentence
  output$output_sentence <- renderUI({
      
    entry <- unlist(strsplit(input_sentence(), " "))
    
    egrammar <- list()
    for (a in seq(entry)) {
      
      egrammar[[a]] <- dbGetQuery(hindi_db, paste("SELECT egrammar FROM dict WHERE eword LIKE", paste0("'", entry[a], "'")))
      egrammar[[a]] <- egrammar[[a]][["egrammar"]][1]
      
    }
    
    enoun1 <- entry[which(egrammar == "Noun"|egrammar == "Pronoun")][1]
    enoun2 <- entry[which(egrammar == "Noun"|egrammar == "Pronoun")][2]
    enoun3 <- entry[which(egrammar == "Noun"|egrammar == "Pronoun")][3]
    earticle <- entry[which(egrammar == "Article"|egrammar == "Determiner")]
    eadjective1 <- entry[which(egrammar == "Adjective")][1]
    eadjective2 <- entry[which(egrammar == "Adjective")][2]
    everb <- entry[which(egrammar == "Verb")]
    
    ########### Set a class for constructing a sentence
    setClass("sentence", slots = list(h_noun1 = 'character', h_noun2 = 'character', h_noun3 = 'character', h_article = 'character', h_adjective1 = 'character', h_adjective2 = 'character', h_verb = 'character'))

    sentence <- new("sentence", 
                    h_noun1 = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", enoun1, "'"))))[1],
                    h_noun2 = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", enoun2, "'"))))[1],
                    h_noun3 = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", enoun3, "'"))))[1],
                    h_article = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", earticle, "'"))))[1],
                    h_adjective1 = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", eadjective1, "'"))))[1],
                    h_adjective2 = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", eadjective2, "'"))))[1],
                    h_verb = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", everb, "'"))))[1]
    )
    
    if(which(entry == eadjective1) < which(entry == enoun1)) {
      
      str_remove_all(paste(sentence@h_adjective1, sentence@h_noun1, sentence@h_article, sentence@h_adjective2, sentence@h_noun2, sentence@h_noun3, sentence@h_verb, sep = " "), " NA|NA ")
      
    } else {
      
      str_remove_all(paste(sentence@h_noun1, sentence@h_article, sentence@h_adjective1, sentence@h_noun2, sentence@h_noun3, sentence@h_verb, sep = " "), " NA|NA ")
      
    }
      
  })
  
}


shinyApp(ui = ui, server = server)
