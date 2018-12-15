options(shiny.maxRequestSize=30*1024^2)
library(shiny)
library(leaflet)
library(dplyr)


# Define server logic required to define Youth Tobacco usage in USA
shinyServer(function(input, output) {
  
#Creating an Output variable for Problem Description 
   
output$text <- renderText({HTML(paste("This project uses the dataset 'YTS_Data.csv' provided by 
Centers  Disease Control and Prevention (CDC), State Tobacco Activities Tracking and Evaluation (STATE) System. YTS (Youth Tobacco Survey) Data is collected from 1999 to 2017 but for this application we are taking 2000 to 2017 years.
The data was developed to provide states with comprehensive data on both middle school and high school students regarding tobacco use, exposure to environmental tobacco smoke, smoking cessation, school curriculum, minors ability to purchase or otherwise obtain 
tobacco products, knowledge and attitudes about tobacco, and familiarity with pro-tobacco and anti-tobacco media messages. The YTS uses a two-stage cluster sample design to produce representative samples of
students in middle schools (grades 6–8) and high schools (grades 9–12). The data for the STATE System were extracted from Youth Tobacco Surveys from participating states. Tobacco topics included are cigarette
smoking prevalence, cigarette smoking frequency, smokeless tobacco products prevalence and quit attempts.</br>
We have a large dataset with 33 variables and 10596 observation. </br>
A new column was added Data_Value_Bin to check the density of youth smokers which has 4 levels, Level 1 being the least density of Youth smokers and 4 is high density of Youth smokers.
We are having 3 tabs in this application.</br>
Tab 1 will represent the Map with States coloured on the basis of Density of Youth Smokers</br>
Tab 2 will represent the Descriptive Analytics Tables which has sub tabs like Education level and Smoking Status of Youth Smokers.</br>
Tab 3 will represent the plots which has sub-tabs like Youth smoking on the basis of Gender,Type of Tobacco used(cessation,cigarette,Smokeless Tobacco) and last plot is the percentage of smokers who attempted to quit smoking
last year and Percentage of smokers who wish to quit smoking divided on the basis of Education level</br>
Data is availabe at https://healthdata.gov/dataset/youth-tobacco-survey-yts-data
                                      ",
sep = "</br>")
  
    )})
  # Create a map output variable
  output$map <- renderLeaflet({
    
    #Read file
    inFile <- input$file
    if(is.null(inFile))
      return("Please Upload A File For Analysis From Description Tab")
    mydata<- read.csv(inFile$datapath)
    attach(mydata)
    # Filter the data for different Year and different States
    target1 <- c(input$YEAR)   
    target2 <- c(input$LocationAbbr)
    map_df <- filter(mydata, YEAR %in% target1 & LocationAbbr %in% target2)
    # Categorical color by States
    color <- colorFactor(rainbow(4), map_df$Data_Value_Bin)
    #leaflet function
    leaflet(map_df) %>%
      # Default view
      setView(lng = -77.35, lat = 39.5, zoom = 5) %>%
      # tiles
      addProviderTiles("CartoDB.Positron", options = providerTileOptions(noWrap = TRUE)) %>%
      # Add circles
      addCircleMarkers(
        radius = map_df$Data_Value,
        lng= map_df$Lng,
        lat= map_df$Lat,
        stroke= FALSE,
        fillOpacity=0.5,
        color=color(map_df$Data_Value_Bin)
      ) %>%
      # legends for Density of Youth Smokers
      addLegend(
        "bottomleft",
        pal=color,
        values=map_df$Data_Value_Bin,
        opacity=0.5,
        title="Density of Tobacco Users"
      )
  })
    # Create a descriptive table for different Education Level
    output$table1 <- renderPrint({
      # Connect to the sidebar of file input
      inFile <- input$file
      
      if(is.null(inFile))
        return("Please Upload A File For Analysis")
      
      # Read input file
      mydata <- read.csv(inFile$datapath)
      attach(mydata)
      
      
      # Filter the data for different Year and different States
      target1 <- c(input$YEAR)
      target2 <- c(input$LocationAbbr)
      Education_df <- filter(mydata, YEAR %in% target1 & LocationAbbr %in% target2)
      
      # Create a table for Education
      table(Education_df$Education)
      
    })
    
    # Create a descriptive table for different Smoking status of youth 
    output$table2 <- renderPrint({
      # Connect to the sidebar of file input
      inFile <- input$file
      
      if(is.null(inFile))
        return("Please Upload A File For Analysis")
      
      # Read input file
      mydata <- read.csv(inFile$datapath)
      attach(mydata)
      
      
      # Filter the data for different Year and different States
      target1 <- c(input$YEAR)
      target2 <- c(input$LocationAbbr)
      Status_df <- filter(mydata, YEAR %in% target1 & LocationAbbr %in% target2)
      
      # Create a table for Quit Attempts
      table(Status_df$MeasureDesc,exclude = c("Quit Attempt in Past Year Among Current Cigarette Smokers","Percent of Current Smokers Who Want to Quit"))
     
    
      
    })
    # Create a descriptive table for different Smoking status of youth 
    output$table3 <- renderPrint({
      # Connect to the sidebar of file input
      inFile <- input$file
      
      if(is.null(inFile))
        return("Please Upload A File For Analysis")
      
      # Read input file
      mydata <- read.csv(inFile$datapath)
      attach(mydata)
      
      
      # Filter the data for different Year and different States
      target1 <- c(input$YEAR)
      target2 <- c(input$LocationAbbr)
      Status_df <- filter(mydata, YEAR %in% target1 & LocationAbbr %in% target2)
      Status_dfx<-subset(Status_df,Response==c("Current","Ever","Frequent"))
      
      # Create a table for Quit Attempts Response
      table(Status_dfx$Response)
      
      
    })
    #Explanation of Descriptive Data of Quit Attempts 
output$text2<-renderText({HTML( paste("<b>Smoking Status-Current</b> means Number of students who reported that they had smoked cigarettes on one or more days of the 30 days preceding the survey",


" <b>Smoking Status-Ever </b>means	Number of students who reported that they had ever tried smoking cigarettes, even one or two puffs.",

"<b>Smoking Status-Frequent</b> means Number of students who reported that they had smoked cigarettes on 20 or more of the 30 days preceding the survey.",

"<b>User Status-Current </b> means	Number of students who reported that they had used smokeless tobacco on one or more days of the 30 days preceding the survey.",

"<b>User Status-Ever </b> means Number of students who responded that they had ever used chewing tobacco, snuff, or dip, such as Redman, Levi Garrett, Beechnut, Skoal, Skoal Bandits, or Copenhagen.",

"<b>User Status-Frequent </b> means Number of students who reported that they had used smokeless tobacco on 20 or more of the 30 days preceding the survey.",sep="<br/>"
))})
    # Plot 1: Gender bar:
    output$Plot1 <- renderPlot({
      inFile <- input$file
      if(is.null(inFile))
        return("Please Upload A File For Analysis From Description Tab")
      mydata<- read.csv(inFile$datapath)
      attach(mydata)
      # Filter the data for different Year and different States
      target1 <- c(input$YEAR)
      target2 <- c(input$LocationAbbr)
      G1 <- filter(mydata, YEAR %in% target1 & LocationAbbr %in% target2)
      G1x<-subset(G1,Gender==c("Male","Female"))
      # Render a barplot
      library(ggplot2)
      
      ggplot(G1x) + geom_bar(aes(x=Gender,fill=Gender))+theme_minimal()
      
    })
    #Plot 2 Type of Tobacco Use
    output$Plot2 <- renderPlot({
      inFile <- input$file
      if(is.null(inFile))
        return("Please Upload A File For Analysis From Description Tab")
      mydata<- read.csv(inFile$datapath)
      # Filter the data for different Year and different States
      target1 <- c(input$YEAR)
      target2 <- c(input$LocationAbbr)
      G2 <- filter(mydata, YEAR %in% target1 & LocationAbbr %in% target2)
      # Render a barplot
      library(ggplot2)
      
      ggplot(G2) + geom_point(aes(x=TopicDesc,y=Data_Value))+ facet_grid(Gender ~ .) + ylab(" Amount of Tobacco usage")+xlab("Type of Tobacco Used")
      
    })
    #Plot for Quit Tobacco
    output$Plot3 <- renderPlot({
      inFile <- input$file
      if(is.null(inFile))
        return("Please Upload A File For Analysis From Description Tab")
      mydata<- read.csv(inFile$datapath)
      # Filter the data for different Year and different States
      target1 <- c(input$YEAR)
      target2 <- c(input$LocationAbbr)
      G3 <- filter(mydata, YEAR %in% target1 & LocationAbbr %in% target2)
      G3x<-subset(G3,MeasureDesc==c("Quit Attempt in Past Year Among Current Cigarette Smokers","Percent of Current Smokers Who Want to Quit")) 
      # Render a barplot
      library(ggplot2)
      ggplot(G3x) + geom_bar(aes(x=MeasureDesc,fill=MeasureDesc))+facet_grid(Education~ .)+xlab("Quit Status")+ylab("Percentage")+theme_minimal()
      
    
      
      
    })
    
    
    
    
    
    
})

    
      
        
      
    



  
  
    
  
  
  
    
   