
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

shinyServer(function(input, output) {
  
  output$elbowPlot <- renderPlot({
    
    # process the data
    variable <- as.matrix(as.numeric(unlist(str_split(input$datatext, '(\n|,|[:space:])+'))))
    
    # perform the k-means analyses
    krange <- 1:min(15, (nrow(variable)-1))
    wss <- krange
    for(i in krange){
      set.seed(2017)
      wss[i] <- sum(kmeans(variable, i, iter.max=20)$withinss)
    }
    
    elbowdata <<- tibble(krange, wss)
    
    
    # make a plot
    p <- ggplot(elbowdata, aes(x=krange, y=wss)) +
      geom_line() +
      geom_point(shape = 1, size = 3, fill = 'white') +
      # make it nice
      theme_bw() +
      scale_x_discrete(breaks=krange, labels=krange) +
      labs(y = "Sum of squares explained",
           x = "Number of clusters found")
    
    p
  })
  
  output$clusterPlot <- renderPlot({
    # process input data
    variable <- as.numeric(unlist(str_split(input$datatext, '(\n|,|[:space:])+')))

    # find the selected k value
    k <- nearPoints(elbowdata, input$plot_click, threshold = 20, maxpoints = 1)$krange
    if(length(k) == 0){k = 1}
    # perform the k-means analysis again
    if(length(k) > 0){
      
      set.seed(2017) # to achieve same result as above
      kmeansresult <- kmeans(as.matrix(variable), k, iter.max=20)
      clustering <- kmeansresult$cluster
      centers <- tibble(y = c(kmeansresult$centers), x = rep(1, k),
                        group = as.factor(1:k))
      
    } else {
      
      clustering <- rep(1, length(variable))
      
    }
    
    clusterdata <- tibble(variable, group=as.factor(clustering), x=rep(1, length(variable)))
    # create plot
    set.seed(2017) # so that jitter doesn't get re-done
    p <- ggplot(clusterdata, aes(x = x, y = variable,
                                 color = group)) +
      geom_point(size=4, position=position_jitter(width=0.15)) +
      xlim(0, 2) +
      scale_color_discrete() +
      scale_x_discrete() +
      theme_bw() +
      theme(legend.position=c(0.9, 0.5))
      labs(x="", y="Your Variable.")

    # add the group centers to the plot (if existent)
    if(length(k) > 0){
      p <- p + geom_point(data=centers, aes(x = x, y = y, color = group),
                          shape=10, size=7)
    }
    
    # display plot
    p
  })

})
