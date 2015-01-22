# plot1.R
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
# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

emissions_by_year <- tapply(nei$Emissions, nei$year, FUN=sum)

png(file="plot1.png", bg="transparent")
barplot(emissions_by_year, ylab="Total Emissions", xlab="Year",
        main="Total PM2.5 Emissions from All Sources by Year")
dev.off()
