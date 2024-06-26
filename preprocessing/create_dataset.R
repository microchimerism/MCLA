#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#
# Find and download papers from PupMed by keyword search
#
# See also:
# - PubMed website:        https://pubmed.ncbi.nlm.nih.gov
# - easyPubMed use:        https://www.data-pulse.com/dev_site/easypubmed
# - PubMed search-elements:https://www.nlm.nih.gov/bsd/mms/medlineelements.html
# - PubMed XML-elements:   https://www.nlm.nih.gov/bsd/licensee/elements_alphabetical.html
# - MeSH-term search:      https://www.ncbi.nlm.nih.gov
#
# https://kateto.net/sunbelt2019
# https://kateto.net/network-visualization
#


########## Clean workspace

cat("\014")
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

########## SETTINGS

path_file_custom_dataset = "path/file_name"
DOWNLOAD_PUBMED = TRUE  # download meta data from pubmed
BUILD_NODES_AND_EDGES = TRUE  # build visnetwork structures

#####

download_directory = "found_papers_1_50"
web_columns = c("Title", "Authors", "Year", "Journal", "Type", "Citations", "DOI", "MeSH_Keywords", "Network_PMIDs", "PMID", "Abstract")  # NOTE: PMID+Abstract must be last for hiding in the shiny datatable
symbol_plus = '<span style=\"color: #196f3d;\"> &#8853;</span>'

########## Setup environment

source("funcs/funcs__setup_environment_and_load_data.R")
api_key = setup_environment()

########## Import Query Data

query = import_query_from_file("data/PubMedSearch_Parameters.xlsx")

########## Create PubMed search strings

search_string_list = create_search_string(query, "1970")

########## Download XML-data from PubMed website and into data frame or use custom dataset

if (DOWNLOAD_PUBMED == TRUE) {
   tictoc::tic("Download Time")
   create_download_directory(download_directory)
   download_xml_from_pubmed(search_string_list, api_key, 50, download_directory)
   tictoc::toc()
   tictoc::tic("Convert Time")
   papers_xml = convert_pubmed_xml_to_data_frame(download_directory)
   tictoc::toc()
   save_csv(papers_xml, "debug_papers_before_cleaning", with_timestamp = FALSE)
   papers = clean_data_frame(papers_xml)
   #papers_removed = aborted_papers(papers_xml)
   save_csv(papers_removed, "debug_papers_removed_by_cleaning", with_timestamp = FALSE)
} else {
   papers = read_csv(path_file_custom_dataset, is_data_file = FALSE)
}

########## Build network nodes and edges

if (BUILD_NODES_AND_EDGES == TRUE) {
   tictoc::tic("Nodes")
   nodes = build_nodes_from_dataframe(papers)
   save_csv(nodes, "PubMedSearch__Nodes", with_timestamp = TRUE)
   save_csv(nodes, "debug_nodes", with_timestamp = FALSE)
   tictoc::toc()
   tictoc::tic("Edges")
   edges = build_edges_from_dataframe(papers)
   save_csv(edges, "PubMedSearch__Edges", with_timestamp = TRUE)
   save_csv(edges, "debug_edges", with_timestamp = FALSE)
   tictoc::toc()
} else {
   nodes = read_csv("debug_nodes", is_data_file = FALSE)
   edges = read_csv("debug_edges", is_data_file = FALSE)
}

########## Debug

# pmid = "27468655" # "8570620"
# papers = papers %>% filter(PMID == pmid)

########## Filter nodes

papers = network_prebuild(papers, edges)
network_sizes = sapply(strsplit(as.character(papers$Network_PMIDs), ", "), length)  # plot a histogram and a bar plot of the derived network sizes
hist(network_sizes)
barplot(network_sizes)

########## Count the number of citations

papers = count_citations(papers, edges)

########## Load and add filters

filters_organs = read_csv("Filters__Organs", is_data_file = TRUE)
filters_tissues = read_csv("Filters__Tissues", is_data_file = TRUE)
filters_diseases = read_csv("Filters__Diseases", is_data_file = TRUE)
filters_techniques = read_csv("Filters__Techniques", is_data_file = TRUE)
filters_other_terms = read_csv("Filters__Other_terms", is_data_file = TRUE)
filters_paper_types = read_csv("Filters__Paper_types", is_data_file = TRUE)
filters_microchimerism_types = read_csv("Filters__Microchimerism_types", is_data_file = TRUE)

########## Filter and save table

papers_columns = colnames(papers)  # column names without filter columns
papers = set_filter_for_search_terms(papers, filters_organs, filters_tissues,  filters_diseases, filters_techniques, 
                                     filters_other_terms, filters_paper_types, filters_microchimerism_types)
filter_columns = colnames(papers)[!(colnames(papers) %in% papers_columns)]  # column names of filters

papers_filtered =
   papers %>%
   dplyr::arrange(desc(Year)) %>%
   dplyr::select(all_of(c(web_columns, filter_columns))) %>%  # NOTE: pmid+abstract must be last for hiding
   dplyr::mutate(" " = symbol_plus, .before = "Title")
save_csv(papers_filtered, "PubMedSearch__Papers", with_timestamp = TRUE)

########## Save filters

save_csv(filters_organs, "Filters__Organs", with_timestamp = TRUE)
save_csv(filters_tissues, "Filters__Tissues", with_timestamp = TRUE)
save_csv(filters_diseases, "Filters__Diseases", with_timestamp = TRUE)
save_csv(filters_techniques, "Filters__Techniques", with_timestamp = TRUE)
save_csv(filters_other_terms, "Filters__Other_terms", with_timestamp = TRUE)
save_csv(filters_paper_types, "Filters__Paper_types", with_timestamp = TRUE)
save_csv(filters_microchimerism_types, "Filters__Microchimerism_types", with_timestamp = TRUE)

########## Save the basic columns separately

papers_filtered %>%
   dplyr::mutate(DOI = sapply(DOI, extract_doi)) %>%
   dplyr::select(PMID, DOI, Authors, Title, Year, Journal, Abstract) %>%
   save_csv(., "debug_papers_basic_columns", with_timestamp = FALSE)

##########