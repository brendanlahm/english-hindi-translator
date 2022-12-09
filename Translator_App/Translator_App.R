############ Translator App: English -> Hindi
# Accepts a single English word and returns all Hindi matches in Devanagari script

library(shiny)
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

colnames(dict) <- c('eword', 'hword', 'Type')

########################################### Establishing the DB connection
hindi_db <- dbConnect(RSQLite::SQLite(), "hindi_english.db")



ui <- fluidPage(

    titlePanel("English -> Hindi"),

    sidebarLayout(
        sidebarPanel(
            textInput("eword", label=NULL
                        )
        ),

        mainPanel(
          uiOutput("hword")
        )
    )
)


server <- function(input, output, session=session) {
    
  eword <- reactive({
    
    eword1 <- input$eword
    eword1
    
  })
  
    observeEvent(input$eword, {
      
      isolate({
        
        print(eword())
        
      })
      
    })
  
  output$hword <- renderUI({
    
    # SQL Statement
    h <- as.list(dbGetQuery(hindi_db, paste("SELECT hword FROM dict WHERE eword LIKE", paste0("'", eword(), "'"))))
    paste(unlist(h), collapse=' / ')
    
  })
  
}


shinyApp(ui = ui, server = server)
