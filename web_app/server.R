##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


############################
########## SERVER ##########
############################

server = function(input, output, session) {

   # For debugging (see also server_table.R): when options(stateSave = TRUE) export table settings to console
   #shiny::observeEvent(input$shiny_table_state, { str(input$shiny_table_state) })

   # Set the dataset as reactive value
   table_filtered = shiny::reactiveVal(table_raw)

   # Source the menu
   source("server/server__menu.R", local = TRUE)

   # Source the filter settings
   source("server/server__filter_settings.R", local = TRUE)

   # Source the filter building
   source("server/server__filter.R", local = TRUE)

   # Source the data table
   source("server/server__table.R", local = TRUE)

   # Source the network visualization
   source("server/server__network.R", local = TRUE)

   # Source the chart visualization
   source("server/server__chart.R", local = TRUE)
}

##########