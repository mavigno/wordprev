
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Word Prediction"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(h3("Parameters")
                        
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3("Input Text"),
      tags$textarea(id="userentry",rows=10,cols=80),
      textOutput("textEntered"),
      textInput("word1","Word 1:"),
      textInput("word2","Word 2:"),
      textInput("word3","Word 3:")
    )
  )
))
