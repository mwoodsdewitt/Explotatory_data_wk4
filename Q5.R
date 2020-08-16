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

# Question 5
#How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
vehicles <- SCC[grep("[Vv]eh", SCC$Short.Name),]
baltimore <- NEI %>% 
  subset(fips == "24510")

vehicles.baltimore <- merge(x=baltimore,
                            y=vehicles,
                            by.x = "SCC",
                            by.y = "SCC")

vehicles.baltimore_emissions <- vehicles.baltimore %>% 
  group_by(year) %>% 
  summarize(vehicle.emissions = sum(Emissions, na.rm = TRUE))
#Calcuate baltimore vehicle emissions in 1999 and 2008
vehicle_emission_2008 <- vehicles.baltimore_emissions[vehicles.baltimore_emissions$year==2008,2]
vehicle_emission_1999 <- vehicles.baltimore_emissions[vehicles.baltimore_emissions$year==1999,2]
vehicle_diff_emissions <- vehicle_emission_2008 - vehicle_emission_1999
vehicle_diff_emissions

# vehicle_diff_emissions
# 1           -258.5445
# emissions from vehicles in Baltimore, MD decreased by 258.5445 tons between 1999 and 2008

# Plot
vehicles_plot <- ggplot(vehicles.baltimore_emissions,
                        aes(year,vehicle.emissions))

vehicles_plot <- vehicles_plot +
  geom_point(color="black",
             size = 3,
             alpha = 1/4) +
  xlab("Year") +
  ylab("Total Emissions in Tons") +
  ggtitle("Total Vehicle Emissions in Baltimore, MD")

vehicles_plot