##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Number papers

num_papers_10k = function() {
   num = round(nrow(table_raw) / 1000, digits = 0)
   return(num)
}

######### Tabulator help

embed_img = function(img_file_name) {
   txt = paste("<img src='images/info/", img_file_name, "' class='info-image-in-text'>", sep = "")
   return(txt)
}

######### Tabulator help

tab_item_info =
   shinydashboard::tabItem(

      # Tabulator id
      tabName = "tab_info",

      shiny::fluidPage(

         shinydashboardPlus::box(

            # Box id
            id = "box_for_info",  # necessary for javascript function for full height of box

            # Box options
            title = "Info",
            status = "info",
            width = 11,
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,

            htmltools::HTML(paste("
               <h1 class='info-h1'>
                  Aim</h1>
               <p class='info-p'>
                  The <em>Microchimerism Literature Atlas (MCLA)</em> aims to support scientists in their search for microchimerism
                     literature.
                  Currently, the <em>MCLA</em> contains the metadata of more than ", num_papers_10k(), ",000 scientific articles and
                     reviews, covering the period from 1970 to the present.
                  The publicly available metadata was downloaded from PubMed&reg by applying multiple MeSH term searches.
                  </br>
                  The <em>MCLA</em> is structured modularly, consiststing of the 5 dashboards 'Data Table', 'Filter Settings', 
                     'Chart View', 'Network View' and 'Info'.
                  The currently displayed dashboard can be changed, e.g., to the filter settings, by clicking the ",
                     embed_img("menu_button_filtersettings.png"), "-tab in the header or by clicking the ",
                     embed_img("sidebar_button_filtersettings.png"), "-tab in the sidebar.</p>
               <h1 class='info-h1'>
                  Data Table</h1>
               <p class='info-p'>
                  In the ", embed_img("menu_button_datatable.png"), "-tab, the paper titles, the authors, the publication years,
                     the publishing journals, the publishing types and the DOIs are shown in the form of a data table.
                  The displayed columns can be changed through marking the checkboxes in the sidebar.
                  Additionally, the abstract can be viewed by clicking the ", embed_img("symbol_expand.png"), "-symbol after the
                     selection of a table row.
                  The papers in the table occur in a random order and can be sorted ascendingly or descendingly by clicking the ",
                     embed_img("order_column_entries_ascending.png"), "- or the ", embed_img("order_column_entries_descending.png"),
                     "-buttons placed in the column header, respectively.</p>
               <h1 class='info-h1'>
                  Searching</h1>
               <p class='info-p'>
                  In the ", embed_img("menu_button_datatable.png"), "-tab, the <em>MCLA</em> can be searched for keywords, either
                     across all columns and in the abstracts by using the ", embed_img("search_field_all.png"), "-search box, or
                     witin columns by using the ", embed_img("search_field_column.png"), "-search boxes at the top of the table
                     columns.
                  The search is performed after pressing the enter key.
                  Further, the search offers the possibility to search for whole words, word parts, consecutive words and to 
                     combine them by operators.</p>
                  <ul style = 'padding-left: 70px;'>
                     <li><em>Search for word parts:</em>&nbsp; <b>wordpart</b>,
                        e.g., <i>microchim</i> or&nbsp; <i>alloantibo</i></li>
                     <li><em>Search for whole words using double quotes:</em>&nbsp; <b>&#34;wholeword&#34;</b>,
                        e.g., <i>&#34;chimerism&#34;</i> or&nbsp; <i>&#34;bodies&#34;</i></li>
                     <li><em>Search for consecutive words:</em>&nbsp; <b>word1 word2</b>,
                        e.g., <i>bone marrow</i> or&nbsp; <i>stem cell</i></li>
                     <li><em>Use of AND-operator:</em>&nbsp; <b>word1 AND word2</b>,
                        e.g., <i>maternal AND microchimerism</i> or&nbsp; <i>disease AND 2022</i></li>
                     <li><em>Use of OR-operator:,</em>&nbsp; <b>word1 OR word2</b>,
                        e.g., <i>fetomaternal OR pregnancy</i> or&nbsp; <i>stem cell OR blood cell</i></li>
                     <li><em>Use of NOT-operator:</em>&nbsp; <b>word1 NOT word2</b>,
                        e.g., <i>NOT cancer</i> or&nbsp; <i>&#34;chimerism&#34; NOT microchimerism</i></li>
                     <li><em>Combination of the rules:</em>&nbsp; e.g., <i>cell AND microchimerism NOT transplantation OR &#34;chimerism&#34; OR stem cell</i></li>
                  </ul>
               <p class='info-p'>
                  If the search is not performed after pressing the 'Enter'-key, the assemblence of the search terms is incorrect
                     - check for open double quotes.
                  The search results received with the ", embed_img("search_field_all.png"), "-search box also affect the charts
                     in the ", embed_img("menu_button_chart.png"), "-tab.</p>
               <h1 class='info-h1'>
                  Filtering and Export</h1>
               <p class='info-p'>
                  Pre-selected keywords in the ", embed_img("menu_button_filtersettings.png"), "-tab can be used to search the titles
                     and abstracts, the article types and the publishing dates.
                  The search terms within the categories can either be combined by OR (any article whose metadata scontains at least
                     one of the selected search terms) or by AND (any abstract that contains all selected search terms) through toggling
                     the radio button ", embed_img("filter_AND_OR.png"), ".
                  The chosen filter settings are applied while switching back to the data table view, by clicking the ", 
                     embed_img("menu_button_datatable.png"), "-tab.
                  Furthermore, the filtered papers can then be downloaded as text file, as Excel file or printed by clicking on the ",
                     embed_img("export_data_csv.png"), "-, ", embed_img("export_data_xlsx.png"), "- or ",
                     embed_img("export_data_print.png"), "-buttons in the sidebar, respectively.</p>
               <h1 class='info-h1'>
                  Chart View</h1>
               <p class='info-p'>
                  Depending on the selected filter settings in the ", embed_img("menu_button_filtersettings.png"), "-tab, some insightful
                     charts are shown in the ", embed_img("menu_button_chart.png"), "-tab regarding the number of published papers over
                     time, the most active authors, the most publishing journals, and the most frequently used title words and keywords.
                  The styles of most charts can be changed by clicking on the plots.
                  Additionally, heat map charts show the time development of the techniques and the top ranked publishing journals,
                     in which the cells are colored from lowest to highest value by the following color scheme ",
                     embed_img("heatmap_colorbar.png"), ".</p>
               <h1 class='info-h1'>
                  Network View</h1>
               <p class='info-p'>
                  The literature network in the ", embed_img("menu_button_network.png"), "-tab is build based on the PubMed-IDs listed
                     in the references of the downloaded papers.
                  In the network, the PubMed-IDs are shown as number under each node ", embed_img("network_node_pmid.png"), ".
                  The shape of the nodes highlight articles ", embed_img("network_node_shape_article.png"), " and reviews ",
                     embed_img("network_node_shape_review.png"), " listed in the table and further literature ",
                     embed_img("network_node_shape_nodata.png"), " that does not appear in it.
                  Moreover, arrows ", embed_img("network_arrow.png"), " indicate citations.
                  The network is created around a paper which is selected by clicking a table row in the ", embed_img("menu_button_datatable.png"), "-tab
                     and then switching to the ", embed_img("menu_button_network.png"), "-tab.
                  The construction of large citation networks may take several seconds.
                  The selected node is indicated by a colored outer border as ", embed_img("network_node_selected_article.png"), ", ",
                     embed_img("network_node_selected_review.png"), " or ", embed_img("network_node_selected_nodata.png"), ".
                  In the ", embed_img("menu_button_network.png"), "-tab, the selected node can either be changed by clicking on another node or by using
                     the drop-down list ", embed_img("network_id_selection.png"), ".
                  Additionally to the selected nodes, also the direct neighbors are highlighted.
                  To gain a better overview of the whole network, no node can be selected by clicking in the empty area between the nodes or by selecting
                     no node in drop-down list ", embed_img("network_id_selection.png"), ".
               <p style='text-align: center; margin: 20px'>
                  <img src='images/info/network_view_selected_unselected.png' style='width: 100%; max-width: 538px;'></p>
               <p class='info-p'>
                  Zooming can be achieved either by simultaneously holding the Ctrl-key and turning the mouse wheel or through ",
                     embed_img("network_navigation_zoom_in.png"), "- and ", embed_img("network_navigation_zoom_out.png"), "-button.
                  The original view is restored by the ", embed_img("network_navigation_restore.png"), "-button.
                  Navigation is possible either by simultaneously clicking the left mouse button and panning or by using the navigation buttons ",
                     embed_img("network_navigation_right.png"), ", ", embed_img("network_navigation_up.png"), ", ",
                     embed_img("network_navigation_left.png"), " and ", embed_img("network_navigation_down.png"), ".</p>
               <h1 class='info-h1'>
                  Access to Full Text Articles</h1>
               <p class='info-p'>
                  The full text articles can be accessed, as long as the necessary access rights of the journal exist, by clicking a DOI in the ",
                     embed_img("menu_button_datatable.png"), "-tab.
                  </br>
                  </br></p>
               <p class='info-p'>
                  <b>Acknowledgments</b>
                  </br>
                  The <em>MCLA</em> is part of the 'We All Are Multitudes: The Microchimerism, Human Health and Evolution Project'
                     that is funded by the John Templeton foundation (Grant-ID 62214).
                  </br>
                  The <em>MCLA</em> was implemented by using the Shiny package:
                  </br>
                  <em>Chang W, Cheng J, Allaire J, Sievert C, Schloerke B, Xie Y, Allen J, McPherson J, Dipert A, Borges B (2024). shiny:
                     Web Application Framework for R.
                  </br>
                  R package version 1.8.0.9000, https://github.com/rstudio/shiny, https://shiny.posit.co/.</em></p>
            ", sep = ""))
         )
      )
   )

##########