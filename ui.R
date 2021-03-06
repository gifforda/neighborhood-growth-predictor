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
                                    choices = unique(bp_data$Building_Type),
                                    inline = TRUE),
                 
                 # What type of permit?
                 selectInput("bp_type", label = "Permit Type", 
                             choices = unique(bp_data$Description)),
                 
                 # What year?
                 sliderInput("const_year", label = "Year", 
                             min = 2015, max = 2018, value = c(2016, 2017), sep = ""),
                 
                 # What price?
                 sliderInput("const_price", label = "Cost", min = 0, max = 1000000,
                             value = c(100000, 500000), pre = "$")
                 ),
    mainPanel(
      tabsetPanel(
                  tabPanel(strong("Map"),
                           br(),
                           leafletOutput(
                             outputId = "bpMap",
                             width = "100%",
                             height = "650px"
                           ),
                           br()),
                  tabPanel(strong("Data"),
                           br(),
                           DT::dataTableOutput("bpDataTable"),
                           br()),
                  tabPanel(strong("Sources"),
                           br(),
                           h4(strong("Methods")),
                           p("this is where the documentation will go."),
                           br(),
                           h4(strong("Sources")),
                           p('This is where the documentation for the data sources will go.'))
              ) # END tabsetPanel
            )  # END mainPanel
          ) # END sidebarLayout
) # END fluidPage

