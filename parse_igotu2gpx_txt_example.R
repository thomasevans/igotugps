# Primarily developed by Tom Evans: thomas.jude.evans AT gmail.com

# Example of how to use functions in 'parse_igotu2gpx_txt.R'


# Source the functions from that file (assumes it is in your working directory)
source("parse_igotu2gpx_txt.R")

# Process an example file
gps_data <- parse.file("g11_details.txt")

# View the generated dataframe:
View(gps_data)

# See the data structure
str(gps_data)


# The dataframe can be output to a csv file or similar:
write.csv(gps_data, file = "g11_details_processed.csv" )


# Some example plots of how you might sort the data to exlude those where the error is high

# png("altitude_error.png")
par(mfrow=c(2,1))
# See how the variation in altitude (thus likely error) grows with increasing ehpe
plot(gps_data$elev~gps_data$ehpe, xlim = c(0,50), ylim = c(-150,150), ylab = "altitude (m)",
     xlab = "Estimated horizontal positional error (EHPE)")

# Similar for satellite number - you can see that with more satellites the spread narrows
plot(gps_data$elev~gps_data$sat_n, ylim = c(-150,150), ylab = "altitude (m)",
     xlab = "Number of satellites")
# dev.off()
