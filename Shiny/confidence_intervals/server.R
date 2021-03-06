# Copyright 2014, Phillip Alday
#
# This file is part of Confidence Intervals.
#
# Confidence Intervals is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

library(shiny)
library(ggplot2)
library(gridExtra)
library(scales)
library(reshape2)
library(zoo)
library(plyr)


shinyServer(function(input, output) {
  get.population <- reactive({
    # force update when user clicks on "New Population"
    input$new.population
    #print("New population")
    rnorm(input$population,sd=input$sd)
  })
  
  get.samples <- reactive({
    # force update when user clicks on "New Samples"
    input$new.samples
    population <- get.population()
    #print("New samples")
    data.frame(index=1: input$n,sapply(1: input$nsamples, function(x) sample(population,input$n)))
  })
  
  runSimulation <- reactive({
    population <- get.population()
    mu <- mean(population)
    samples <- get.samples()
    cis <- data.frame( sapply(samples, function(x) t.test(x,conf.level=input$conf.level)$conf.int) )
    cis <- data.frame(t(cis))
    names(cis) <- c("left","right")
    cis$sample <- row.names(cis)
    cis <- cis[2:(input$nsamples+1),]
    cis$`population mean` <- factor(ifelse(mu > cis$left & mu < cis$right,"hit","miss"), levels=c("miss","hit"))
    
<<<<<<< HEAD
    #bw <- diff(range(sample.means$mean)) / input$n
    bw <- input$bw
<<<<<<< HEAD
    m <- ggplot(sample.means) + geom_histogram(aes(x=mean,y=..density..),binwidth=bw,color="black",alpha=0.9,position="dodge") +  geom_vline(xintercept=left,color="darkred") +  geom_vline(xintercept=right,color="darkred")
    dist <- ggplot(samples) + geom_density(aes(x=value)) +  
      # geom_vline(aes(xintercept=mean(value)), color="darkred") +
=======
    m <- ggplot(sample.means) + 
      geom_histogram(aes(x=mean,y=..density..),binwidth=bw,color="black",alpha=0.9,position="dodge") +  
      scale_x_continuous(limits=c(-4,4)) + 
      geom_vline(xintercept=left,color="darkred") +  
      geom_vline(xintercept=right,color="darkred")
    dist <- ggplot(samples) + geom_density(aes(x=value)) +  
      # geom_vline(aes(xintercept=mean(value)), color="darkred") +
      scale_x_continuous(limits=c(-4,4)) + 
>>>>>>> a93ff1eb332de38a2e7a658a25d8ecc59bc55680
      facet_wrap(~sample) + theme(strip.background = element_blank(),strip.text.x = element_blank()) 
    plots <- list(distributions=dist,means=m)
  
    plots  
  })
  
  output$ttest <- renderUI({
    # first column is index, second column is first sample
    s <- get.samples()[,2]
    #print(head(get.samples()))
    #print(s)
    s.text <- paste0(s,collapse=", ")
    t <- t.test(s,conf.level = input$conf.level)
    text <- paste0("The confidence interval calculated from the first sample is ",t$conf.int[1], " to ", t$conf.int[2], " with mean ",mean(s),".")
    #paste(text, "For reference, this sample was:", s.text)
=======
    samples <- melt(samples, id.var="index")
    sample.means <- aggregate(value ~ variable, FUN=mean, data=samples)
    names(samples) <- c("index","sample","value")
    names(sample.means) <- c("sample","mean")
    #sorted.means <- sort(sample.means$mean)
>>>>>>> c36f07d9f256c9b799dd8239e71bbc1fb7028ae8
    
    list(population=population, cis=cis, sample.means=sample.means, samples=samples)
  })

  output$sample.distributions <- renderPlot({
    x <- runSimulation()
    cis <- x$cis
    population <- x$population
    mu <- mean(population)
    sample.means <- x$sample.means
    samples <- x$samples
    
    plots <- ggplot(samples) + geom_density(aes(x=value)) +  scale_x_continuous(limits=c(-4,4)) + 
      facet_wrap(~sample) + 
      geom_vline(aes(xintercept=mean),linetype="dashed",data=sample.means) +
      geom_segment(aes(x=left,xend=right,y=0,yend=0,color=`population mean`),size=3,data=cis) + 
      scale_color_hue(limits=c("miss","hit")) + 
      geom_rect(aes(fill = `population mean`),xmin = -Inf,xmax = Inf,ymin = -Inf,ymax = Inf,alpha = 0.2,data=cis) +
      scale_fill_hue(limits=c("miss","hit")) + 
      guides(fill=FALSE) + 
      geom_vline(xintercept=mu) + 
      theme(axis.title.y = element_blank()
            ,axis.text.y = element_blank()
            ,axis.ticks.y = element_blank()
            ,strip.background = element_blank()
            ,axis.title.x = element_blank()
            ,strip.text.x = element_blank())
    print(plots)
  })

  output$population.distribution <- renderPlot({
<<<<<<< HEAD
    population <- get.population()
<<<<<<< HEAD
    print(qplot(population,geom="density") +  geom_vline(xintercept=mean(population), color="darkred") )
=======
    popplot <- qplot(population,geom="density") +  
      scale_x_continuous(limits=c(-4,4)) + 
      geom_vline(xintercept=mean(population), color="darkred")
    print(popplot)
>>>>>>> a93ff1eb332de38a2e7a658a25d8ecc59bc55680
=======
    x <- runSimulation()
    cis <- x$cis
    population <- x$population
    sample.means <- x$sample.means
    
    pop <- qplot(population,geom="density") +  
      scale_x_continuous(limits=c(-4,4)) + xlab("") 
    
    if(input$sample.mean.overlay)
      pop <- pop + geom_vline(aes(xintercept=mean),data=sample.means, color="darkred",alpha=0.1,size=3) 
    
    pop <- pop + geom_vline(xintercept=mean(population),size=1)
    
    if(input$sample.ci.overlay)
      pop <- pop + geom_segment(aes(x=left,xend=right,y=0,yend=0),size=3,data=cis,alpha=0.1) 
    
    print(pop)
>>>>>>> c36f07d9f256c9b799dd8239e71bbc1fb7028ae8
  })
})
