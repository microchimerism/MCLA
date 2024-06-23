##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Extract the information from the references with PMIDs

extract_nodes_from_references = function(papers_) {

   references =
      papers_ %>%
      dplyr::select(all_of(c("References_PMID", "References"))) %>%
      dplyr::filter(References_PMID != "")

   pmids_already_used = papers_$PMID
   nodes = data.frame()

   progressbar = utils::txtProgressBar(min = 0, max = nrow(references), style = 3)

   for (ii in seq(nrow(references))) {
      pmids = as.numeric(unlist(strsplit(references[ii, 1], ", ")))
      refs = unlist(strsplit(references[ii, 2], "-;-"))

      for (jj in seq(length(pmids))) {
         pmid = pmids[jj]

         if (!(pmid %in% pmids_already_used)) {

            ref_parts = unlist(strsplit(refs[jj], ". ", fixed = TRUE))
            if (length(ref_parts == 4)) {
               pmids_already_used = append(pmids_already_used, pmid)

               authors = ref_parts[1]
               article_title = ref_parts[2]
               journal = ref_parts[3]
               year = unlist(strsplit(ref_parts[4], ";", fixed = TRUE))[1]

               new_entry = data.frame(PMID = pmid,
                                      Article_Title = article_title,
                                      Authors = authors,
                                      Year = year,
                                      Journal = journal,
                                      Type = "Not in MC Atlas")

               nodes = rbind(nodes, new_entry)
            }
         }
      }

      utils::setTxtProgressBar(progressbar, ii)
   }
   close(progressbar)

   return(nodes)
}

########## Build nodes from data frame

build_nodes_from_dataframe = function(papers_) {

   # The nodes directly given by the sources
   nodes1 =
      papers_ %>%
      dplyr::rename(Article_Title = Title) %>%
      dplyr::select(all_of(c("PMID", "Article_Title", "Authors", "Year", "Journal", "Type")))

   # The nodes extracted from the references
   nodes2 = extract_nodes_from_references(papers_)

   nodes =
      rbind(nodes1, nodes2) %>%
      dplyr::mutate(id = as.numeric(PMID)) %>%
      dplyr::rename(group = Type) %>%
      dplyr::mutate(title = paste("<B>Title:</B>  ", Article_Title, "<br>",
                                  "<B>Authors:</B>  ", Authors, "<br>",
                                  "<B>Journal:</B>  ", Journal, "<br>",
                                  "<B>Year:</B>  ", Year)) %>%
      dplyr::mutate(size = 30) %>%
      dplyr::select("id", "group", "title", "size")

   cat("nodes column types: ", sapply(nodes, typeof))

   return (nodes)
}

##########