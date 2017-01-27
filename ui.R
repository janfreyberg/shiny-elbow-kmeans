
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Univariate k-Means Clustering with elbow method"),
  hr(),
  h3("Step 1: Data Entry"),
  # Sidebar with a slider input for number of bins
  fluidRow(
    column(4, p("In the box on the right, enter your data in whatever format you'd like.")),
    column(
      6,
      textAreaInput(
        "datatext",
        "Paste Data (comma/tab/space separated)",
        value = "1, 2, 3, 60, 70, 80, 100, 220, 230, 250"
      )
    )
    ),
  hr(),

  fluidRow(
    column(
      5,
      h3("Step 2: Find the elbow"),
      # Show the elbow plot
      plotOutput("elbowPlot", click = "plot_click"),
      p("To identify where the elbow lies, you need to pick where the variance explained starts to decrease at a significantly lower rate.
        Pick that point in the plot above.
        
        In the default example, it would be at the third point from the left.")
    ),
    
    column(
      5, offset = 2,
      h3("Step 3: Check the result"),
      # show the clustered data
      plotOutput("clusterPlot"),
      p("Make sure the clusters identified make sense in the plot above, and don't divide the data too finely.")
    )

  )
))
