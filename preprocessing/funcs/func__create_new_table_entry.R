#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Create new table entry from the xml-data

create_new_table_entry = function(PMID_ = NA,
                                  DOI_ = NA,
                                  Authors_ = NA,
                                  Year_ = NA,
                                  Journal_ = NA,
                                  Title_ = NA,
                                  Abstract_ = NA,
                                  Type_ = NA,
                                  References_ = NA,
                                  References_PMID_ = NA,
                                  MeSH_Keywords_ = NA,
                                  ABORT_ = NA) {

   new_entry = data.frame(
      PMID = PMID_,
      DOI = DOI_,
      Authors = Authors_,
      Year = Year_,
      Journal = Journal_,
      Title = Title_,
      Abstract = Abstract_,
      Type = Type_,
      References = References_,
      References_PMID = References_PMID_,
      MeSH_Keywords = MeSH_Keywords_,
      ABORT = ABORT_
   )

   return(new_entry)
}

##########