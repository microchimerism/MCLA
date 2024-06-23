##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


#########################################
####### Set date of data download #######
#########################################

date_data = "2024_03_27"

########################
######## GLOBAL ########
########################

######## Setup Environment

Sys.setenv(LANGUAGE = "en")

# R packages
library(xlsx)
library(dplyr)
library(tidyr)
library(readxl)
library(igraph)
library(network)
library(stringr)
library(visNetwork)
library(wordcloud2)  # remotes::install_github("lchiffon/wordcloud2")

# Shiny packages
library(DT)
library(shiny)
library(shinyjqui)
library(shinyEffects)
library(shinyWidgets)
library(shinydashboard)
library(shinycssloaders)
library(shinydashboardPlus)

######## Symbols

symbol_plus = '<span style=\"color: #196f3d;\"> &#8853;</span>'
symbol_minus = '<span style=\"color: #943126;\"> &#8854;</span>'

######## Helper function

load_csv = function(fname_, date_data_) {
   fname_ = paste("data/", fname_, "__", date_data, ".csv", sep = "")
   data = read.csv(fname_, header = TRUE, sep = ",", fileEncoding = "UTF-8")
   return(data)
}

######## Load data and filters

table_raw =
   load_csv("PubMedSearch__Papers", date_data) %>%
   dplyr::rename(" " = X.)  # " " is saved as "X." in csv-file

edges = load_csv("PubMedSearch__Edges", date_data)
nodes = load_csv("PubMedSearch__Nodes", date_data)

filters_organs = load_csv("Filters__Organs", date_data)
filters_tissues = load_csv("Filters__Tissues", date_data)
filters_diseases = load_csv("Filters__Diseases", date_data)
filters_techniques = load_csv("Filters__Techniques", date_data)
filters_other_terms = load_csv("Filters__Other_terms", date_data)
filters_paper_types = load_csv("Filters__Paper_types", date_data)
filters_microchimerism_types = load_csv("Filters__Microchimerism_types", date_data)

#papers = papers[1:1000, ]  # debug

######## Set names of table columns

names_data = c("Title", "Authors", "Year", "Journal", "Type", "DOI", "PMID", "Abstract")  # NOTE: PMID+Abstract must be last for hiding in the shiny datatable
all_names_table = names(table_raw)[names(table_raw) != " "]

######## Parameters search

search_columns = c("Title", "Authors", "Year", "Journal", "Type", "Abstract")  # Columns with text field, accessible for data table column search
time_search_delay = 2000  # in [ms]
time_highlight_delay = 3000  # in [ms]

########