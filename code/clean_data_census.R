library(readr)
library(tools)
library(tidyverse)
library(plyr)
library(data.table)
library(ggplot2)
library(maps)
library(leaflet)
library(tigris)
library(sp)

# load "cols of interest"

setwd('/Users/agifford/Google Drive/Personal/NSS_DS_my_stuff_only/my_flexDash')

data_loc <- '/Users/agifford/Google Drive/Personal/NSS_DS_my_stuff_only/my_flexDash/data/census/acs_5yr/'


# READ IN EDUCATION
# ---------------------------------------------------------------------------------------

cols_for_educ_1 <- read.csv('./data/census/acs_5yr/cols_of_interest_5YR_education_10.csv', 
                          header = TRUE, stringsAsFactors = FALSE)
cols_for_educ_2 <- read.csv('./data/census/acs_5yr/cols_of_interest_5YR_education_11_to_14.csv', 
                          header = TRUE, stringsAsFactors = FALSE)
cols_for_educ_3 <- read.csv('./data/census/acs_5yr/cols_of_interest_5YR_education_15_16.csv', 
                                header = TRUE, stringsAsFactors = FALSE)

setwd(paste(data_loc,'education/', sep = ''))
dataframes_educ <- list.files(path = '.', pattern="*.csv")
file_names_educ <- file_path_sans_ext(dataframes_educ)
list_df_educ <- llply(dataframes_educ, read.table, header = T, sep = ",")

