#Creating a new folder for the first course project in the working directory, if it
#does not exist yet
if(!file.exists("./Project1")){dir.create("./Project1")}
#Sourcing the data, only IF it has not already been downloaded
if(!file.exists("household_power_consumption.txt")){
        fileURL<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileURL, destfile="./Project1/Electric Power Consumption.zip",
                      method = "curl")
        unzip(zipfile="./Project1/Electric Power Consumption.zip", exdir="./Project1")
}

#ensure that 'data.table' package and the 'lubridate' package have been installed and 
#loaded with the install.packages(""), and library() call functions
#giving handle to text file which can be used as an argument in future functions
hshdpwr<- "Project1/household_power_consumption.txt" 
#subsetting the data from the file for speedy loading of data frame; used grep + meta
#characters for matching 
subframe<- fread(
        paste("grep ^[12]/2/2007", hshdpwr),
        na.strings = c("?", ""), stringsAsFactors = FALSE,
)
#provide column headers with a character vector
setnames(subframe, c("Date", "Time", "Global_active_power", "Global_reactive_power", 
                     "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2",
                     "Sub_metering_3"))
#the lubridate function is great for parsing character and numeric elements with the 
#fewest number of arguments
subframe$Date<- dmy(subframe$Date)
#we have to paste the date and time into a single column because lubridate needs a date
#element to parse hours, minutes, seconds
subframe$Time<- paste(subframe$Date, subframe$Time)
subframe$Time<- ymd_hms(subframe$Time)


png("Project1/Plot4.png") #setting up an external device to export plot being drawn

#setting graphical parameters; I need additional arguments this time for margins and font 
#size for the axis increments.  Also, use mfrow() or mfcol() and write code accordingly.
par(mar=c(4,4,4,2),bg = "gray56", mfcol= c(2,2), cex.axis=1.0)

#this is the first plot and is exactly the code for Plot2, except that the y label 
#does not show units (kilowatts)
plot(subframe$Time, subframe$Global_active_power, xlab = "", 
     ylab = "Global Active Power", type ="n", )
lines(subframe$Time, subframe$Global_active_power)

#this is exactly the code for Plot3; it will go in the 2nd row below the first plot
#because I used mfcol()
with(subframe, plot(subframe$Time, Sub_metering_1, xlab = "", 
                    ylab = "Energy sub metering", type ="l", lwd =1.5))
with(subframe, lines(Time, Sub_metering_2, col = "red", lwd = 1))
with(subframe, lines(Time, Sub_metering_3, col = "blue", lwd = 1))
#Changed legend slightly so it fits margins, and doesn't have a box around it with 'bty'
legend("topright", pch="_", col= c("black", "red", "blue"), 
       legend= c("Sub_metering_1", "Sub_metering_2", 
                 "Sub_metering_3"), cex=1.0, bty ="n")

#straightforward plot, remember axis labels.  This plot will go in the 1st row, 
#to the right of the first plot
plot(subframe$Time, subframe$Voltage, xlab = "datetime", 
     ylab = "Voltage", type ="l")

#straightforward plot, remember axis labels. This will be in the bottom right.
plot(subframe$Time, subframe$Global_reactive_power, xlab = "datetime", 
     ylab = "Global_reactive_power", type ="l")

#close external device
dev.off()
