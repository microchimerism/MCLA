##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Source functions

source("server/server__network__funcs.R", local = TRUE)

########## Network visualization

shiny::observe({

   # Only if tabulator network is selected
   if (input$tabs_navbar == "tab_network") {

      # Return pmid of selected row, if none (row==0) or Abstract (length==0) is selected then return -1
      if (input$shiny_table_rows_selected == 0 || length(input$shiny_table_rows_selected) == 0) {
         selected_row_pmid = -1
      } else {
         selected_row_pmid = table_filtered_search()[input$shiny_table_rows_selected, "PMID"]
      }

      # If no table row is selected show notification text ...
      if (selected_row_pmid == -1) {

         # Show notification text
         shiny::showNotification(shiny::tags$div("To display the reference network, a",
                                                 shiny::tags$br(),
                                                 "data table row has to be selected first."),
                                 id = "network_select_table_row_first",
                                 duration = 4,
                                 closeButton = FALSE)

      # otherwise render network for selected table row
      } else {

         # Render the network if a table row is selected
         output$network_plot =
            visNetwork::renderVisNetwork({

               # Find PubMed-IDs around the PMID selected in table
               string_network_PMIDs = table_filtered_search()$Network_PMIDs[table_filtered_search()$PMID == selected_row_pmid]
               network_PMIDs = as.vector(as.numeric(unlist(strsplit(string_network_PMIDs, ", "))))

               # Find node based on PubMedId
               subset_nodes = subset(nodes, id %in% network_PMIDs)

               # Build the network
               build_network(nodes_ = subset_nodes,
                             edges_ = edges,
                             id_selected_ = selected_row_pmid)
            })
      }
   }
})

##########