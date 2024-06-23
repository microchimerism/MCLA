##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#
# See also:
# https://kateto.net/network-visualization/
# https://datastorm-open.github.io/visNetwork/
# https://rdrr.io/cran/visNetwork/
#


########## Double click on a network node opens doi-resolver or pubmed search

shiny::observeEvent(

   input$network_click_node_pmid, {
      pmid = shiny::isolate(input$network_click_node_pmid)
      if (any(table_raw$PMID == pmid)) {
         link_doi = table_raw$DOI[table_raw$PMID == pmid]
         url_doi = gsub("<a href='(.+)' target.*", "\\1", link_doi)
         browseURL(url_doi)  # open doi-resolver
      } else {
         url_pmid = paste("https://pubmed.ncbi.nlm.nih.gov/", as.character(pmid), sep = "")
         browseURL(url_pmid)  # open pubmed
      }
   })

########## Build interactive reference network map

build_network = function(nodes_, edges_, id_selected_) {

   network_ =
      visNetwork::visNetwork(nodes_,
                             edges_,
                             #main = "Microchimerism Literature Network",
                             submain = "by PubMed-IDs (build on available PubMed-References)"
                             # height - is adapted by Javascript functions
      ) %>%

      # User interactions
      visNetwork::visOptions(highlightNearest = TRUE,
                             nodesIdSelection = list(enabled = TRUE,
                                                     style = "visible: false;",
                                                     selected = id_selected_)
      ) %>%
      visNetwork::visInteraction(hover = TRUE,  # shows nodes$title
                                 navigationButtons = TRUE
      ) %>%
      visNetwork::visEvents(doubleClick =
         "function(nodes) {
            Shiny.setInputValue('network_click_node_pmid', nodes.nodes);
         }"
      ) %>%
      # visEvents(click =
      #    "function(e, nodes) {
      #       if (e.event.srcEvent.ctrlKey) {
      #          Shiny.setInputValue('network_click_node_pmid', nodes.nodes);
      #       }
      #    }"
      # ) %>%

      # Network layout
      visNetwork::visIgraphLayout(layout = "layout_nicely",  # see: https://igraph.org/r/doc/layout_.html
                                  physics = TRUE,
                                  smooth = TRUE
      ) %>%

      # Physics for movable network
      visNetwork::visPhysics(enabled = TRUE,
                             solver = "forceAtlas2Based",  # see: https://rdrr.io/cran/visNetwork/man/visPhysics.html
                             forceAtlas2Based = list(centralGravity = 0.005,
                                                     gravitationalConstant = -100,
                                                     springLength = 200,
                                                     springConstant = 0.04,
                                                     damping = 1.0,
                                                     avoidOverlap = 0.5),
                             stabilization = FALSE
      ) %>%

      # Format nodes and edges (links)
      visNetwork::visNodes(borderWidth = 1.0,
                           shadow = TRUE
      ) %>%
      visNetwork::visEdges(width = 1.0,
                           arrows = list(to = list(enabled = TRUE,
                                                   scaleFactor = 1.2)),
                           color = list(color = "gray",
                                        highlight = "black"),
                           shadow = FALSE
      ) %>%

      # Define groups and/for legend
      visNetwork::visGroups(groupname = "Article",
                            shape = "dot",
                            color = list(background = "tomato",
                                         border = "black",
                                         highlight = list(background = "orange",
                                                          border = "darkred"))
      ) %>%
      visNetwork::visGroups(groupname = "Review",
                            shape = "square",
                            color = list(background = "gold",
                                         border = "black",
                                         highlight = list(background = "orange",
                                                          border = "darkred"))
      ) %>%
      visNetwork::visGroups(groupname = "Not in MC Atlas",
                            shape = "dot",
                            color = list(background = "lightblue",
                                         border = "black")
      ) %>%
      visNetwork::visLegend(position = "right")

   return(network_)
}

##########