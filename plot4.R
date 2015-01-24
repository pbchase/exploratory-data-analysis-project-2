# plot4.R
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
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

library(ggplot2)
library(dplyr)

# Determine which SCC codes describe the sources of interest
sector_levels<-levels(scc$EI.Sector)
coal_sectors <- sector_levels[grep('Coal',sector_levels, ignore.case=TRUE)]
coal_SCC <- subset(scc, EI.Sector %in% coal_sectors, select=SCC)

# Subset the sources of interest by the SCC codes (AKA sources) of interest
coal <- subset(nei, SCC %in% coal_SCC$SCC)
# Group the data so we will be able to plot by year
groups <- group_by(coal, year)

# Summarize the data element we want to plot: emissions
grouped_emissions <- summarize(groups, total_emissions = sum(Emissions))

# Save the plot to a PNG
# the plot must show annual motor vehicle
# emissions to demonstrate change in PM2.5 over time
png(file="plot4.png", bg="transparent", width = 480, height = 480, units = "px",)
qplot(year, total_emissions, data=grouped_emissions, ylab="Total PM2.5 Emissions",
    xlab="Year", main= "Annual PM2.5 Emissions from Coal Combustion Sources in USA")
dev.off()
