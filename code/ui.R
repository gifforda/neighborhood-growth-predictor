ui <- fluidPage(
  
  # titlePanel() not only adds a visible big title-like text to the top of the page, 
  #   but it also sets the “official” title of the web page. Unless you use the 
  #   argument windowTitle
  titlePanel("Nashville Construction - Where should we (not) move?", windowTitle = "Nashville Construction"),
  
  # sidebarLayout() provides a simple two-column layout with a smaller sidebar and a larger main panel.
  sidebarLayout(
    sidebarPanel("Filter data based on the following values:\n",
                 # Inputs are what gives users a way to interact with a Shiny app. 
                 # All input functions have the same first two arguments: inputId and label.
                 # inputId == the name Shiny will use to refer to this input when you want to retrieve its current value. 
                 #            each inputId MUST be UNIQUE
                 # label == specifies the text in the display label that goes along with the input widget. 
                 
                 # Residential or Commerical?
                 radioButtons("res_or_com", label = "Residential or Commercial", 
                                    choices = unique(dataset$Building_Type)),
                 
                 # What type of permit?
                 selectInput("bp_type", label = "Permit Type", 
                             choices = unique(dataset$Description)),
                 
                 # What year?
                 sliderInput("const_year", label = "Year", 
                             min = 2015, max = 2018, value = c(2016, 2017), sep = ""),
                 
                 # What price?
                 sliderInput("const_price", label = "Cost", min = 0, max = 1000000,
                             value = c(100000, 500000), pre = "$")
                 ),
    mainPanel(
      tableOutput('table')
              )
  )
)

