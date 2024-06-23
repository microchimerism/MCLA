##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Helper function

read_out_row_list = function(str_row) {

   list_pmid = strsplit(str_row, ", ")
   list_pmid = lapply(list_pmid, as.numeric)
   list_pmid = unlist(list_pmid)

   return(list_pmid)
}

########## Build edges from data frame

build_edges_from_dataframe = function(papers_) {

   papers_with_ref_pmid =
      papers_ %>%
      dplyr::filter(References_PMID != "")

   edges = data.frame(from = character(),
                      to = character(),
                      type = character(),
                      weight = character())

   col_id_s = which(colnames(papers_with_ref_pmid) == "PMID")  # get col index for source and target
   col_id_t = which(colnames(papers_with_ref_pmid) == "References_PMID")

   progressbar = utils::txtProgressBar(min = 0, max = nrow(papers_with_ref_pmid), style = 3)

   counter = 1
   for (ii in seq(nrow(papers_with_ref_pmid))) {
      source = as.numeric(papers_with_ref_pmid[[ii, col_id_s]])
      list_pmid = read_out_row_list(papers_with_ref_pmid[[ii, col_id_t]])

      for (target in list_pmid) {
         source = as.character(source)
         target = as.character(target)
         edges[counter, ] = c(source, target, "hyperlink", 1)
         counter = counter + 1
      }

      utils::setTxtProgressBar(progressbar, ii)
   }
   close(progressbar)

   edges = edges[!duplicated(edges), ]  # remove duplicates

   cat("edges column types: ", sapply(edges, typeof))

   return(edges)
}

##########