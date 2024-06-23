##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Determine which papers are not covered by search terms for the abstract

test_coverage_of_search_terms = function(papers_,
                                         filters_organs,
                                         filters_tissues,
                                         filters_diseases,
                                         filters_techniques,
                                         filters_other_terms,
                                         filters_microchimerism_types) {

   # Load the filter terms
   filters_organs = read.csv("data/Filters__Organs.csv", header = TRUE)
   filters_tissues = read.csv("data/Filters__Tissues.csv", header = TRUE)
   filters_diseases = read.csv("data/Filters__Diseases.csv", header = TRUE)
   filters_techniques = read.csv("data/Filters__Techniques.csv", header = TRUE)
   filters_other_terms = read.csv("data/Filters__Other_terms.csv", header = TRUE)
   filters_microchimerism_types = read.csv("data/Filters__Microchimerism_types.csv", header = TRUE)

   # Build combined search string
   search_string = 
      paste(paste(filters_organs$search_terms, collapse = "|"),
            paste(filters_techniques$search_terms, collapse = "|"),
            paste(filters_tissues$search_terms, collapse = "|"),
            paste(filters_microchimerism_types$search_terms, collapse = "|"),
            paste(filters_diseases$search_terms, collapse = "|"),
            paste(filters_other_terms$search_terms, collapse = "|"),
         sep = "|") %>%  # paste all terms in single string
      gsub("(\\|)+", "|", .) %>%  # replace multiple "|" by a single "|"
      gsub("^(\\|)", "", .) %>%  # remove "|" if it is the 1st character of the string
      gsub("(\\|)$", "", .)  # remove "|" if it is the last character of the string

   print("Search terms for coverage:")
   print(search_string)

   # Filter the abstract of the dataset for search terms
   papers_not_covered =
      papers_ %>%
      dplyr::filter(as.vector(!grepl(search_string, Abstract)))

   print("Coverage of papers by search terms:")
   print( paste("number of papers in total:", nrow(papers_), sep = " "))
   print(paste("number of papers covered:", nrow(papers_) - nrow(papers_not_covered), sep = " "))
   print(paste("number of papers not covered:", nrow(papers_not_covered), sep = " "))

   # Save findings
   ffname = "results/papers_not_covered_by_search_terms.xlsx"
   xlsx::write.xlsx(papers_not_covered, ffname, sheetName = "Data", row.names = FALSE, col.names = TRUE)
   xlsx::write.xlsx(filters_organs, ffname, sheetName = "Filters_organs", row.names = FALSE, col.names = TRUE, append = TRUE)
   xlsx::write.xlsx(filters_tissues, ffname, sheetName = "Filters_tissues", row.names = FALSE, col.names = TRUE, append = TRUE)
   xlsx::write.xlsx(filters_diseases, ffname, sheetName = "Filters_diseases", row.names = FALSE, col.names = TRUE, append = TRUE)
   xlsx::write.xlsx(filters_techniques, ffname, sheetName = "Filters_techniques", row.names = FALSE, col.names = TRUE, append = TRUE)
   xlsx::write.xlsx(filters_other_terms, ffname, sheetName = "Filters_other_terms", row.names = FALSE, col.names = TRUE, append = TRUE)
   xlsx::write.xlsx(filters_microchimerism_types, ffname, sheetName = "Filters_microchimerism_types", row.names = FALSE, col.names = TRUE, append = TRUE)
}

##########