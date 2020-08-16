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

#Question 6
#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

#vehicles LA
la <- NEI %>% 
  subset(fips == "06037")

vehicles.la <- merge(x=la,
                     y=vehicles,
                     by.x = "SCC",
                     by.y = "SCC")

vehicles.la_emissions <- vehicles.la %>% 
  group_by(year) %>% 
  summarize(vehicle.emissions = sum(Emissions, na.rm = TRUE))

vehicles.baltimore_emissions_city <- cbind(vehicles.baltimore_emissions, "City" = rep("Baltimore",4))
vehicles.la_emissions_city <- cbind(vehicles.la_emissions, "City" = rep("LA",4))

vehicles_comb <-  rbind(vehicles.baltimore_emissions_city,vehicles.la_emissions_city)

#Calcuate LA vehicle emissions in 1999 and 2008
la_vehicle_emission_2008 <- vehicles.la_emissions[vehicles.la_emissions$year==2008,2]
la_vehicle_emission_1999 <- vehicles.la_emissions[vehicles.la_emissions$year==1999,2]
la_vehicle_diff_emissions <- la_vehicle_emission_2008 - la_vehicle_emission_1999
la_vehicle_diff_emissions

#  vehicle.emissions
# 1            163.44

#LA experienced an increase in vehicle emissions by 163.44 tons while Baltimore saw a decrease of 258.5445 tons within that same time period.
#Baltimore experienced a greater decrease in vehicle emissions

#Plot
vehicles_comb_plot <- ggplot(vehicles_comb,
                             aes(year,vehicle.emissions, col=City))
vehicles_comb_plot <- vehicles_comb_plot +
  geom_point(size = 4, 
             alpha = 1/3) +
  xlab("Year") +
  ylab("Total Emissions in Tons") +
  ggtitle("Total Vehicle Emissions: Baltimore vs Los Angeles")

vehicles_comb_plot