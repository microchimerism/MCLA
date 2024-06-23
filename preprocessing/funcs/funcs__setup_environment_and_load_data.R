#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Setup the environment

setup_environment = function() {

   Sys.setenv(LANGUAGE="en")

   library(XML)
   library(xlsx)
   library(dplyr)
   library(rvest)
   library(utils)
   library(doSNOW)
   library(tictoc)
   library(readxl)
   library(writexl)
   library(methods)
   library(pbapply)
   library(stringi)
   library(stringr)
   library(foreach)
   library(parallel)
   library(rcrossref)
   library(doParallel)
   library(easyPubMed)

   source("funcs/func__clean_data_frame.R")
   source("funcs/func__convert_pubmed_xml_to_data_frame.R")
   source("funcs/func__create_new_table_entry.R")
   source("funcs/func__download_xml_from_pubmed.R")
   source("funcs/func__extract_pubmed_xml.R")
   source("funcs/func__set_filter_for_search_terms.R")
   source("funcs/func__test_coverage_of_search_terms.R")
   source("funcs/funcs__count_citations.R")
   source("funcs/funcs__create_search_string.R")
   source("funcs/funcs__network_build_edges.R")
   source("funcs/funcs__network_build_nodes.R")
   source("funcs/funcs__network_prebuild.R")

   if (!dir.exists("results")) { dir.create("results") }

   api_key = "5ed677a8fc674bade0c54ecc459d634d4e09"

   return(api_key)
}

########## Create directory for download of papers

create_download_directory = function (download_directory) {

   if (dir.exists(download_directory)) { unlink(download_directory, recursive = TRUE) }  # delete directory
   dir.create(download_directory)
}

########## Load MeSH terms from file

import_query_from_file = function(file_) {

   query =
      readxl::read_xlsx(file_, sheet="Query", trim=TRUE) %>%
      mutate(across(everything(), ~str_remove_all(., "^'"))) %>%
      unique() %>%
      as.data.frame()

   return(query)
}

########## Load impact factors from file

import_impact_factors_from_file = function(file_) {

   impact_facs =
      readxl::read_xlsx(file_, sheet="Impact_factors", trim=TRUE) %>%
      unique() %>%
      as.data.frame()

   return(impact_facs)
}

########## Save data into the result folder as csv-file with time stamp

save_csv = function(data_, fname_, with_timestamp = TRUE) {

   if (with_timestamp == TRUE) {
      date = as.character(format(Sys.Date(), format = "%Y_%m_%d"))
      fname = paste(fname_, "__", date, ".csv", sep = "")
   } else {
      fname = paste(fname_, ".csv", sep = "")
   }

   ffname = paste("results/", fname, sep = "")
   write.csv(data_, ffname, row.names = FALSE, fileEncoding = "UTF-8")
}

########## Save data into the result folder as csv-file with time stamp

read_csv = function(fname_, is_data_file = TRUE) {

   if (is_data_file == TRUE) {
      ffname = paste("data/", fname_, ".csv", sep = "")
   } else {
      ffname = paste("results/", fname_, ".csv", sep = "")
   }
   file = read.csv(ffname, sep = ",", header = TRUE, fileEncoding = "UTF-8")

   return(file)
}

########## Extract the DOI string

extract_doi = function(str) {

   doi = stringr::str_extract(str, "https://doi.org/(\\S+)")[[1]]
   doi = sub("https://doi.org/", "", doi)
   doi = gsub("'", "", doi)
   doi = tolower(doi)

   return(doi)
}

##########
