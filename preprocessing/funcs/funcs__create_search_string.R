#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universität Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Get current year

get_actual_year = function() {

   year = format(as.Date(Sys.Date(), format="%d/%m/%Y"),"%Y")

   return(year)
}

########## Read MeSH terms from file

read_mesh_terms = function(query_terms_) {

   query_terms_ = gsub('"', '', query_terms_)
   list_key_words = unlist(as.list(el(stringr::str_split(query_terms_, "\r\n"))))
   if (any(is.na(list_key_words))) { list_key_words = list() }

   return(list_key_words)
}

########## Build the search strings

create_search_string = function(query_,
                                year_start_) { # single mesh term

   # Each line in excel sheet is an separate search strings
   # Example of search string: (APE1 [TI] OR OGG1 [TI]) AND (2012 [PDAT] : 2016 [PDAT])
   # Field tags see: https://pubmed.ncbi.nlm.nih.gov/help/
   # [TIAB] Title + Abstract, [MH] MeSH Terms, [PDAT] Publication Date

   search_string_list = list()
   for (ii in 1:nrow(query_)) {
      query_main_word = query_$"Main terms"[ii]
      search_string_main = paste0("(", query_main_word, ")")

      query_mesh_terms = read_mesh_terms(query_$"MeSH terms"[ii])
      if (length(query_mesh_terms) == 0) {  # no MeSH terms returned
         search_string_comb = search_string_main
      } else {
         search_string_query = paste(query_mesh_terms, collapse = " OR ")
         search_string_comb = paste0(search_string_main, " AND (", search_string_query, ")")
      }
      search_string_list = c(search_string_list, search_string_comb)
   }

   year_end = get_actual_year()
   time_limit_crit = paste0("AND (", year_start_, " [PDAT] : ", year_end, " [PDAT])")  # add year limit
   search_string_list = sprintf("%s %s", search_string_list, time_limit_crit)

   #search_string_list = unique(search_string_list) # remove duplicates
   cat(paste(search_string_list, "\n"))
   cat(paste("\n"))

   return(search_string_list)
}

##########