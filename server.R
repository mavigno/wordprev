
library(shiny)

# insert libraries and data needed here


source("findword.r")

shinyServer(function(input, output, session) {
        
        sentenca <- vector()
        words <- vector()
        # how to get a variable dataset:
        # data <- reactive({ get(input$data, 'package:datasets') })
        # this evaluates the data in input$data and get it from package datasets
        # cool
        
        observe({
                if (length(input$textentry) > 0) {
                        sentenca <- normalize(lastSentence(input$textentry))
                        words <- last4(str_trim(sentenca))
                        #output$numberWords <- renderText(paste("length",length(words),sep=":"))
                        result <- findWord(words)
                        output$word1 <- renderText(result[1])
                        output$word2 <- renderText(result[2])
                        output$word3 <- renderText(result[3])
                        #output$debugout <- renderText(paste(result,collapse=";"))
                        #output$debugout2 <- renderText(paste(words,collapse=";"))
                } else {
                        words[1] <- "SOS"
                        result <- findWord(words)
                        output$word1 <- renderText(result[1])
                        output$word2 <- renderText(result[2])
                        output$word3 <- renderText(result[3])
                        #output$debugout <- renderText(paste(result,collapse=";"))
                        #output$debugout2 <- renderText(paste(words,collapse=";"))
                }
        })
        observe({
                if(input$cleartext==0) return()
                isolate({
                        words <- NULL
                        words[1] <- "SOS"
                        result <- findWord(words)
                        output$word1 <- renderText(result[1])
                        output$word2 <- renderText(result[2])
                        output$word3 <- renderText(result[3])
                })
        })
        observe({
                if(input$babbletext==0) return() 
                isolate({
                        phrase <- updateTextInput(
                                session,
                                "textentry",
                                value=paste(input$textentry,babble(input$textentry,n=input$numwords,random=as.logical(as.integer(input$random))),sep=" "))
                })
        })

})