for ( i in 1:length(file_names_educ)) {
  name_educ <- file_names_educ[i]
  tmp_df <- list_df_educ[[i]]
  if ( i == 1 ){
    col_use <- cols_for_educ_1
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(name_educ, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  else if ( i == 2 || i == 3 || i == 4 || i == 5) {
    col_use <- cols_for_educ_2
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(name_educ, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  else {
    col_use <- cols_for_educ_3
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(name_educ, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  
}


# READ IN HOUSING
# ---------------------------------------------------------------------------------------

setwd(data_loc)

cols_for_home_1 <- read.csv('./cols_of_interest_5YR_housing_10_to_12.csv', 
                            header = TRUE, stringsAsFactors = FALSE)
cols_for_home_2 <- read.csv('./cols_of_interest_5YR_housing_13_to_14.csv', 
                            header = TRUE, stringsAsFactors = FALSE)
cols_for_home_3 <- read.csv('./cols_of_interest_5YR_housing_15_to_16.csv', 
                            header = TRUE, stringsAsFactors = FALSE)

setwd(paste(data_loc,'housing/', sep = ''))
dataframes_home <- list.files(path = '.', pattern="*.csv")
file_names_home <- file_path_sans_ext(dataframes_home)
list_df_home <- llply(dataframes_home, read.table, header = T, sep = ",")

for ( i in 1:length(file_names_home)) {
  name_home <- file_names_home[i]
  tmp_df <- list_df_home[[i]]
  if ( i == 1 || i == 2 || i == 3 ){
    col_use <- cols_for_home_1
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(name_home, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  else if ( i == 4 || i == 5) {
    col_use <- cols_for_home_2
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(name_home, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  else {
    col_use <- cols_for_home_3
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(name_home, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  
}


# READ IN INCOME & HEALTH INSURANCE
# ---------------------------------------------------------------------------------------

setwd(data_loc)

cols_for_incm_ins_1 <- read.csv('./cols_of_interest_5YR_income_healthIns_10_to_12.csv', 
                                header = TRUE, stringsAsFactors = FALSE)
cols_for_incm_ins_2 <- read.csv('./cols_of_interest_5YR_income_healthIns_13_to_16.csv', 
                                header = TRUE, stringsAsFactors = FALSE)

setwd(paste(data_loc,'income_healthIns/', sep = ''))
dataframes_incm_hins <- list.files(path = '.', pattern="*.csv")
file_names_incm_hins <- file_path_sans_ext(dataframes_incm_hins)
list_df_incm_hins <- llply(dataframes_incm_hins, read.table, header = T, sep = ",")

for(i in 1:length(file_names_incm_hins)) {
  nam_incm_hins <- file_names_incm_hins[i]
  tmp_df <- list_df_incm_hins[[i]]
  if(i == 1 || i == 2 || i == 3){
    col_use <- cols_for_incm_ins_1
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(nam_incm_hins, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  else {
    col_use <- cols_for_incm_ins_2
    col_c <- col_use$col_code
    col_name <- col_use$short_desc
    assign(nam_incm_hins, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
  }
  
}

# READ IN POPULATION
# ---------------------------------------------------------------------------------------

setwd(data_loc)

cols_for_pop_1 <- read.csv('./cols_of_interest_5YR_population_10_to_16.csv', header = TRUE, stringsAsFactors = FALSE)

setwd(paste(data_loc,'population/', sep = ''))
dataframes_pop <- list.files(path = '.', pattern="*.csv")
file_names_pop <- file_path_sans_ext(dataframes_pop)
list_df_pop <- llply(dataframes_pop, read.table, header = T, sep = ",")

for ( i in 1:length(file_names_pop)) {
  name_pop <- file_names_pop[i]
  tmp_df <- list_df_pop[[i]]
  col_use <- cols_for_pop_1
  col_c <- col_use$col_code
  col_name <- col_use$short_desc
  assign(name_pop, subset(tmp_df, select = names(tmp_df) %in% col_c) %>% setnames(., old=col_c, new=col_name))
}



# ADD YEAR COLUMN
# ---------------------------------------------------------------------------------------
# Add a column called "year" that indicates which year these data are from
#     - this is done as preparation to row-bind all the data together

ACS_10_5YR_DP03$year <- rep(2010,nrow(ACS_10_5YR_DP03))
ACS_11_5YR_DP03$year <- rep(2011,nrow(ACS_11_5YR_DP03))
ACS_12_5YR_DP03$year <- rep(2012,nrow(ACS_12_5YR_DP03))
ACS_13_5YR_DP03$year <- rep(2013,nrow(ACS_13_5YR_DP03))
ACS_14_5YR_DP03$year <- rep(2014,nrow(ACS_14_5YR_DP03))
ACS_15_5YR_DP03$year <- rep(2015,nrow(ACS_15_5YR_DP03))
ACS_16_5YR_DP03$year <- rep(2016,nrow(ACS_16_5YR_DP03))

fullDF_incm_health$year = as.factor(fullDF_incm_health$year)

# ROW BIND ALL MATRICES TOGETHER
# ---------------------------------------------------------------------------------------
fullDF_incm_health <- bind_rows(ACS_10_5YR_DP03, ACS_11_5YR_DP03, ACS_12_5YR_DP03, 
                                ACS_13_5YR_DP03, ACS_14_5YR_DP03, ACS_15_5YR_DP03, ACS_16_5YR_DP03)


# PLOTTING

dav <- tracts(state = 'TN', county = 'Davidson')
plot(dav)

sub_year <- subset(fullDF_incm_health, year == 2016)

dav_merged <- geo_join(dav, sub_year, 'GEOID','census_tract')

pal <- colorQuantile("Greens", NULL, n = 6)

popup <- paste0("Median household income: ", as.character(dav_merged$health_ins_no_coverage))

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = dav_merged, 
              fillColor = ~pal(dav_merged$health_ins_no_coverage), 
              fillOpacity = 0.7, 
              weight = 0.2, 
              smoothFactor = 0.2, 
              popup = popup) %>%
  addLegend(pal = pal, 
            values = dav_merged$health_ins_no_coverage, 
            position = "bottomright", 
            title = "Income in Davidson - 2016")



# PLOTTING 2

ggplot(sub_year, aes(x=health_ins_no_coverage, y=household_income_median)) + geom_point()



by_year <- fullDF_incm_health %>% group_by(year)

ggplot( by_year, aes(x=year, y=per_capita_income)) + geom_boxplot()



