# Primarily developed by Tom Evans at Lund University: tom.evans@biol.lu.se
# You are welcome to use parts of this code, but please give credit when using it extensively.

# This script is to extract data from RAW text files produced
# by igotu2gpx. Parsing the text and then outputint to file.
# It uses the functions created in 'parse_igotu2gpx_txt.R' to do this.
# Further as data is extracted from each file the parent file name
# and device ID will be added as columns


# First list files from directory matching some file naming criteria
# These uses regular expressions (pattern option) to search for
# file names matching criteria - confusing how this works, but 
# following gets files with g???txt, where ? is anything.
# This will return the files such as g01.txt
files <- list.files(path = 
                      "D:/Dropbox/Guillemots/2015/GPS_data/IGU_files_2015/files_02",
                    pattern = "g.._details.txt",
                    all.files = FALSE,
                    full.names = FALSE, recursive = FALSE,
                    ignore.case = FALSE, include.dirs = FALSE)

# View what file are found
files

# Vector of device IDs
fun.wrap <- function(x){
  # strsplit(x, split = ".txt" )[[1]][1]
  substr(x, 1, 3)
}
  
devices <- sapply(X = files, FUN = fun.wrap)
names(devices) <- NULL


# Source functions
source("parse_igotu2gpx_txt.R")

# Parse all files
n <- length(files)

parse.list <- list()

for(i in 1:n){
  x <- parse.file(paste(
    # "D:/Dropbox/guillemot_2014_data/igotu2gpx_files/",
    "D:/Dropbox/Guillemots/2015/GPS_data/IGU_files_2015/files_02/",
    files[i], sep = ""))
  x <- cbind(x,devices[i],files[i])
  parse.list[[i]] <- x
}

# Combine all into single data frame
points.df <- do.call("rbind", parse.list)

# Rename some fields
names(points.df)[12] <- "device_info_serial"
names(points.df)[13] <- "file_name"

# str(points.df)




# Write to database
library("RODBC")
gps.db <- odbcConnectAccess2007('D:/Dropbox/tracking_db/murre_db/murre_db.accdb')

# Remove points that don't have a date_time
points.df.f <- points.df[!is.na(points.df$date_time),]

# Get data in order
points.df.f <- points.df.f[order(points.df.f$device_info_serial,
                                 points.df.f$date_time),]

# Re-order df columns
cols <- names(points.df.f)
first.cols <- c("device_info_serial",
                "date_time")
f <- cols %in% first.cols
points.df.f.ordered <- points.df.f[,c(first.cols,cols[!f])]
row.names(points.df.f.ordered) <- NULL

# Correct names - so they match those in the DB table
names(points.df.f.ordered) <- c(
  "device_info_serial", "date_time",
  "recnum", "latitude", "longitude",
  "elev", "speed_ms","course",
  "ehpe", "sat_n",   "timeout",
  "MSVs_QCN", "file_name"
)

# hist(points.df.f.ordered$elev[points.df.f.ordered$elev < 500])

#will be neccessary to edit table in Access after to define data-types and primary keys and provide descriptions for each variable.
sqlSave(gps.db, points.df.f.ordered,
        tablename = "guillemots_gps_points_igu2",
        append = FALSE, rownames = FALSE, colnames = FALSE,
        verbose = FALSE, safer = TRUE, addPK = FALSE, fast = TRUE,
        test = FALSE, nastring = NULL,
        varTypes =  c(date_time = "datetime")
        )

