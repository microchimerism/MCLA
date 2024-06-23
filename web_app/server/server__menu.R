##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Update sidebar menu when tabulator menu is switched and vice versa

# Update sidebarmenu when navbar radioGroupButtons pressed
shiny::observeEvent(
   input$tabs_navbar, {
      shiny::removeNotification(id = "network_select_table_row_first",  # should only be used once (i.e., here and not below) otherwise the notification is terminated instantaneously
                                session = getDefaultReactiveDomain())
      # shiny::removeNotification(id = "charts_filtered_table_empty_adjust_settings",
      #                           session = getDefaultReactiveDomain())
      shinydashboard::updateTabItems(session = session,
                                     inputId = "sidebarmenu",
                                     selected = input$tabs_navbar)
   }
)

# Update navbar radioGroupButtons when sidebarmenu pressed
shiny::observeEvent(
   input$sidebarmenu,
   shinyWidgets::updateRadioGroupButtons(session = session,
                                         inputId = "tabs_navbar",
                                         selected = input$sidebarmenu)
)

##########