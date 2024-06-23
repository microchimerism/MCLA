##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Tabulator data table

tab_item_table =
   shinydashboard::tabItem(

      # Tabulator id
      tabName = "tab_table",

      shiny::fluidRow(
         shiny::div(style = "display: flex; justify-content: end; margin-right: 20px; margin-top: 0px; margin-bottom: 5px;",
             shiny::tags$label("Search whole table", style = "margin-right: 15px; margin-top: 27px;"),
             shiny::textInput("glo_search_str", "", value = "", width = "450px", placeholder = "All")
         ),

         shinydashboardPlus::box(

            # Box options
            title = NULL,
            width = 12,
            height = 12,
            collapsible = FALSE,
            collapsed = FALSE,

            # Show data table with busy icon
            shinycssloaders::withSpinner(
               DT::dataTableOutput("shiny_table")
            )
         )
      )
   )

##########