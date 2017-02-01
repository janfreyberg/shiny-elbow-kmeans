
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Bivariate k-Means Clustering with elbow method"),
  helpText("Find the code for this at https://github.com/janfreyberg/shiny-elbow-kmeans/tree/bivariate.",
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
              value = "31.38396, 17.07317, 13.47672, -1.164893, 57.22761, 48.80508, 50.47091, 11.65338, 91.93916, 16.6546, -3.438403, 70.81757, 4.773241, 42.125, 14.02917, 67.88265, 28.51895, 42.79715, 5.145525, -0.7703359, 18.1468, 9.10579, 68.26376, 72.77863, 18.98427, 8.106246, 9.05127, 82.44264, 28.05616, 4.492934"
            )),
             column(6, textAreaInput(
               "datatext2",
               "Paste Data (Variable 2) (comma/tab/space separated)",
               value = "66.525, 25.84198, -4.123874, 18.86306, -5.167954, -22.4844, 64.8867, -5.657587, -1.150087, -1.519889, -12.02527, -20.52531, 11.55061, 66.37105, 2.41937, 60.98403, 73.79701, 51.57061, 11.186, 24.88074, 1.836594, 19.51155, -19.15556, 1.591326, 70.79776, 0.4920085, 12.58227, -17.38876, 31.56779, 16.61764"
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
