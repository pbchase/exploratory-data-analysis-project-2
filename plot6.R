# plot6.R
# A script to process PM2.5 Emissions Data

# Download data file
dataFile <- "exdata_data_NEI_data.zip"
if (!file.exists(dataFile)){
    print("Downloading data file")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", dataFile, "curl")
} else {
    print("File already exists locally")
}

# Extract the contents of the zip file
unzip(dataFile)

# load the pair of data frames
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")


# Question:
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips ==
# "06037"). Which city has seen greater changes over time in motor vehicle
# emissions?

library(ggplot2)
library(dplyr)

# Determine which SCC codes describe the sources of interest
sector_levels<-levels(scc$EI.Sector)
vehicle_sectors <- sector_levels[grep('Vehicle',sector_levels, ignore.case=TRUE)]
vehicle_SCC <- subset(scc, EI.Sector %in% vehicle_sectors, select=SCC)

# Create a data frame of county fips codes to help us label the plot
<- factor(
labels <- c("Baltimore City", "Los Angeles County")
levels <- c("24510", "06037"))

# Subset the data to contain just the locations of interest
locations <- subset(nei, fips %in% c("24510", "06037"))

# Subset the sources of interest by the SCC codes (AKA sources) of interest
vehicles <- subset(locations, SCC %in% vehicle_SCC$SCC)

# Label the county data so our plot panels will get correctly labeled
vehicles$county <- factor(vehicles$fips, levels <- c("24510", "06037"), labels <- c("Baltimore City", "Los Angeles County"))

# Group the data so we will be able to plot by year and county
groups <- group_by(vehicles, year, county)

# Summarize the data element we want to plot: emissions
grouped_emissions <- summarize(groups, total_emissions = sum(Emissions))

# Save the plot to a PNG
# The plot must show facets for each county.
# Each facet must show a graph of annual motor vehicle
# emissions to demonstrate change in PM2.5 over time
png(file="plot6.png", bg="transparent", width = 480, height = 480, units = "px",)
qplot(year, total_emissions, data=grouped_emissions, facets = . ~ county,
    ylab="Annual PM2.5 Emissions", xlab="Year",
    main="Total Motor Vehicle PM2.5 Emissions in Baltimore City vs Los Angeles by Year")
dev.off()
