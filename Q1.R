#reading in the file 
working_file <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destination_file <- "destfile.zip"

if(!file.exists(destination_file)) {
  download.file(working_file, 
                destfile = destination_file, 
                method = "curl")
  unzip(destfile1, exdir = ".")
}


NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Question 1
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#Calculate total emissions by year
total_emissions_year <- NEI %>%  
  group_by(year) %>%
  summarize(Total.Emissions = sum(Emissions, na.rm = TRUE))
#Calcuate emissions in 1999 and 2008
emission_2008 <- total_emissions_year[total_emissions_year$year==2008,2]
emission_1999 <- total_emissions_year[total_emissions_year$year==1999,2]
diff_emissions <- emission_2008 - emission_1999
diff_emissions
#Total.Emissions
#1        -3868761
#  emissions decreased by 3.8M tons

#Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.


#Plot total emissions by year
with(total_emissions_year,
     plot(x = year,
          y = Total.Emissions,
          ylab = "Total Annual Emissions in Tons",
          xlab = "Year",
          main = "US Total Annual Emissions",
          cex = 2,
          pch = 19,
          col = 51,
          lwd =2
     ))
