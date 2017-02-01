
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Bivariate k-Means Clustering with elbow method"),
  helpText("Find the code for this at http://github.com/janfreyberg/shiny-elbow-kmeans.",
           "Find the accompanying blogpost at <missing>"),
  hr(),
  # Sidebar with a slider input for number of bins
  fluidRow(
    column(5,
           h3("Step 1: Data Entry"),
           p("In the box below, enter your data in whatever format you'd like."),
           fluidRow(
             column(6, textAreaInput(
              "datatext1",
              "Paste Data (Variable 1) (comma/tab/space separated)",
              value = "1, 2, 3, 60, 70, 80, 100, 220, 230, 250"
            )),
             column(6, textAreaInput(
               "datatext2",
               "Paste Data (Variable 2) (comma/tab/space separated)",
               value = "4, 3, 2, 60, 2, 3, 2, 210, 215, 212"
            ))
           ),
           h3("Step 2: Find the elbow"),
           # Show the elbow plot
           plotOutput("elbowPlot", click = "plot_click"),
           p("To identify where the elbow lies, you need to pick where the residual variation starts to decrease at a markedly lower rate.
             Pick that point in the plot above.
             
             In the default example, it would be at the third point from the left.")
           ),
    column(6, offset=1,
           h3("Step 3: Check the outcome"),
           # show the clustered data
           plotOutput("clusterPlot"),
           p("Make sure the clusters identified make sense in the plot above, and don't divide the data too finely."),
           h3("Step 4: Get your results"),
           verbatimTextOutput("kmeansResults")
    )
    ),
  hr()
))
