##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#

########## Source functions

source("server/server__filter_settings__funcs.R", local = TRUE)

########## Filter settings for organs

# Select all
shiny::observeEvent(
   input$actbtn_all_organs,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_organs",
                            choices_ = filters_organs$labels,
                            select_ = "all")
)

# Deselect all
shiny::observeEvent(
   input$actbtn_none_organs,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_organs",
                            choices_ = filters_organs$labels,
                            select_ = "none")
)

########## Filter settings for techniques

# Select all
shiny::observeEvent(
   input$actbtn_all_techniques,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_techniques",
                            choices_ = filters_techniques$labels,
                            select_ = "all")
)

# Deselect all
shiny::observeEvent(
   input$actbtn_none_techniques,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_techniques",
                            choices_ = filters_techniques$labels,
                            select_ = "none")
)

########## Filter settings for tissues

# Select all
shiny::observeEvent(
   input$actbtn_all_tissues,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_tissues",
                            choices_ = filters_tissues$labels,
                            select_ = "all")
)

# Deselect all
shiny::observeEvent(
   input$actbtn_none_tissues,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_tissues",
                            choices_ = filters_tissues$labels,
                            select_ = "none")
)

########## Filter settings for microchimerism types

# Select all
shiny::observeEvent(
   input$actbtn_all_microchimerism_types,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_microchimerism_types",
                            choices_ = filters_microchimerism_types$labels,
                            select_ = "all")
)

# Deselect all
shiny::observeEvent(
   input$actbtn_none_microchimerism_types,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_microchimerism_types",
                            choices_ = filters_microchimerism_types$labels,
                            select_ = "none")
)

########## Filter settings for diseases

# Select all
shiny::observeEvent(
   input$actbtn_all_diseases,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_diseases",
                            choices_ = filters_diseases$labels,
                            select_ = "all")
)

# Deselect all
shiny::observeEvent(
   input$actbtn_none_diseases,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_diseases",
                            choices_ = filters_diseases$labels,
                            select_ = "none")
)

########## Filter settings for other terms

# Select all
shiny::observeEvent(
   input$actbtn_all_other_terms,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_other_terms",
                            choices_ = filters_other_terms$labels,
                            select_ = "all")
)

# Deselect all
shiny::observeEvent(
   input$actbtn_none_other_terms,
   select_all_none_template(session_ = session,
                            chkbox_id_ = "chkbox_other_terms",
                            choices_ = filters_other_terms$labels,
                            select_ = "none")
)

########## Filter settings for publication year range

# Delay the processing of numeric inputs - give the user time to finish writing
input_numeric_from_pub_year_delayed =
   reactive({ input$numeric_from_pub_year }) %>%
   shiny::debounce(2000)  # in milliseconds
input_numeric_to_pub_year_delayed =
   reactive({ input$numeric_to_pub_year }) %>%
   shiny::debounce(2000)  # in milliseconds

# Detect (and correct) any change of numeric input
listen_any_numericInput_change =
   shiny::reactive({
      min_year_ = min(table_raw$Year)
      max_year_ = max(table_raw$Year)

      if (input_numeric_from_pub_year_delayed() < min_year_) {
         min_max_year_ = list(min_year_,
                              input_numeric_to_pub_year_delayed())
      } else if (input_numeric_to_pub_year_delayed() > max_year_) {
         min_max_year_ = list(input_numeric_from_pub_year_delayed(),
                              max_year_)
      } else if (input_numeric_from_pub_year_delayed() > input_numeric_to_pub_year_delayed()) {
         min_max_year_ = list(min_year_,
                              max_year_)
      } else {
         min_max_year_ = list(input_numeric_from_pub_year_delayed(),
                              input_numeric_to_pub_year_delayed())
      }

      shiny::updateNumericInput(session = session,
                                inputId = "numeric_from_pub_year",
                                value = min_max_year_[[1]])
      shiny::updateNumericInput(session = session,
                                inputId = "numeric_to_pub_year",
                                value = min_max_year_[[2]])

      return(min_max_year_)
   })

# Set sliders if numeric inputs are changed
observeEvent(
   listen_any_numericInput_change(),
   shiny::updateSliderInput(session = session,
                            inputId = "slider_range_pub_year",
                            step = 1,
                            min = min(table_raw$Year),
                            max = max(table_raw$Year),
                            value = list(input_numeric_from_pub_year_delayed(),
                                         input_numeric_to_pub_year_delayed())
   )
)

# Set both numeric inputs if sliders' positions are changed
observeEvent(
   input$slider_range_pub_year,
   shiny::updateNumericInput(session = session,
                             inputId = "numeric_from_pub_year",
                             value = input$slider_range_pub_year[[1]])
)
observeEvent(
   input$slider_range_pub_year,
   shiny::updateNumericInput(session = session,
                             inputId = "numeric_to_pub_year",
                             value = input$slider_range_pub_year[[2]])
)

##########