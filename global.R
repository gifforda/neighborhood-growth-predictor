# Everything in here is available to anyone using the Shiny App

library(shiny)
library(DT)
library(data.table)
library(tidyverse)
library(ggplot2)
library(leaflet)

# load the data:

bp_data <- readRDS('./data/Building_Permits_Issued_FINAL_DF.rds')

