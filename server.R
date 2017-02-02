
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(stringr)
library(ggplot2)
library(magrittr)
library(tibble)
library(dplyr)
library(broom)

shinyServer(function(input, output) {
  
  # Obtain the data
  inputData <- reactive({
    tibble(x = str_trim(input$datatext1) %>%
                str_split('(\n|,|[:space:])+') %>%
                unlist() %>%
                as.numeric() %>%
                .[!is.na(.)],
           y = str_trim(input$datatext2) %>%
               str_split('(\n|,|[:space:])+') %>%
               unlist() %>%
               as.numeric() %>%
               .[!is.na(.)])
  })
  
  # Do the cluster analysis (reruns only if input changes)
  kclusts <- reactive({
    set.seed(2017)
    data.frame(k=1:min(15, nrow(inputData())-1)) %>%
      group_by(k) %>%
      do(kclust=kmeans(as.matrix.data.frame(inputData()), .$k, iter.max=50))
  })
  
  # Make the elbow plot
  output$elbowPlot <- renderPlot({
    # get the summary data out of the data frame
    # cat("whatever")
    xlabs <- as.character(kclusts()$k)
    kclusts() %>%
      ungroup() %>% group_by(k) %>%
      do(glance(.$kclust[[1]])) %>%
      # Do the plot:
      ggplot(aes(x=k, y=tot.withinss)) +
      geom_line() +
      geom_point(shape = 1, size = 3, fill = 'white') +
      theme_bw() +
      scale_x_continuous(breaks=kclusts()$k,
                         labels=as.character(kclusts()$k)) +
      labs(y = "(Residual) Variation not explained",
           x = "Number of clusters")
  })
  
  # Get the selected k-point
  selectedk <- reactive({
    # obtain the click
    interacted <- input$plot_click
    # if click occurred and is not 0:
    if(!is.null(interacted)){
      min(max(round(interacted$x), 1),
          nrow(inputData())-1)
    }else{1}
  })
  
  # Plot the raw data
  output$clusterPlot <- renderPlot({
    centers <- kclusts() %>% filter(k==selectedk()) %>%
      ungroup() %>% group_by(k) %>%
      do(tidy(.$kclust[[1]])) %>% mutate(x = x1, y = x2)
    
    kclusts() %>%
      filter(k==selectedk()) %>%
      ungroup() %>% group_by(k) %>%
      do(augment(.$kclust[[1]], inputData())) %>%
      ggplot(aes(x=x, y=y, colour=.cluster)) +
        # Add the original points
        geom_point(size=4) +
        # Add the cluster centers
        geom_point(data=centers, aes(colour=cluster), size = 20, shape = '*', show.legend=FALSE) +
        # Make it pretty
        scale_color_discrete() +
        theme_bw() +
        theme(legend.position=c(0.8, 0.5)) + labs(x="Variable 1", y="Variable 2", color="Cluster")
  })
  
  # Create output for the results: cluster means, etc
  output$kmeansResults <- renderText({
    kclust <- kclusts() %>% filter(k==selectedk()) %>% .$kclust %>% .[[1]]
    centers <- kclust %$% round(centers, digits=2)
    variance <- round(100*(kclust$totss-kclust$tot.withinss)/kclust$totss, digits=2)
    
    formattedTable <- ""
    
    for(row in 1:nrow(centers)){
      formattedTable = paste0(formattedTable, "Center ", row,
                              ": x=", centers[row, 1], ", y=", centers[row, 2],
                              "\n")
    }
    
    paste0("You chose ", selectedk(), ifelse(selectedk()>1, " clusters.", " cluster."), "\n\n",
           ifelse(selectedk()>1, "The cluster centers are:\n",
                  "The cluster center (i.e. overall mean) is:\n"), formattedTable, "\n\n",
           "This clustering accounts for ", variance, "% of the total variance.")
  })

})
