#################################
# Michael Gruber, 24.06.2021    #
# Medizinische Universität Graz #
# Lehrstuhl fuer Histologie     #
#################################
#
# See:
#  https://rpubs.com/Howetowork/499292
#


########## Extract the meta data from the XML - skip papers with missing critical meta data

extract_pubmed_xml = function(data_,
                              DEBUG_ = FALSE) {

   ABORT = FALSE  # is set to true is critical meta data is not available -> empty data frame is returned

   # Parse file data into a variable (avoid interpretation of symbol codes) and extract the top node (root node)
   xml_data = XML::xmlParse(data_, asText = TRUE)

   # PubMed unique identifier, is a 1 to 8-digit accession number with no leading zeros
   xml_path = "/PubmedArticle/MedlineCitation/PMID"
   PMID = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   PMID = PMID[1]
   if ((length(PMID) == 0) || (PMID == "NULL") || (PMID == "")) {
      PMID = ""
      ABORT = TRUE
   } else {
      if (DEBUG_) { print(paste("PMID:", PMID, sep = " ")) }
      Encoding(PMID) = "UTF-8"
   }

   # ELocationID element provides an electronic location, e.g. via Digital Object Identifiers (DOIs)
   xml_path = "/PubmedArticle/MedlineCitation/Article/ELocationID[@EIdType = \"doi\"]"
   doi1 = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   # The doi of old papers is only in the ArticleID and not in the ELocationID
   xml_path = "/PubmedArticle/PubmedData/ArticleIdList/ArticleId[@IdType = \"doi\"]"
   doi2 = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   DOI = ifelse(length(doi1) == 0, doi2, doi1)
   if ((length(DOI) == 0) || (DOI == "NULL") || (DOI == "")) {
      DOI = ""
      ABORT = TRUE
   } else {
      if (DEBUG_) { print(paste("DOI:", DOI, sep = " ")) }
      Encoding(DOI) = "UTF-8"
   }

   # All authors: last names with initials
   xml_path = "/PubmedArticle/MedlineCitation/Article/AuthorList/Author/LastName"
   author_last_name = XML::xpathApply(xml_data, xml_path, XML::xmlValue)
   xml_path = "/PubmedArticle/MedlineCitation/Article/AuthorList/Author/Initials"
   author_initials = XML::xpathApply(xml_data, xml_path, XML::xmlValue)
   Authors = paste(author_last_name, author_initials, collapse = ", ")
   if ((length(Authors) == 0) || (Authors == "NULL") || (Authors == "")) {
      Authors = ""
      ABORT = TRUE
   } else {
      if (DEBUG_) { print(paste("Authors:", Authors, sep = " ")) }
      Encoding(Authors) = "UTF-8"
   }

   # Publication year
   xml_path = "/PubmedArticle/MedlineCitation/Article/Journal/JournalIssue/PubDate/Year"
   Year = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   if ((length(Year) == 0) || (Year == "NULL") || (Year == "")) {
      Year = ""
      ABORT = TRUE
   } else {
      if (DEBUG_) { print(paste("Year:", Year, sep = " ")) }
      Encoding(Year) = "UTF-8"
   }

   # Journal
   xml_path = "/PubmedArticle/MedlineCitation/Article/Journal/Title"
   Journal = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   if ((length(Journal) == 0) || (Journal == "NULL") || (Journal == "")) {
      Journal = ""
      ABORT = TRUE
   } else {
      if (DEBUG_) { print(paste("Journal:", Journal, sep = " ")) }
      Encoding(Journal) = "UTF-8"
   }

   # Article title
   xml_path = "/PubmedArticle/MedlineCitation/Article/ArticleTitle"
   Title = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   Title = gsub("\\[|\\]", "", Title)  # remove "[" and "]" character from string
   if ((length(Title) == 0) || (Title == "NULL") || (Title == "")) {
      Title = ""
      ABORT = TRUE
   } else {
      if (DEBUG_) { print(paste("Title:", Title, sep = " ")) }
      Encoding(Title) = "UTF-8"
   }

   # Abstract
   xml_path = "/PubmedArticle/MedlineCitation/Article/Abstract/AbstractText"
   Abstract = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   Abstract = paste(Abstract, collapse = ", ")
   if ((length(Abstract) == 0) || (Abstract == "NULL") || (Abstract == "")) {
      Abstract = "No abstract available"  # keep papers with no abstract
   } else {
      if (DEBUG_) { print(paste("Abstract:", Abstract, sep = " ")) }
      Encoding(Abstract) = "UTF-8"
   }

   # Publication type
   xml_path = "/PubmedArticle/MedlineCitation/Article/PublicationTypeList/PublicationType"
   Type = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   Type = Type[1]
   Type = ifelse(grepl("Review", Type, fixed = TRUE), "Review", "Article")

   # References
   xml_path = "/PubmedArticle/PubmedData/ReferenceList/Reference/Citation"
   References = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   References = paste(References, collapse = "-;-")
   Encoding(References) = "UTF-8"

   # PMID References
   xml_path = "/PubmedArticle/PubmedData/ReferenceList/Reference/ArticleIdList/ArticleId[@IdType = \"pubmed\"]"
   References_PMID = XML::xpathSApply(xml_data, xml_path, XML::xmlValue)
   References_PMID = paste(References_PMID, collapse = ", ")

   # MeSH terms (Medical Subject Headings) and Keywords
   xml_path = "/PubmedArticle/MedlineCitation/MeshHeadingList/MeshHeading/DescriptorName"
   mesh_headings = XML::xpathApply(xml_data, xml_path, XML::xmlValue)
   xml_path = "/PubmedArticle/MedlineCitation/KeywordList/Keyword"
   keywords = XML::xpathApply(xml_data, xml_path, XML::xmlValue)
   if (length(mesh_headings) > 0 && length(keywords) > 0) {
      t1 = paste(mesh_headings, collapse = ", ")
      t2 = paste(keywords, collapse = ", ")
      MeSH_Keywords = paste(t1, t2, sep = ", ")
   } else if (length(mesh_headings) > 0) {
      MeSH_Keywords = paste(mesh_headings, collapse = ", ")
   } else if (length(keywords) > 0) {
      MeSH_Keywords = paste(keywords, collapse = ", ")
   } else {
      MeSH_Keywords = ""
   }
   Encoding(MeSH_Keywords) = "UTF-8"

   #####

   # Return a (partially) filled data frame entry
   new_entry = create_new_table_entry(PMID_ = PMID,
                                      DOI_ = DOI,
                                      Authors_ = Authors,
                                      Year_ = Year,
                                      Journal_ = Journal,
                                      Title_ = Title,
                                      Abstract_ = Abstract,
                                      Type_ = Type,
                                      References_ = References,
                                      References_PMID_ = References_PMID,
                                      MeSH_Keywords_ = MeSH_Keywords,
                                      ABORT_ = ABORT)

   return(new_entry)
}

##########