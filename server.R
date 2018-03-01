server <- function(input, output) {
  
  output$bpMap <- renderLeaflet({
    leaflet(data = bp_data[1:20,]) %>% addTiles() %>%
      addMarkers(~Longitude, ~Latitude, popup = ~as.character(Cost), label = ~as.character(Cost))
  })
  
  output$bpDataTable = DT::renderDataTable({
    filtered <- 
      bp_data %>%
      filter(Building_Type == input$res_or_com,
             Description == input$bp_type,
             Year >= input$const_year[1],
             Year <= input$const_year[2],
             Cost >= input$const_price[1],
             Cost <= input$const_price[2]
      )
    filtered[,c("Description","Subtype","Date","Cost","Year","Building_Type")]
  })
  
}