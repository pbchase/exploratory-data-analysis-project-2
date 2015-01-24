# plot2.R
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
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.

# subset the emissions to just Baltimore City and sum all sources by year.
baltimore <- subset(nei, fips == "24510")
emissions_by_year <- tapply(baltimore$Emissions, baltimore$year, FUN=sum)

# Plot the Baltimore emissions data by year
png(file="plot2.png", bg="transparent")
barplot(emissions_by_year, ylab="Total Emissions", xlab="Year",
        main="Total PM2.5 Emissions in Baltimore from All Sources by Year")
dev.off()
