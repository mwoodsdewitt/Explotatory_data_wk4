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
# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

# seperating out emissions out for Baltimore by type... and year
emissions_baltimore_type <- NEI %>% 
  subset(fips == "24510") %>% 
  group_by(year, type) %>% 
  summarize(emissions_baltimore_type = sum(Emissions, na.rm=TRUE))

#plot in ggplot2

install.packages("ggplot2")
library(ggplot2)

plot_emissions_baltimore_type <- ggplot(data = emissions_baltimore_type,
                                        aes(year, emissions_baltimore_type))

plot_emissions_baltimore_type <- plot_emissions_baltimore_type + 
  geom_point(color="black",
             size = 3,
             alpha = 1/4) +
  facet_grid(.~type)+
  xlab("Year") +
  ylab("Total Emissions in Tons") +
  ggtitle("Total Emissions in Baltimore by Year and Type")

plot_emissions_baltimore_type

#per the charts there is visual evidence that non-road, nonpoint and on-road types have seen a decrease between 1999 and 2008 in Baltimore, MD; point has seen an increase.
