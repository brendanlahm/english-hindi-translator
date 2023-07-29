############ Translator App: English -> Hindi
# Accepts a single English word and returns all Hindi matches in Devanagari script

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
            textInput("input_sentence", label = "Translate a Sentence", value = "He is short")
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
    
    enoun <- entry[which(egrammar == "Noun"|egrammar == "Pronoun")]
    eadjective <- entry[which(egrammar == "Adjective")]
    everb <- entry[which(egrammar == "Verb")]
    
    setClass("sentence", slots = list(h_noun = 'character', h_adjective = 'character', h_verb = 'character'))

    sentence <- new("sentence",
                    h_noun = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", enoun, "'"))))[1],
                    h_verb = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", everb, "'"))))[1],
                    h_adjective = unlist(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", eadjective, "'"))))[1]
    )
    
    str_remove(paste(sentence@h_noun, sentence@h_adjective, sentence@h_verb, sep = " "), "NA ")
      
  })
  
}


shinyApp(ui = ui, server = server)
