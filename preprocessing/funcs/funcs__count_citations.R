#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universit?t Graz #
# Lehrstuhl fuer Histologie     #
#################################
#


########## Count the number of citations

count_citation = function(pmid, citations) {

   counts = sum(pmid == citations)

   return(counts)
}

########## Create new table entry from the xml-data

count_citations = function(papers_, edges_) {

   counts = lapply(papers_$PMID, count_citation, citations = edges_$to)
   papers_$Citations = unlist(counts)

   return(papers_)
}

##########