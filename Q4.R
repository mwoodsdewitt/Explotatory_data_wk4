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

#Question 4
#Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

#Determine emissions from coal combustion-related sources
#Which scc codes are associated with coal
scc.coal <-  SCC[grep("[Cc]oal",SCC$EI.Sector),]

nei.coal <- merge(x=NEI,
                  y=scc.coal,
                  by.x = "SCC",
                  by.y = "SCC")

nei.coal_sum <- nei.coal %>% 
  group_by(year) %>% 
  summarize(total.coal = sum(Emissions, na.rm = TRUE))

#Calcuate coal emissions in 1999 and 2008
coal_emission_2008 <- nei.coal_sum[nei.coal_sum$year==2008,2]
coal_emission_1999 <- nei.coal_sum[nei.coal_sum$year==1999,2]
coal_diff_emissions <- coal_emission_2008 - coal_emission_1999
coal_diff_emissions

# coal_diff_emissions
# 1           -228694.3
# emissions from coal decreased by 228694.3 tons between 1999 and 2008

#Plot
coal.plot <- ggplot(nei.coal_sum, 
                    aes(year, total.coal))

coal.plot <- coal.plot +
  geom_point(color="black",
             size = 3,
             alpha = 1/4) +
  xlab("Year") +
  ylab("Total Emissions in Tons") +
  ggtitle("Total Emissions From Coal Combustion in the US")

coal.plot