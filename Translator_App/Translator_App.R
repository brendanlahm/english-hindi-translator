############ Translator App: English -> Hindi
# Accepts a single English word and returns all Hindi matches in Devanagari script

library(shiny)
library(DBI)

########################################### Establishing DB connection
hindi_db <- dbConnect(RSQLite::SQLite(), "../db/hindi_english.db")


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
