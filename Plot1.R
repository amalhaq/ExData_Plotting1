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


par(mar=c(4.2,4.2, 2.1, 2.1), bg = "gray56")#setting graphical parameter for plot

#Piecemeal construction of histogram; 'ylim' is necessary to set upper/lower limits of y axis
hist(subframe$Global_active_power, col= "red", main = "Global Active Power", 
     xlab= "Global Active Power (kilowatts)", ylim = c(0, 1200)) 

#exporting image in screen device to png file.
dev.copy(png,file="Project1/Plot1.png") 
dev.off()
