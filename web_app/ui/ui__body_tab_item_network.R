##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Tabulator visualize citation network

tab_item_network =
   shinydashboard::tabItem(

      # Tabulator id
      tabName = "tab_network",

      shiny::fluidPage(

         # Vertical offset
         #style = "margin-top: 5px;",  # otherwise part of box is covered by navbar

         shinydashboardPlus::box(

            # Box id
            id = "box_for_network",  # necessary for javascript function for full height of box

            # Box options
            title = "Literature Reference Network",
            status = "info",
            width = 11,
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,

            # Show visNetwork with busy icon
            shinycssloaders::withSpinner(
               visNetwork::visNetworkOutput("network_plot")
            )
         )
      )
   )

##########