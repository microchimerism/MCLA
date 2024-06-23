##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Function to calculate the combined logical values of each term

combine_filter_values = function(filters_, input_chkbox_, input_radiobtn_) {

   # No check box selected
   if (is.null(input_chkbox_)) {
      all_filters_combined = rep(TRUE, nrow(table_raw))  # Return all TRUE
   # At least one check box selected
   } else {
      # Selected check boxes
      selected_chkbox = as.numeric(input_chkbox_)
      # Combine check boxes by logical AND
      if (input_radiobtn_ == 1) {
         all_filters_combined = rep(TRUE, nrow(table_raw))  # Initially, set all values TRUE
         for (ii in selected_chkbox) {  # Iterate over all check boxes and combine values
            filter_chkbox = table_raw[filters_$column_name[[ii]]]  # Filter values of check box
            all_filters_combined = all_filters_combined & filter_chkbox  # Combine filter values by AND
         }
      # Combine check boxes by logical OR
      } else if (input_radiobtn_ == 2) {
         all_filters_combined = rep(FALSE, nrow(table_raw))  # Initially, set all values FALSE
         for (ii in selected_chkbox) {  # Iterate over all check boxes and combine values
            filter_chkbox = table_raw[filters_$column_name[[ii]]]  # Filter values of check box
            all_filters_combined = all_filters_combined | filter_chkbox   # Combine filter values by OR
         }
      }
   }

   return(all_filters_combined)
}

########## Calculate combined logical values of each terms

# Event in box filter organs
combined_filters_organs =
   shiny::eventReactive(
      c(input$radiobtn_logic_organs, input$chkbox_organs), {
      combine_filter_values(filters_organs, input$chkbox_organs, input$radiobtn_logic_organs)
   })

# Event in box filter techniques
combined_filters_techniques =
   shiny::eventReactive(
      c(input$radiobtn_logic_techniques, input$chkbox_techniques), {
         combine_filter_values(filters_techniques, input$chkbox_techniques, input$radiobtn_logic_techniques)
   })

# Event in box filter tissues
combined_filters_tissues =
   shiny::eventReactive(
      c(input$radiobtn_logic_tissues, input$chkbox_tissues), {
         combine_filter_values(filters_tissues, input$chkbox_tissues, input$radiobtn_logic_tissues)
   })

# Event in box filter microchimerism types
combined_filters_microchimerism_types =
   shiny::eventReactive(
      c(input$radiobtn_logic_microchimerism_types, input$chkbox_microchimerism_types), {
         combine_filter_values(filters_microchimerism_types, input$chkbox_microchimerism_types, input$radiobtn_logic_microchimerism_types)
   })

# Event in box filter diseases
combined_filters_diseases =
   shiny::eventReactive(
      c(input$radiobtn_logic_diseases, input$chkbox_diseases), {
         combine_filter_values(filters_diseases, input$chkbox_diseases, input$radiobtn_logic_diseases)
   })

# Event in box filter other terms
combined_filters_other_terms =
   shiny::eventReactive(
      c(input$radiobtn_logic_other_terms, input$chkbox_other_terms), {
         combine_filter_values(filters_other_terms, input$chkbox_other_terms, input$radiobtn_logic_other_terms)
   })

# Event in box filter paper types
combined_filters_paper_types =
   shiny::eventReactive(
      c(input$radiobtn_logic_paper_types, input$chkbox_paper_types), {
         combine_filter_values(filters_paper_types, input$chkbox_paper_types, input$radiobtn_logic_paper_types)
   })

########## Combine all terms with AND and then filter the table

shiny::observe({
   all_combined_filters =
      combined_filters_organs() &
      combined_filters_techniques() &
      combined_filters_tissues() &
      combined_filters_microchimerism_types() &
      combined_filters_diseases() &
      combined_filters_other_terms() &
      combined_filters_paper_types() &
      dplyr::between(table_raw$Year,
                     input_numeric_from_pub_year_delayed(),
                     input_numeric_to_pub_year_delayed())

   table_filt = table_raw %>%
      dplyr::filter(as.vector(all_combined_filters))

   table_filtered(table_filt)
})

##########