# plot5.R
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
# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?

library(ggplot2)
library(dplyr)

sector_levels<-levels(scc$EI.Sector)
vehicle_sectors <- sector_levels[grep('Vehicle',sector_levels, ignore.case=TRUE)]
vehicle_SCC <- subset(scc, EI.Sector %in% vehicle_sectors, select=SCC)

baltimore <- subset(nei, fips == "24510")

baltimore_vehicles <- subset(baltimore, SCC %in% vehicle_SCC$SCC)
groups <- group_by(baltimore_vehicles, year)
grouped_emissions <- summarize(groups, total_emissions = sum(Emissions))

png(file="plot5.png", bg="transparent", width = 480, height = 480, units = "px",)
qplot(year, total_emissions, data=grouped_emissions, ylab="Annual PM2.5 Emissions",
    xlab="Year", main= "Total Motor Vehicle PM2.5 Emissions in Baltimore City by Year")
dev.off()
