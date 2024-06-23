##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Source functions

source("ui/ui__body_tab_item_filter__funcs.R", local = TRUE)

######### Tabulator filter settings

tab_item_filter =
   shinydashboard::tabItem(

      # Tabulator id
      tabName = "tab_filter",

      # Fluid row layout
      shiny::fluidRow(

         # Vertical offset
         #style = "margin-top: 5px;",  # otherwise part of boxes is covered by navbar

         # Box for filter organs
         template_box_filter(title_ = "Organs",
                             status_ = "info",
                             choices_ = filters_organs$labels,
                             inputIdLogic_ = "radiobtn_logic_organs",
                             inputIdTerms_ = "chkbox_organs",
                             inputIdSelectAll_ = "actbtn_all_organs",
                             inputIdDeselectAll_ = "actbtn_none_organs"),

         # Box for filter techniques
         template_box_filter(title_ = "Techniques",
                             status_ = "success",
                             choices_ = filters_techniques$labels,
                             inputIdLogic_ = "radiobtn_logic_techniques",
                             inputIdTerms_ = "chkbox_techniques",
                             inputIdSelectAll_ = "actbtn_all_techniques",
                             inputIdDeselectAll_ = "actbtn_none_techniques"),

         # Box for filter tissues
         template_box_filter(title_ = "Tissue types",
                             status_ = "info",
                             choices_ = filters_tissues$labels,
                             inputIdLogic_ = "radiobtn_logic_tissues",
                             inputIdTerms_ = "chkbox_tissues",
                             inputIdSelectAll_ = "actbtn_all_tissues",
                             inputIdDeselectAll_ = "actbtn_none_tissues"),

         # Box for filter microchimerism types
         template_box_filter(title_ = "Microchimerism types",
                             status_ = "success",
                             choices_ = filters_microchimerism_types$labels,
                             inputIdLogic_ = "radiobtn_logic_microchimerism_types",
                             inputIdTerms_ = "chkbox_microchimerism_types",
                             inputIdSelectAll_ = "actbtn_all_microchimerism_types",
                             inputIdDeselectAll_ = "actbtn_none_microchimerism_types"),

         # Box for filter diseases
         template_box_filter(title_ = "Diseases",
                             status_ = "info",
                             choices_ = filters_diseases$labels,
                             inputIdLogic_ = "radiobtn_logic_diseases",
                             inputIdTerms_ = "chkbox_diseases",
                             inputIdSelectAll_ = "actbtn_all_diseases",
                             inputIdDeselectAll_ = "actbtn_none_diseases"),

         # Box for filter other terms
         template_box_filter(title_ = "Other terms",
                             status_ = "success",
                             choices_ = filters_other_terms$labels,
                             inputIdLogic_ = "radiobtn_logic_other_terms",
                             inputIdTerms_ = "chkbox_other_terms",
                             inputIdSelectAll_ = "actbtn_all_other_terms",
                             inputIdDeselectAll_ = "actbtn_none_other_terms"),

         # Box for the publication year range
         template_box_slider(title_ = "Publication years",
                             status_ = "warning",
                             year_min_max_ = c(min(table_raw$Year),
                                               max(table_raw$Year)),
                             inputIdSlider_ = "slider_range_pub_year",
                             inputIdFrom_ = "numeric_from_pub_year",
                             inputIdTo_ = "numeric_to_pub_year"),

         # Box for filter paper types
         template_box_filter_paper_types(title_ = "Paper types",
                                         status_ = "info",
                                         choices_ = filters_paper_types$labels,
                                         inputIdLogic_ = "radiobtn_logic_paper_types",
                                         inputIdTerms_ = "chkbox_paper_types")
      )
   )

##########