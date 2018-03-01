

# PLOTTING

ggplot(bp_data) + geom_bar(aes(x=Description, fill=Year)) + 
  scale_x_discrete(limits = (bp_data %>% count(Description)
                             %>% arrange(n))$Description) +
  coord_flip()



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



