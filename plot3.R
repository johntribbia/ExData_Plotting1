
## Load packages
library(dplyr)
library(tidyr)

## Set working directory where you want to store the unzipped datafile
wd <- "/Users/john.tribbia/Desktop/Desktop_FINAL/Data_Science_Coursera/Exploratory_Data_Analysis/week_1/ProgrammingAssignment"
setwd(wd)
## Unzip and Extract data from url
temp <- tempfile()
filename <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(filename, temp, mode = "wb")
unzip(temp)

## import data, keep headers, recode na.strings from "?" to NA, and assign character or numeric to imported variables
df <- tbl_df(read.table("./household_power_consumption.txt",sep = ";", header = TRUE,
                        na.strings = "?", colClasses = c('character','character','numeric',
                                                         'numeric','numeric','numeric','numeric',
                                                         'numeric','numeric')))
# reclass date using as.Date()
df$Date <- as.Date(df$Date, '%d/%m/%Y') 

## subset data for dates ranging between 2007-02-01 to 2007-02-02
date1 <- as.Date("2007-2-1") 
date2 <- as.Date("2007-2-2")  

plot_df <- df %>%
  filter(Date >= date1 & Date <= date2)

## create a datetime variable using the Date and Time columns. 
plot_df$Date_Time <- strptime(paste(plot_df$Date,plot_df$Time),format = "%Y-%m-%d %H:%M:%S")

# make sure Date_Time is class POSIXt
class(plot_df$Date_Time)
head(plot_df$Date_Time)

## Plot 3 (time series, three variables)
plot(plot_df$Date_Time,plot_df$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(plot_df$Date_Time,plot_df$Sub_metering_2, col = "Red")
lines(plot_df$Date_Time,plot_df$Sub_metering_3, col = "Blue")
legend("topright",c("Sub_metering_1 ","Sub_metering_2 ","Sub_metering_3 "),col = c("black","red","blue"),lty=c(1,1),lwd=c(1,1), cex = 0.5)
## Save file and close device
dev.copy(png,"plot3.png", width=480, height=480)
dev.off()