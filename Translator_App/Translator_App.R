############ Translator App: English -> Hindi
# Accepts a single English word and returns all Hindi matches in Devanagari script

library(shiny)
library(shinyWidgets)
library(DBI)

########################################### Establishing DB connection
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")


ui <- fluidPage(

    titlePanel("English -> हिन्दी (Hindi)"),

    switchInput(inputId = "switch", label = "Swap Languages"),
    
    sidebarLayout(
        sidebarPanel(
            textInput("input_word", label=NULL
                        )
        ),

        mainPanel(
          uiOutput("output_word")
        )
    ),
    
    tags$head(tags$style("#output_word{font-size: 20px;
                                 }"))
)


server <- function(input, output, session=session) {
    
  input_word <- reactive({
    
    input_word1 <- input$input_word
    input_word1
    
  })
  
    observeEvent(input$input_word, {
      
      isolate({
        
        print(input_word())
        
      })
      
    })
  
  output$output_word <- renderUI({
    
    # SQL Statement
    
    if(input$switch == 1) {
    
      answer <- as.list(dbGetQuery(hindi_db, paste("SELECT eword FROM dict WHERE hword LIKE", paste0("'", input_word(), "'"))))
      paste(unlist(answer), collapse=' / ')
      
    }
      
    else {
      
      answer <- as.list(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", input_word(), "'"))))
      paste(unlist(answer), collapse=' / ')
    
    }
    
  })
  
}


shinyApp(ui = ui, server = server)
