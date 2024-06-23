##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Header

header =
   shinydashboardPlus::dashboardHeader(

      # Fixed-top navbar
      fixed = FALSE,

      # Header title and icon (only displayed when navbar minimized "logo-lg")
      title =
         shiny::tagList(
            shiny::span(class = "logo-lg", "MC Literature Atlas"),
            shiny::img(src = "images/logo/logo.svg",
                       style = "height: 30px, width: 30px"
            )
         ),

      # Tabulators for table, filter and network
      leftUi =
         shiny::tagList(
            shinyWidgets::radioGroupButtons(
               inputId = "tabs_navbar",
               label = NULL,
               status = "primary",
               choiceNames = list(
                  shiny::tags$span(shiny::tagList(shiny::icon("table", verify_fa = FALSE),
                                                  "Data Table")),
                  shiny::tags$span(shiny::tagList(shiny::icon("filter", verify_fa = FALSE),
                                                  "Filter Settings")),
                  shiny::tags$span(shiny::tagList(shiny::icon("chart-simple", verify_fa = FALSE),
                                                  "Chart View")),
                  shiny::tags$span(shiny::tagList(shiny::icon("circle-nodes", verify_fa = FALSE),
                                                  "Network View")),
                  shiny::tags$span(shiny::tagList(shiny::icon("info-circle", verify_fa = FALSE),
                                                  "Info"))
               ),
               choiceValues = list("tab_table",
                                   "tab_filter",
                                   "tab_chart",
                                   "tab_network",
                                   "tab_info")
            )
         )
   )

##########