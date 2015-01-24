# plot3.R
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
# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in
# emissions from 1999–2008 for Baltimore City? Which have seen increases in
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot
# answer this question.

library(ggplot2)
library(dplyr)

# subset the data to just Baltimore data
baltimore <- subset(nei, fips == "24510")
# create Groups of fdata by year and type
groups <- group_by(baltimore, year, type)
# Sum all sources in each group
grouped_emissions <- summarize(groups, total_emissions = sum(Emissions))

# plot the Baltimore emissions data by year and type
png(file="plot3.png", bg="transparent", width = 960, height = 480, units = "px",)
qplot(year, total_emissions, data=grouped_emissions, ylab="Total PM2.5 Emissions",
    xlab="Year", main= "Annual PM2.5 Emissions in Baltimore by Source", facets = . ~ type)
dev.off()
