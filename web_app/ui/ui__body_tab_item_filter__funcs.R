##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Template for the filter boxes with logic

template_box_filter = function(title_, status_, choices_, inputIdLogic_, inputIdTerms_, inputIdSelectAll_, inputIdDeselectAll_) {

   box =
      shinydashboardPlus::box(

         # Box options
         title = title_,
         status = status_,
         width = 2,  # all widths should sum up to 12
         boxToolSize = "xs",
         solidHeader = TRUE,
         closable = FALSE,
         collapsible = FALSE,

         # Logic AND-/OR- radio buttons
         shiny::tags$div(
            style = "display: flex; justify-content: space-evenly;",
            shinyWidgets::radioGroupButtons(inputId = inputIdLogic_,
                                            size = "sm",
                                            choiceNames = c("AND", "OR"),
                                            choiceValues = seq(1, 2),
                                            selected = c(1),
                                            checkIcon = list(yes = icon("ok", lib = "glyphicon"))
            )
         ),

         # Horizontal line
         shiny::tags$hr(style = "margin-top: 15px; margin-bottom: 17px;"),

         # Select and deselect all buttons
         shiny::tagList(
            shiny::tags$div(
               style = "display: flex; justify-content: space-around;",
               shiny::actionButton(inputId = inputIdSelectAll_,
                                   label = "Select all",
                                   style = "background-color: #D5DBDB; border-radius: 3px; padding: 4px 10px 2px 10px;"),
               shiny::actionButton(inputId = inputIdDeselectAll_,
                                   label = "Deselect all",
                                   style = "background-color: #AEB6BF; border-radius: 3px; padding: 4px 10px 2px 10px;")
            )
         ),

         # Horizontal line
         shiny::tags$hr(style = "margin-top: 15px; margin-bottom: 17px;"),

         # Filter options
         shiny::checkboxGroupInput(
            inputId = inputIdTerms_,
            label = NULL,
            inline = FALSE,
            choiceNames = choices_,
            choiceValues = seq(1, length(choices_)),
            selected = character(0)
         )
      )

   return(box)
}

######### Template for the filter boxes with logic


template_box_filter_paper_types = function(title_, status_, choices_, inputIdLogic_, inputIdTerms_) {

   box =
      shinydashboardPlus::box(

         # Box options
         title = title_,
         status = status_,
         width = 2,  # all widths should sum up to 12
         boxToolSize = "xs",
         solidHeader = TRUE,
         closable = FALSE,
         collapsible = FALSE,

         # Logic AND-/OR- radio buttons
         shiny::tags$div(
            style = "display: flex; justify-content: space-evenly;",
            shinyWidgets::radioGroupButtons(inputId = inputIdLogic_,
                                            size = "sm",
                                            choiceNames = c("OR"),
                                            choiceValues = c(2),
                                            selected = c(2),
                                            checkIcon = list(yes = icon("ok", lib = "glyphicon"))
            )
         ),

         # Horizontal line
         shiny::tags$hr(style = "margin-top: 15px; margin-bottom: 17px;"),

         # Filter options
         shiny::checkboxGroupInput(
            inputId = inputIdTerms_,
            label = NULL,
            inline = FALSE,
            choiceNames = choices_,
            choiceValues = seq(1, length(choices_)),
            selected = character(0)
         )
      )

   return(box)
}

######### Template for the year slider box

template_box_slider = function(title_, status_, year_min_max_, inputIdSlider_, inputIdFrom_, inputIdTo_) {

   box =
      shinydashboardPlus::box(

         # Box options
         title = title_,
         status = status_,
         width = 4,  # all widths should sum up to 12
         boxToolSize = "xs",
         solidHeader = TRUE,
         closable = FALSE,
         collapsible = FALSE,

         # Year range input slider
         shiny::sliderInput(inputId = inputIdSlider_,
                            label = "Choose range:",
                            step = 1,
                            sep = "",
                            ticks = TRUE,
                            min = year_min_max_[[1]],
                            max = year_min_max_[[2]],
                            value = year_min_max_
         ),

         # Horizontal line
         hr(),

         # Numeric input fields
         fluidRow(
            shiny::column(6,
                          style = "padding-right: 10px;",
                          shiny::numericInput(inputId = inputIdFrom_,
                                              label = "From year:",
                                              step = 1,
                                              value = year_min_max_[[1]])
            ),
            shiny::column(6,
                          style = "padding-left: 10px;",
                          shiny::numericInput(inputId = inputIdTo_,
                                              label = "To year:",
                                              step = 1,
                                              value = year_min_max_[[2]])
            )
         )
      )
}

#########