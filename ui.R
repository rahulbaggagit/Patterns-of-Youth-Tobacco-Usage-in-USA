library(shiny)
library(leaflet)
library(shinythemes)


# Define UI for application that defines patterns of tobacco use in USA
shinyUI(fluidPage(
  # Change the theme to cerulean
  theme = shinytheme("cerulean"),
  
  # Application title
  titlePanel("Patterns of Youth Tobacco Usage in USA"),
  
  
  #  Three sidebars for uploading files, selecting Year and State
  sidebarLayout(
    sidebarPanel(
      
      # Create a file input
      fileInput("file","Choose A CSV File Please",
                multiple = TRUE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      
      # Create a multiple checkbox for Year
       checkboxGroupInput("YEAR","Year:",
                              choices = list("2010"= 2010,"2011"= 2011,"2012"= 2012,"2013"= 2013,"2014"= 2014,"2015"= 2015,
                                          "2016"= 2016,"2017" = 2017),selected = c(2010,2011,2012,2013,2014,2015,2016,2017)),
      
     # 1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012

      #Create a State multiple Selection input 
      selectizeInput("LocationAbbr", "State", choices = list("AL"="AL" ,"AR"= "AR","AZ"= "AZ","CA"= "CA",
                                                   "CO"= "CO","CT"= "CT","FL"= "FL","GA"="GA","IA"="IA",
                                                   "ID"="ID","IL"="IL","IN"="IN","KS"="KS","KY"="KY","LA"="LA",
                                                   "MA"="MA","MD"="MD","ME"="ME","MI"="MI","MN"="MN","MO"="MO","MS"="MS","MT"="MT","NC"="NC","ND"="ND",
                                                   "NE"="NE","NH"="NH","NJ"="NJ","NM"="NM","NY"="NY","OH"="OH","OK"="OK","OR"="OR","PA"="PA","PR"="PR","SC"="SC",
                                                   "SD"="SD","TN"="TN","TX"="TX","UT"="UT","VA"="VA","WA"="WA","WI"="WI","WV"="WV","WY"="WY"), selected =c("AL"="AL" ,"AR"= "AR","AZ"= "AZ","CA"= "CA",
                                                                                                                                                           "CO"= "CO","CT"= "CT","FL"= "FL","GA"="GA","IA"="IA",
                                                                                                                                                           "ID"="ID","IL"="IL","IN"="IN","KS"="KS","KY"="KY","LA"="LA",
                                                                                                                                                           "MA"="MA","MD"="MD","ME"="ME","MI"="MI","MN"="MN","MO"="MO","MS"="MS","MT"="MT","NC"="NC","ND"="ND",
                                                                                                                                                           "NE"="NE","NH"="NH","NJ"="NJ","NM"="NM","NY"="NY","OH"="OH","OK"="OK","OR"="OR","PA"="PA","PR"="PR","SC"="SC",
                                                                                                                                                           "SD"="SD","TN"="TN","TX"="TX","UT"="UT","VA"="VA","WA"="WA","WI"="WI","WV"="WV","WY"="WY"), multiple = TRUE,
                     options = list("AL"="AL" ,"AR"= "AR","AZ"= "AZ","CA"= "CA",
                                    "CO"= "CO","CT"= "CT","FL"= "FL","GA"="GA","IA"="IA",
                                    "ID"="ID","IL"="IL","IN"="IN","KS"="KS","KY"="KY","LA"="LA",
                                    "MA"="MA","MD"="MD","ME"="ME","MI"="MI","MN"="MN","MO"="MO","MS"="MS","MT"="MT","NC"="NC","ND"="ND",
                                    "NE"="NE","NH"="NH","NJ"="NJ","NM"="NM","NY"="NY","OH"="OH","OK"="OK","OR"="OR","PA"="PA","PR"="PR","SC"="SC",
                                    "SD"="SD","TN"="TN","TX"="TX","UT"="UT","VA"="VA","WA"="WA","WI"="WI","WV"="WV","WY"="WY")),
            
      hr(),
      helpText("Please Select The State You Want To Analyze For Youth Tobacco Use"),
      helpText("You Can Choose More Than One")
    ),
    
    # Make the sidebar on the right of the webpage
    position = "right",
    fluid = TRUE,
    
    
    
    # Show a plot of the generated distribution
    mainPanel(
      hr(),
      tabsetPanel(type="tabs",
                  #Add a tab for Problem Description
                  tabPanel("Problem Description", htmlOutput("text")),
                  #Tab for the Leaflet Map
                  tabPanel("Map", leafletOutput("map", height=630)),
                  #Add a tab for decriptive table
                  tabPanel("Descriptive Analysis",
                           #Add two sub tabs
                           tabsetPanel(
                             #tab panel for Education Level
                             tabPanel("Education Level",verbatimTextOutput("table1")),
                            #tab panel for Current smoking status     
                            tabPanel("Smoking Status",verbatimTextOutput("table2"),verbatimTextOutput("table3"),htmlOutput("text2"))
                                    
                      )
                           
  ),
  #Plot tabs
  
  tabPanel("Plots",
           
               tabsetPanel(
                 tabPanel("Gender",plotOutput("Plot1")),
                 tabPanel("Tobacco Use",plotOutput("Plot2")),
                 tabPanel("Quit Tobacco",plotOutput("Plot3")))))
  
       
    )
  )
))



