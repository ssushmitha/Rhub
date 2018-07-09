library(devtools)
#install_github("nik01010/dashboardthemes")
library(shiny)
library(shinydashboard)
library(shinythemes)


sample <- read.csv("Superstore.csv", stringsAsFactors = FALSE)

shinyUI(
  
  dashboardPage(
    dashboardHeader(title = "Demand Forecasting",
                    tags$li(a(href = 'http://www.i2decisions.com',
                              img(src = "i2Decisionslogo.png",
                                  title = "Company Home", height = "30px"),
                              style = "padding-top:10px; padding-bottom:10px;"),
                            class = "dropdown")),
    
    dashboardSidebar(
      
      sidebarMenu(
        dateRangeInput("dateRange",
                       "Date range",
                       start = "1980-01-01",
                       end   = "2016-12-31"),
        
        numericInput("periods", "Periods to Forecast", 6, min = 1, max = 100)
       #  menuItem("RAW DATA", tabName = "rawdata"),
       # menuItem("PRIMITIVE FORECASTING", tabName = "ordinary_Forecasting", icon = icon("dashboard") ),
       # menuSubItem("PREDICTED VALUE", tabName = "primitive_predicted_value"),
       # menuItem("AUTO_ARIMA MODEL", tabName = "aUTO_ARIMA_MODEL" ),
       # menuItem("EXPONENTIAL MODEL"),
       # menuSubItem("HOLTS WINTER MODEL", tabName = "holts_wintermodel"),
       # menuSubItem("PREDICTED VALUE", tabName = "pred_summary"),
       #  menuItem("ACCURACY CHECK", tabName = "acc_chk")),
      ),
      
      # textInput(frequencyChoices <- c("Days" = "Daily","Weeks" = "Weekly", "Months" = "Monthly")),
      #sliderInput("slider_year", "Select the Year", min = 0, max = 20,value = 5, dragRange = T ),
      
      
      selectInput("Forecast", "Forecast Models",
                  choices = c("Ordinary Forecasting" = 1,"Auto Arima Model" = 2, "Exponential Model" = 3,
                              "Holts Winter Model"  = 4), selected = T),                               
      
   
      
      selectInput("frequency",
                  "Frequency",
                  choices = c("Days" = "Daily","Weeks" = "Weekly", "Months" = "Monthly"), 
                  selected = "Months")
      
    ),
    dashboardBody(
      tabItems(
        
      tabItem(tabName = "rawdata", fluidRow(box(title = "Rawdata", tableOutput("contents")))),
      tabItem(tabName = "ordinary_Forecasting",fluidRow(box( title = "Primitive Forecasting", status = "primary",
                                                               solidHeader = T,plotOutput("histogram"), width = 100),
                                                          
                                                          box(title = "Forecasted Graph", status = "primary", solidHeader = T,
                                                              plotOutput("primitive_forecast"), width = 100))),
        
      tabItem(tabName = "primitive_predicted_value",  fluidRow(box(title = "Naive predicted",status = "primary", solidHeader = T,
                                                                     tableOutput("naive.uploadfile")),
                                                                 box(title = "Mean predited",status = "primary", solidHeader = T,tableOutput("mean.uploadfile")),
                                                                 box(title = "Drift predicted",status = "primary", solidHeader = T,tableOutput("drift.uploadfile")))),
        
        tabItem(tabName = "aUTO_ARIMA_MODEL", fluidRow(box(title = "AUTO ARIMA",status = "primary", solidHeader = T,plotOutput("autoarima"), width = 100))),
        
        tabItem(tabName = "holts_wintermodel", fluidRow(#box(title = "Fitted Value", status = "primary",
          #                                                     solidHeader = T, plotOutput("fitted_value"), width = 100),
          
          box(title = "Forecasted Graph", status = "primary",
              solidHeader = T,
              plotOutput("Holts_winters"), width = 100))),
        
        tabItem(tabName = "pred_summary", fluidRow(box(title = "PREDICTED VALUE", 
                                                       status = "primary",
                                                       solidHeader = T,
                                                       tableOutput("infl_pred")))),
        
        
        tabItem(tabName = "acc_chk", fluidRow(box(title = "Holtswinter Accuracy",status = "primary",
                                                  solidHeader = T, tableOutput("acc_holts") ),
                                              box(title = "Mean Accuracy",status = "primary",
                                                  solidHeader = T, tableOutput("acc_mean")),
                                              box(title = "Naive Accuracy",status = "primary",
                                                  solidHeader = T, tableOutput("acc_naive")),
                                              box(title = "Drift Accuracy",status = "primary",
                                                  solidHeader = T, tableOutput("acc_drift")),
                                              box(title = "Auto_Arima Accuracy",status = "primary",
                                                  solidHeader = T, tableOutput("acc_autoarima")),
                                              box(title = "Auto Arima_Model Used",status = "primary",
                                                  solidHeader = T, verbatimTextOutput("auto_arima_used")),
                                              box(title = "Ljung Box Test",status = "primary",
                                                  solidHeader = T, verbatimTextOutput("Ljung_box"))
                                              
                                              ))
                
                
                
        )
      )
      
    )
  )