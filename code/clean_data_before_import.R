library(tidyverse)

# Cleaning Building Permits Issued Data

# read in the file
tmp <- read.csv("./data/Building_Permits_Issued.csv", header = TRUE, stringsAsFactors = FALSE)

# remove a few columns that may not be useful
tmp2 <- subset(tmp, select = -c(Parcel, Subdivision.Lot, Contact, IVR.Trk., Purpose, Council.Dist))

# convert the date columns to date format
tmp2$Date.Entered <- as.Date(tmp2$Date.Entered , "%m/%d/%y")
tmp2$Date.Issued <- as.Date(tmp2$Date.Issued , "%m/%d/%y")

# DON"T NEED TO DO THIS B/C OF stringsAsFactors = FALSE
# convert the address city and state to string
# tmp2$Address <- as.character(tmp2$Address)
# tmp2$City <- as.character(tmp2$City)
# tmp2$State <- as.character(tmp2$State)

# DON"T NEED TO DO THIS B/C OF stringsAsFactors = FALSE
# convert the mapped location to a string and strip out the lat/lon pairs
# tmp2$Mapped.Location <- as.character(tmp2$Mapped.Location)

# pull out the mapped location which usually contains lat/lon pairs
j <- tmp2$Mapped.Location

# pull out the text between () - i.e. (36.13331, -86.80212)
lat_lon <- gsub("[\\(\\)]", "", regmatches(j, gregexpr("\\(.*?\\)", j)))

# convert it to a tibble so it's easier to work with
lat_lon2 <- as.tibble(lat_lon)

# for all missing values, change them to "NA,NA" - this is necessary b/c the column will be split on commas later
lat_lon2[lat_lon2$value=="character0" ,] <- "NA,NA"

# split the single column into multiple columns
lat_lon_separated <- separate(lat_lon2, "value", paste("lat_lon", 1:2, sep="_"), sep = ",", extra = "drop", fill = "left")

# change the columns to be double
lat_lon_separated$lat_lon_1 <- as.double(lat_lon_separated$lat_lon_1)
lat_lon_separated$lat_lon_2 <- as.double(lat_lon_separated$lat_lon_2)

# find the values in the second column which contain STRINGS (only ALPHA characters) but are not "NA"
#   - replace them with "NA"
for (idx in 1:NROW(lat_lon_separated)) {
  ll <- lat_lon_separated[idx , "lat_lon_2"]
  if (ll$lat_lon_2 != "NA" && grepl("^[A-Za-z]+", ll$lat_lon_2, perl = TRUE)) {
    lat_lon_separated[idx , "lat_lon_2"] <- "NA"
  }
}

# change the columns to be double
lat_lon_separated$lat_lon_1 <- as.double(lat_lon_separated$lat_lon_1)
lat_lon_separated$lat_lon_2 <- as.double(lat_lon_separated$lat_lon_2)


complete_table <- cbind(tmp2, lat_lon_separated)

complete_table <- subset(complete_table, select = -c(Mapped.Location))

# work on the descriptions
complete_table <- separate(complete_table, "Permit.Type.Description", into = paste("BP_Desc_pt", 1:2, sep = "_"), sep = '-', fill = "right")
# remove the word "Building" from the description:
complete_table$BP_Desc_pt_1 <- mapply(gsub, "Building ", "", complete_table$BP_Desc_pt_1)

# remove the NA values - set them to be blank strings
complete_table$BP_Desc_pt_2[is.na(complete_table$BP_Desc_pt_2)] <- ""

# combine the two descriptions
complete_table <- unite(complete_table, BP_Description, c(BP_Desc_pt_1, BP_Desc_pt_2), sep = "", remove=TRUE)

# change construction_cost to be numeric instead of characters
complete_table$const_cost = as.numeric(gsub("[\\$,]", "", complete_table$Const..Cost))

# drop the original const..cost column
complete_table <- subset(complete_table, select = -c(Const..Cost))

# find the unique descriptions
unq_BP_Description <- as.data.frame(unique(complete_table$BP_Description))
# rename the column
colnames(unq_BP_Description) <- c("unq_BP_Desc")


# save out the file
write.csv(complete_table, file = "./data/Building_Permits_Issued_cleaned2.csv", row.names = FALSE)
saveRDS(complete_table, file = "./data/Building_Permits_Issued_cleaned2.rds")

