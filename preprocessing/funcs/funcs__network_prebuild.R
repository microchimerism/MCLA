#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Find nodes for a specific PubMed-ID

find_nodes_around_table_pmid = function(pmid_start_, edges_, max_iter_ = 30,
                                        min_number_nodes_ = 200, max_number_nodes_ = 500) {

   pmids_found = c(pmid_start_)
   iter = 1
   repeat {
      pmids_found_tmp = vector()
      for (pmid in pmids_found) {
         new_nodes = edges_$to[edges_$from == pmid]  # papers which are cited paper with pmid 
         pmids_found_tmp = append(pmids_found_tmp, new_nodes)
         #print(paste(" - PMID =", pmid, "found", length(new_nodes), "new nodes in edges from ->"))
         new_nodes = edges_$from[edges_$to == pmid]  # papers which cite paper with pmid
         pmids_found_tmp = append(pmids_found_tmp, new_nodes)
         #print(paste(" - PMID =", pmid, "found", length(new_nodes), "new nodes in edges -> to"))
      }
      pmids_found_tmp = unique(c(pmids_found, pmids_found_tmp))
      #print(paste("PMIDs found =", length(pmids_found), "of min_number_nodes =", min_number_nodes_))
      #print(paste("Iter =", iter, "of max_iter =", max_iter_))

      if ((length(pmids_found_tmp) >= min_number_nodes_) || (iter >= max_iter_)) {
         if (length(pmids_found_tmp) < max_number_nodes_) {
            pmids_found = pmids_found_tmp
         }
         break
      }
      pmids_found = pmids_found_tmp
      iter = iter + 1
   }
   pmids_found = pmids_found[pmids_found != 0]
   print(paste("PMIDs found in total =", length(pmids_found)))
   pmids_found = paste(pmids_found, collapse = ", ")  # as string, otherwise the output cannot be stacked correctly as rows of multiple lengths

   return(pmids_found)
}

########## Find nodes relevant for the network building for all papers

network_prebuild = function(papers_, edges_, cores_number_ = 4) {

   my_cluster = parallel::makeCluster(cores_number_)
   doParallel::registerDoParallel(my_cluster)
   doSNOW::registerDoSNOW(my_cluster)

   progress_bar = utils::txtProgressBar(min = 1, max = nrow(papers_), style = 3)
   progress = function(n) setTxtProgressBar(progress_bar, n)
   progress_bar_options = list(progress = progress)

   Network_PMIDs = foreach::foreach(ii = 1:nrow(papers_),
                                    .export = c("find_nodes_around_table_pmid"),
                                    .combine = "rbind",
                                    .options.snow = progress_bar_options) %dopar%
   {
      result = tryCatch(
         {
            find_nodes_around_table_pmid(papers_$PMID[ii], edges_)  # call function
         },
         error = function(e) {
            message(paste("Error for PMID", papers_$PMID[ii], ":", conditionMessage(e)))
            return(NULL)
         },
         finally = {
            doParallel::stopImplicitCluster()
         }
      )
      return(result)
   }

   close(progress_bar)
   doParallel::stopImplicitCluster()
   parallel::stopCluster(my_cluster)

   papers_$Network_PMIDs = as.vector(Network_PMIDs)

   return(papers_)
}

##########