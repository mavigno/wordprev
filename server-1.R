
library(shiny)

# insert libraries and data needed here
library(data.table)
library(tm)
library(stringr)
library(NLP)
library(openNLP)
source("findword.r")
load("data/n2r.rds")
load("data/n3r.rds")
load("data/n4r.rds")
load("data/n5r.rds")
load("data/vocabulary-complete.rds")
load("data/vocabulary-reduced.rds")
load("data/words.all.rds")

shinyServer(function(input, output, session) {
        
        sentenca <- vector()
        words <- vector()
        # how to get a variable dataset:
        # data <- reactive({ get(input$data, 'package:datasets') })
        # this evaluates the data in input$data and get it from package datasets
        # cool
        findWords <- reactive({
                print("chamou findWords")
                

        })
        
        observe({
                sentenca <- normalize(lastSentence(input$userentry))
                words <<- last4(sentenca) # this <<- make difference
                result <- findWord(words)
                updateTextInput(session,"word1",value=result[1])
                updateTextInput(session,"word2",value=result[2])
                updateTextInput(session,"word3",value=result[3])
                output$textEntered <- renderText(paste(words,collapse=" ") )
        })

})
