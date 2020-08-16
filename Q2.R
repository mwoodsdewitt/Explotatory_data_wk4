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

#Question 2
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
#  (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# seperating out emissions out for Baltimore
emissions_baltimore <- NEI %>% 
  subset(fips == "24510") %>% 
  group_by(year) %>% 
  summarize(emissions_baltimore = sum(Emissions, na.rm=TRUE))

#Calcuate Baltimore emissions in 1999 and 2008
balt_emission_2008 <- emissions_baltimore[emissions_baltimore$year==2008,2]
balt_emission_1999 <- emissions_baltimore[emissions_baltimore$year==1999,2]
balt_diff_emissions <- balt_emission_2008 - balt_emission_1999
balt_diff_emissions

# emissions_baltimore
# 1           -1411.898
# emissions in Baltimore decreased by 1412 tons between 1999 and 2008

#creating a plot for Baltimore
with(emissions_baltimore,
     plot(x = year,
          y = emissions_baltimore,
          ylab = "Total Annual Emissions in Tons",
          xlab = "Year",
          main = "Total Annual Emissions for Baltimore, MD",
          cex = 2,
          pch = 19,
          col = 51,
          lwd =2
     ))