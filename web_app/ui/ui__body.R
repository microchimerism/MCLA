##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Source body parts

source("ui/ui__body_tab_item_info.R", local = TRUE)
source("ui/ui__body_tab_item_chart.R", local = TRUE)
source("ui/ui__body_tab_item_table.R", local = TRUE)
source("ui/ui__body_tab_item_filter.R", local = TRUE)
source("ui/ui__body_tab_item_network.R", local = TRUE)

######### Body

body =
   shinydashboard::dashboardBody(

      # Use Javascript in shiny environment
      shinyjs::useShinyjs(),

      # Include local CSS files with formatting for whole site
      shiny::tags$head(
         shiny::includeCSS("www/css/fonts.css"),
         htmltools::htmlDependency(name = "font-awesome", version = "6.5.1", src = "www/fonts/Awesome", stylesheet = "css/all.min.css"),
         shiny::includeCSS("www/css/elements.css"),
         shiny::includeScript("www/javascript/functions.js"),
         shiny::includeScript("https://cdnjs.cloudflare.com/ajax/libs/jQuery-slimScroll/1.3.8/jquery.slimscroll.min.js"),
         shiny::includeScript("https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js")
      ),

      # Add event listener for global search and highlighting to DOM
      shiny::tags$script(
         shiny::HTML("
            document.addEventListener('DOMContentLoaded', function() {
               initGlobalSearchEnter(", time_highlight_delay, ");
               //initGlobalSearchDelay(', time_search_delay, ', ', time_highlight_delay, ');  // replace ' with ''
            });
         ")
      ),

      # Apply a shadow on a given element
      shinyEffects::setShadow(class = "box"),

      # Tabulators
      shinydashboard::tabItems(

         # Tabulator for data table
         tab_item_table,

         # Tabulator for filter settings
         tab_item_filter,

         # Tabulator for network visualization
         tab_item_network,

         # Tabulator for charts
         tab_item_chart,

         # Tabulator for help
         tab_item_info
      )
   )

##########