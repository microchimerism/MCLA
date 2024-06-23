##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Table columns for selection

names_table_sidebar = names_data[!(names_data %in% c("PMID", "Abstract"))]

######## Sidebar

sidebar =
   shinydashboardPlus::dashboardSidebar(

      # Sidebar id
      id = "sidebar",

      # Sidebar menu for data table, filter settings and network view
      shinydashboard::sidebarMenu(

         # Sidebar menu id
         id = "sidebarmenu",

         #style = "position: fixed; overflow: hidden;",

         # Menu item: Tabulator table
         shinydashboard::menuItem(
            tabName = "tab_table",
            icon = shiny::icon("table", verify_fa = FALSE),
            text = "Data Table"
         ),

         # Menu item: Tabulator filter settings
         shinydashboard::menuItem(
            tabName = "tab_filter",
            icon = shiny::icon("filter", verify_fa = FALSE),
            text = "Filter Settings"
         ),

         # Menu item: Tabulator chart view
         shinydashboard::menuItem(
            tabName = "tab_chart",
            icon = shiny::icon("chart-simple", verify_fa = FALSE),
            text = "Chart View"
         ),

         # Menu item: Tabulator network view
         shinydashboard::menuItem(
            tabName = "tab_network",
            icon = shiny::icon("circle-nodes", verify_fa = FALSE),
            text = "Network View"
         ),

         # Menu item: Tabulator help
         shinydashboard::menuItem(
            tabName = "tab_info",
            icon = shiny::icon("info-circle", verify_fa = FALSE),
            text = "Info"
         ),

         # Horizontal line
         shiny::tags$hr(style = "margin-top: 5px; margin-bottom: 8px;"),

         # Menu item: Columns of table to view (no function)
         shinydashboard::menuItem(
            tabName = NULL,
            icon = shiny::icon("table-columns", verify_fa = FALSE),
            text = "Displayed columns"
         ),
         # Check box selection for the table columns to display
         shiny::tags$div(
            class = "div-sidebar-check-boxes",  # necessary to reference to in javascript function
            style = "display:inline-block; margin-top: -10px; padding-left: 5px;",
            shiny::checkboxGroupInput("chkbox_table_columns_show",
                                      NULL,
                                      names_table_sidebar,
                                      selected = names_table_sidebar
            )
         ),

         # Horizontal line
         shiny::tags$hr(style = "margin-top: 5px; margin-bottom: 8px;"),

         # Menu item: Export filtered data set (no function)
         shinydashboard::menuItem(
            tabName = NULL,
            icon = shiny::icon("download", verify_fa = FALSE),
            text = "Export data set"
         ),
         # Download buttons for the filtered data table
         shiny::tags$div(
            id = "export-buttons-datatable",  # necessary to reference to in javascript callback function in server_table
            style = "margin-left: 3px;",
            shiny::actionButton("button_export_datatable_csv",
                                label = "csv",
                                onclick = "exportDatatablePerButton( '.buttons-csv' );",  # necessary since SERVER = FALSE,
                                class = "buttons_export_datatable"),
            shiny::actionButton("button_export_datatable_xlsx",
                                label = "xlsx",
                                onclick = "exportDatatablePerButton( '.buttons-excel' );",
                                class = "buttons_export_datatable"),
            shiny::actionButton("button_export_datatable_print",
                                label = "print",
                                onclick = "exportDatatablePerButton( '.buttons-print' );",
                                class = "buttons_export_datatable"),
         )
      )
   )

##########