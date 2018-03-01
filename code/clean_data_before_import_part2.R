
# CLEANING DATA PART 2

library(dplyr)
library(tidyverse)

data_in <- readRDS('./data/Building_Permits_Issued_cleaned2.rds')
df_in <- as_tibble(data_in)
df_in$Year <- as.numeric(format(df_in$Date.Issued, format = "%Y"))

# find the unique descriptions
unq_BP_Description <- as_tibble(table(df_in$BP_Description))

# rename the column
colnames(unq_BP_Description) <- c("unq_BP_Desc", "Total_Num")

# top_types <- head(unq_BP_Description[order(-unq_BP_Description$Total_Num),],10)

# pull out commercial and Residential types:
commercial <- c('Commercial  Addition','Commercial  New', 'Commercial  Rehab', 'Commercial  Tenant Finish Out')
residential <- c('Residential  Addition','Residential  New', 'Residential  Rehab', 'Residential  Tenant Finish Out')

# subset the dataframe to only contain these types
df_commercial <- df_in[df_in$BP_Description %in% commercial ,]
df_residential <- df_in[df_in$BP_Description %in% residential ,]

# df_commercial$Year <- as.factor(df_commercial$Year)
# df_residential$Year <- as.factor(df_residential$Year)

# Add a distinguishing column to each dataset
df_commercial$Building_Type <- rep("Commercial", nrow(df_commercial))
df_residential$Building_Type <- rep("Residential", nrow(df_residential))

# Replace 0's & 1's in const_cost with NA
df_commercial$const_cost[df_commercial$const_cost <= 10] <- NA
df_residential$const_cost[df_residential$const_cost <= 10] <- NA

# remove the word "Commercial" or "Residential" from the BP_Description column
# - this is so the four types "New / Rehab / Tenant Finish Out / Addition" are the same
#   between "Commercial" and "Residential"
# Also, this is possible because the two datasets are indicated as "Commercial"
# - or "Residential" by the column Building_Type
df_commercial$BP_Description <- gsub("Commercial(\\s+)", "", df_commercial$BP_Description)
df_residential$BP_Description <- gsub("Residential(\\s+)", "", df_residential$BP_Description)

df_commercial <- as_tibble(df_commercial)
df_residential <- as_tibble(df_residential)

# row bind the commercial and residential data
df_full <- rbind(df_commercial, df_residential)

# rename the columns lat_lon_1 and 2 to appropriate names
old_c_names <- c('BP_Description', 'Permit.Subtype.Description','Date.Issued','Census.Tract','const_cost','lat_lon_1','lat_lon_2')
new_c_names <- c('Description', 'Subtype','Date','CensusTract','Cost','Latitude','Longitude')
setnames(df_full, old = old_c_names, new = new_c_names)

# drop unnecessary columns
drops <- c("Permit..", "Date.Entered", "Permit.Subtype", "Permit.Type")
dataset <- df_full[ , !(names(df_full) %in% drops)]

# MAKE THE FINAL DATASET AND SAVE IT OUT:
bp_data <- dataset

# save out the file
write.csv(bp_data, file = "./data/Building_Permits_Issued_FINAL_DF.csv", row.names = FALSE)
saveRDS(bp_data, file = "./data/Building_Permits_Issued_FINAL_DF.rds")

