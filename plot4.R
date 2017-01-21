
## Load packages
library(dplyr)
library(tidyr)

## Set working directory where you want to store the unzipped datafile
wd <- "/Users/user.name/FilePath"
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

## Plot 4 (combined plots, four plots)
# set up plotting panel with dimensions, margins, and outer margin area
par(mfrow=c(2,2),mar = c(4,4,2,1), oma = c(0,0,2,0))
# top left plot
with(plot_df,plot(Date_Time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
# top right plot
with(plot_df,plot(Date_Time, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))
# bottom left plot
plot(plot_df$Date_Time,plot_df$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(plot_df$Date_Time,plot_df$Sub_metering_2,xlab = "", ylab = "Sub_metering_2", col = "red")
lines(plot_df$Date_Time,plot_df$Sub_metering_3, ylab = "Sub_metering_3",  col = "blue")
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), bty="n", cex=.5) 
# bottom right plot
with(plot_df,plot(Date_Time, Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power"))

## Save file and close device
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()
