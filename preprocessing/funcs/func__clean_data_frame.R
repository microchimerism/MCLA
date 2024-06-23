#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Clean the data frame of papers

clean_data_frame = function(papers_) {

   papers_clean =
      papers_ %>%
      dplyr::filter(!ABORT) %>%  # remove all rows with missing crucial information
      dplyr::select(-ABORT) %>%  # drop column with ABORT information
      dplyr::distinct(., PMID, .keep_all = TRUE) %>%  # remove duplicates
      dplyr::mutate(Type = ifelse(grepl("Review|review", Title) | (Type == "Review"), "Review", "Article")) %>%  # review: add to pubmed-tag occurrences in title
      dplyr::mutate(DOI = paste("<a href='https://doi.org/", DOI, "' target='_blank'>", DOI, "</a>", sep = "")) %>%  # format doi for html
      dplyr::mutate(PMID = as.numeric(PMID)) %>%  # cast type
      dplyr::mutate(DOI = as.character(DOI)) %>%
      dplyr::mutate(Authors = as.character(Authors)) %>%
      dplyr::mutate(Year = as.numeric(Year)) %>%
      dplyr::mutate(Journal = as.character(Journal)) %>%
      dplyr::mutate(Title = as.character(Title)) %>%
      dplyr::mutate(Abstract = as.character(Abstract)) %>%
      dplyr::mutate(Type = as.character(Type)) %>%
      dplyr::mutate(References = as.character(References)) %>%
      dplyr::mutate(References_PMID = as.character(References_PMID))

   return(papers_clean)
}

########## Clean the data frame of papers to remove

aborted_papers = function(papers_) {

   papers_removed =
      papers_ %>%
      dplyr::filter(ABORT) %>%  # remove all rows with missing crucial information
      dplyr::distinct(., PMID, .keep_all = TRUE) %>% # remove duplicates
      dplyr::mutate(PMID = as.numeric(PMID)) %>%  # cast type
      dplyr::mutate(DOI = as.character(DOI)) %>%
      dplyr::mutate(Authors = as.character(Authors)) %>%
      dplyr::mutate(Year = as.numeric(Year)) %>%
      dplyr::mutate(Journal = as.character(Journal)) %>%
      dplyr::mutate(Title = as.character(Title)) %>%
      dplyr::mutate(Abstract = as.character(Abstract)) %>%
      dplyr::mutate(Type = as.character(Type)) %>%
      dplyr::mutate(References = as.character(References)) %>%
      dplyr::mutate(References_PMID = as.character(References_PMID))

   return(papers_removed)
}

##########