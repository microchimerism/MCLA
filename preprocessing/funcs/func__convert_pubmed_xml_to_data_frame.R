#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universität Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Convert each xml data to a data table entry

convert_pubmed_xml_to_data_frame = function(download_directory) {

   papers = data.frame()
   list_files = dir(download_directory, all.files = FALSE, full.names = FALSE)

   progressbar = utils::txtProgressBar(min = 0, max = length(list_files), style = 3)

   for(fname in list_files) {
      ffname = file.path(download_directory, fname)

      list_papers_batch =
         readChar(ffname, file.info(ffname)$size, useBytes = TRUE) %>%
         easyPubMed::articles_to_list(.)

      for (ii in 1:length(list_papers_batch)) {
         tryCatch(
            {
               paper_extracted = extract_pubmed_xml(list_papers_batch[ii], DEBUG = FALSE)
               if (!inherits(paper_extracted, "try-error")) {
                  papers = rbind(papers, paper_extracted)
               }
            },
            error = function(e) {
               message(paste("Error processing paper:", ii, "in file:", ffname))
               message(e)
            }
         )
      }
      utils::setTxtProgressBar(progressbar, which(list_files == fname))
   }
   close(progressbar)

   return(papers)
}

##########