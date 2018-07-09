library(shiny)
library(shinydashboard)
library(forecast)
library(tseries)

shinyServer(function(input, output){
  #########################################################
  output$contents<- renderTable({
    req(input$file1)
    Upload_file <- read.csv(input$file1$datapath,
                     header = TRUE,
                     sep = ",",stringsAsFactors = FALSE
      )
   # output$summ <- renderTable(summary(Upload_file))
    ######################################################3
    
  # Upload_file <- read.csv(file.choose(), header = TRUE)     
  # head(Upload_file)
    frequencyChoices <- c("Days" = "Daily",
                          "Weeks" = "Weekly", 
                          "Months" = "Monthly")
  Upload_file$New_date <- as.Date(Upload_file$DATE, "%d-%m-%Y")
  
  min_year <- as.numeric(format(min(Upload_file$New_date), "%Y"))
  min_month <- as.numeric(format(min(Upload_file$New_date), "%m"))
  
  max_year <- as.numeric(format(max(Upload_file$New_date), "%Y"))
  max_month <- as.numeric(format(max(Upload_file$New_date), "%m"))
  Upload_file.ts <- ts(Upload_file$VALUE, start = c(min_year,min_month), end = c(max_year,max_month
  ), frequency = 12 )
  
  
  
  Upload_file.ts <- ts(Upload_file$VALUE, start = c(min_year,min_month), end = c(max_year,max_month
  ), frequency = 12 )
  
  #plot(Upload_file.ts)
  hw.infl <- HoltWinters(Upload_file.ts)
  hw.infl
  
  #############arima model################
  
  auto_upload <- auto.arima(Upload_file.ts)
  fit_resid = residuals(auto_upload)
  
  Ljungboxtest <-Box.test(fit_resid, lag = 10, type = "Ljung-Box")
  
  forecast_upload <- forecast(auto_upload, h=20)
  
  ######## Primitive basic models ##############
  
  naive_uploadfile <- snaive(Upload_file.ts, h=20)
  mean_uploadfile <- meanf(Upload_file.ts, h=20)
  drift_uploadfile <- rwf(Upload_file.ts, h=20, drift = T)
  
  output$naive.uploadfile <- renderTable(naive_uploadfile)
  output$mean.uploadfile <- renderTable(mean_uploadfile)
  output$drift.uploadfile <- renderTable(drift_uploadfile)
  
  #############################################
  
  # infl.pred <- predict(hw.infl, n.ahead = 12, prediction.interval = TRUE)
  infl.pred <- forecast(hw.infl, h=12)
  
  ###################################################
  
  output$infl_pred <- renderTable(infl.pred)
  
  ######################################################
  
  output$histogram <- renderPlot({ plot(mean_uploadfile, main ="")
    lines(naive_uploadfile$mean, col = "green")
    lines(drift_uploadfile$mean, col = "red")})
  
  output$primitive_forecast <- renderPlot( { plot(naive_uploadfile$mean, col = "black")
    lines(mean_uploadfile$mean, col = "green")
    lines(drift_uploadfile$mean, col = "red")})
  
  ##########################################################
  
  output$autoarima <- renderPlot({plot(forecast_upload)})
  
  ################################################################
  
  output$Holts_winters<- renderPlot({plot(infl.pred)
    # plot(infl.pred[,1], col = "darkred") # Forecasted
    # lines(infl.pred[,2], col = "blue")
    # lines(infl.pred[,3], col = "black")
  }) 
  
  #Accuracy Functions#######################################
  # Acc_holt <- accuracy(infl.pred)
  output$acc_holts <- renderTable(accuracy(infl.pred))
  output$acc_mean <- renderTable(accuracy(mean_uploadfile))
  output$acc_naive <- renderTable(accuracy(naive_uploadfile))
  output$acc_drift <- renderTable(accuracy(drift_uploadfile))
  output$acc_autoarima <- renderTable(accuracy(forecast_upload))
  output$auto_arima_used <- renderPrint(auto_upload)
  output$Ljung_box <- renderPrint(Ljungboxtest)
})
})
################################################################

# output$fitted_value <- renderPlot({plot(Upload_file.ts, col = "red")
#   lines(hw.infl$fitted[,1], col = "green")
#   lines(infl.pred[,1], col = "blue")
#   lines(infl.pred[,2], col = "black")
#   lines(infl.pred[,3], col = "black")})


#############################################################



#Upload_file <- 
#read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE)
#head(Upload_file)

##Upload_file$New_date <- as.Date(Upload_file$DATE, "%d-%m-%Y")




