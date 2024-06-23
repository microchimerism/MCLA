#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Download the papers' meta data from PubMed in parallel

download_xml_from_pubmed = function(search_string_list_,
                                    api_key_,
                                    batch_size_,
                                    download_directory_,
                                    cores_number_ = 4) {

   my_cluster = parallel::makeCluster(cores_number_)
   doParallel::registerDoParallel(my_cluster)
   doSNOW::registerDoSNOW(my_cluster)

   progress_bar = utils::txtProgressBar(min = 1, max = length(search_string_list_), style = 3)
   progress = function(n) setTxtProgressBar(progress_bar, n)
   progress_bar_options = list(progress = progress)

   foreach::foreach(ii = 1:length(search_string_list_),
                    .combine = "rbind",
                    .errorhandling = "pass",
                    #.export = c(),
                    .packages = c("easyPubMed"),
                    .options.snow = progress_bar_options) %dopar%
   {
      tryCatch( 
         {
            easyPubMed::batch_pubmed_download(  # call function
               pubmed_query_string = search_string_list_[ii],
               dest_dir = download_directory_,
               dest_file_prefix = sprintf("batch_%03d_", ii),
               api_key = api_key_,
               format = "xml",
               batch_size = batch_size_,
               encoding = "UTF-8")
         },
         error = function(e) {
            message(paste("Error for search string", search_string_list_[ii], ":", conditionMessage(e)))
            return(NULL)
         },
         finally = {
            doParallel::stopImplicitCluster()
         }
      )
   }

   close(progress_bar)
   doParallel::stopImplicitCluster()
   parallel::stopCluster(my_cluster)
}

##########