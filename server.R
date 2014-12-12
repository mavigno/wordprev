
library(shiny)

# insert libraries and data needed here
library(data.table)
library(tm)
library(stringr)
library(NLP)
library(openNLP)
source("findword.r")
load("data/n2rF.rds")
load("data/n3rF.rds")
load("data/n4rF.rds")
load("data/n5rF.rds")
load("data/vocabulary-reduced.rds")

shinyServer(function(input, output, session) {
        
        sentenca <- vector()
        words <- vector()
        # how to get a variable dataset:
        # data <- reactive({ get(input$data, 'package:datasets') })
        # this evaluates the data in input$data and get it from package datasets
        # cool
        
        observe({
                sentenca <- normalize(lastSentence(input$textentry))
                words <- last4(sentenca) 
                output$numberWords <- renderText(paste("length",length(words),sep=":"))
                result <- findWord(words)
                output$word1 <- renderText(result[1])
                output$word2 <- renderText(result[2])
                output$word3 <- renderText(result[3])
                output$textEntered <- renderText(sentenca)
                output$textEntered2 <- renderText(paste(words,collapse=";"))
        })

})
