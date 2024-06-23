#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Helper function

set_found_search_terms = function(data_, filter_, column_) {
   for (ii in seq(filter_$column_name)) {
      data_[filter_$column_name[[ii]]] = grepl(filter_$search_terms[[ii]], column_, ignore.case = FALSE)
   }

   return(data_)
}

########## Save data

set_filter_for_search_terms = function(papers_,
                                       filters_organs_,
                                       filters_tissues_,
                                       filters_diseases_,
                                       filters_techniques_,
                                       filters_other_terms_,
                                       filters_paper_types_,
                                       filters_microchimerism_types_) {

   papers_ =
      papers_ %>%
      set_found_search_terms(., filters_organs_, papers_$Abstract) %>%
      set_found_search_terms(., filters_tissues_, papers_$Abstract) %>%
      set_found_search_terms(., filters_diseases_, papers_$Abstract) %>%
      set_found_search_terms(., filters_techniques_, papers_$Abstract) %>%
      set_found_search_terms(., filters_other_terms_, papers_$Abstract) %>%
      set_found_search_terms(., filters_paper_types_, papers_$Type) %>%
      set_found_search_terms(., filters_microchimerism_types_, papers_$Abstract)

   return(papers_)
}

##########