
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

shinyServer(function(input, output) {
  
  # Obtain the data
  inputData <- reactive({
    tibble(y = str_trim(input$datatext) %>%
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
      do(kclust=kmeans(inputData()$y, .$k, iter.max=50))
  })
  
  # Make the elbow plot
  output$elbowPlot <- renderPlot({
    # get the summary data out of the data frame
    kclusts() %>%
      group_by(k) %>%
      do(glance(.$kclust[[1]])) %>%
      # Do the plot:
      ggplot(aes(x=k, y=tot.withinss)) +
      geom_line() +
      geom_point(shape = 1, size = 3, fill = 'white') +
      # Make it nice
      theme_bw() +
      scale_x_discrete(breaks=krange, labels=krange) +
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
    set.seed(2017) # so that the jitter isn't redone all the time
    cat("whatever")
    centers <- kclusts() %>% filter(k==selectedk()) %>% group_by(k) %>% do(tidy(.$kclust[[1]])) %>% mutate(y = x1, x = 1)
    
    kclusts() %>%
      filter(k==selectedk()) %>% group_by(k) %>% do(augment(.$kclust[[1]], inputData())) %>% mutate(x = 1) %>%
      ggplot(aes(x=x, y=y, colour=.cluster)) +
        # Add the original points
        geom_point(size=4, position=position_jitter(width=0.15)) +
        # Add the cluster centers
        geom_point(data=centers, aes(colour=cluster), size = 20, shape = '*', show_guide=FALSE) +
        # Make it pretty
        xlim(0.5, 2.5) + scale_color_discrete() + scale_x_discrete() + theme_bw() +
        theme(legend.position=c(0.8, 0.5)) + labs(x="", y="Your Variable.", color="Cluster")
  })
  
  output$kmeansResults <- renderText({
    
    kclust <- kclusts() %>% filter(k==selectedk()) %>% .$kclust %>% .[[1]]
    centers <- kclust %$% toString(round(centers, digits=2))
    variance <- round(100*(kclust$totss-kclust$tot.withinss)/kclust$totss, digits=2)
    
    paste0("You chose ", selectedk(), ifelse(selectedk()>1, " clusters.", " cluster."), "\n\n",
           ifelse(selectedk()>1, "The cluster centers are:\n", "The cluster center (i.e. overall mean) is:\n"), centers, "\n\n",
           "This clustering accounts for ", variance, "% of the total variance.")
  })

})
