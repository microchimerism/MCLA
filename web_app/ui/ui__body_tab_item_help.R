##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Tabulator help

tab_item_help =
   shinydashboard::tabItem(

      # Tabulator id
      tabName = "tab_help",

      shiny::fluidPage(

         shinydashboardPlus::box(

            # Box id
            id = "box_for_help",  # necessary for javascript function for full height of box

            # Box options
            title = "Help",
            status = "info",
            width = 11,
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,

            htmltools::HTML(
               "<h1>Aim</h1>
               <p>The <em>Microchimerism Literature Atlas</em> should provide a useful tool for the search of literature in the context of
               microchimerism. The entries of the Data Table were obtained by applying a MeSH term search on PubMed&reg with</p>
               "
            )
         )
      )
   )

##########