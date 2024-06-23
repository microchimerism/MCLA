##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Source functions

source("server/server__table__funcs.R", local = TRUE)

########## Render filtered table

output$shiny_table =
   DT::renderDT({

      if (nrow(table_filtered_search()) == 0) {

         # Show an empty data table if no results are found
         DT::datatable(data = data.frame(Message = "No matching records found"),
                       rownames = FALSE,
                       options = list(columnDefs = list(list(className = "dt-center",
                                                         targets = 0))
                       )
         )

      } else {

         # Show the filtered data table
         DT::datatable(

            # Call the filtered table as function
            data = table_filtered_search(),

            # Load and include extension modules
            extensions = c("Buttons",
                           "FixedHeader"),

            # Do not escape html formatting in these columns
            escape = -c(position_column(table_filtered_search(), " "),
                        position_column(table_filtered_search(), "DOI")),

            # No user changes of table allowed
            editable = FALSE,

            # Hide the row numbers
            rownames = FALSE,

            # Necessary for the selection of rows in the callback javascript function
            selection = list(mode = "single",
                             target = "row",
                             selected = 0),

            # Each column has its own search box
            filter = list(position = "top",
                          clear = TRUE,
                          plain = FALSE),

            # Further options
            options = list(

               # For debugging (see also server.R): if TRUE export table settings to console
               #stateSave = TRUE,

               # Structure of table elements: (B)utton-(l)ength-(f)ind-p(r)ocessing-(t)able-(i)nformation-(p)agination
               dom = "Blrtip",

               # Fix the table header during scrolling - does not work
               fixedHeader = FALSE,

               # Mark found search terms
               searchHighlight = TRUE,

               # Search delay in [ms]
               searchDelay = 0,

               # Search options for global search
               # search = list(regex = TRUE, smart = FALSE, caseInsensitive = TRUE),

               # Search options for column search
               # searchCols = list(NULL,  # plus/minus
               #                   list(search = "", regex = TRUE, smart = FALSE, caseInsensitive = TRUE),  # Title
               #                   list(search = "", regex = TRUE, smart = FALSE, caseInsensitive = TRUE),  # Authors
               #                   NULL,  # Year
               #                   list(search = "", regex = TRUE, smart = FALSE, caseInsensitive = TRUE),  # Journal
               #                   NULL,  # Type
               #                   NULL  # DOI
               # ),

               # Buttons for table export
               buttons = list(list(extend = "csv",
                                   exportOptions = list(columns = ":visible")),
                              list(extend = "excel",
                                   exportOptions = list(columns = ":visible")),
                              list(extend = "print",
                                   exportOptions = list(columns = ":visible"))
               ),

               # The table is split into multiple pages
               paging = TRUE,

               # Number of rows per page
               lengthMenu = list(c(15, 30, 45, 100, -1),
                                 c("15", "30", "45", "100", "All")),

               # Special column properties
               columnDefs = list(

                  # Hide all columns that are not selected as well as pmid and abstract
                  list(targets = table_columns_to_hide(),
                       visible = FALSE),

                  # For column with index=0: expand symbol (+) is clickable
                  list(targets = 0,
                       className = "details-control",
                       orderable = FALSE),

                  # For column with index=0: width and center text
                  list(targets = 0,
                       className = "dt-center",
                       width = "30px"),

                  # For all columns: center all headers
                  list(targets = "_all",
                       className = "dt-head-center"),

                  # For specific columns: hide the search fields
                  list(targets = c(" ", "Year", "Type", "Citations", "DOI"),
                       searchable = FALSE),

                  # For specific columns: show the search fields
                  list(targets = c("Title", "Authors", "Journal"),
                       searchable = TRUE)
               ),

               # Enable smart column search
               initComplete = DT::JS(paste("
                  function(settings) {
                     let instance = settings.oInstance;
                     let col_search_handler = instance.parent().find('.form-group input');
                     let table = instance.api();

                     col_search_handler.off();  // turn of the default datatable search handler

                     //col_search_handler.on('keyup.columnSearch', columnSearchDelay(function(e) {  // custom column search handler
                     col_search_handler.on('keyup.columnSearch', columnSearchEnter(function(e) {  // custom column search handler
                        let col_search_str = $(this).val().trim();
                        let index = col_search_handler.index(this);
                        let column = table.column(index);
                        if (col_search_str === '') {
                           column.search('').draw();
                        } else {
                           let col_regex_str = columnSearchStringToRegexString(col_search_str);
                           column.search(col_regex_str, true, false, true).draw();
                           setTimeout(function() {  // highlight the column search terms
                              let col_search_terms = searchStringToSearchTerms(col_search_str);
                              column.nodes().to$().highlight(col_search_terms);
                           }, ", time_highlight_delay, ");
                        }
                     }));
                     //}, ', time_search_delay, '));  // replace ' with ''
                  }
               ", sep = ""))
            ),

            # Define specific interactions as javascript
            callback = DT::JS(paste("
               // Format the abstract text in the child row
               var format = function( data ) {
                  return '<div class=\"div-row-child-abstract\"> ' + data[", position_column(table_filtered_search(), "Abstract") - 1, "] + '</div>';
               };

               // Open/close abstract text by clicking
               table.on('click', 'td.details-control', function() {
                  var td = $(this);  // table data
                  var tr = td.closest('tr');  // table row
                  var row = table.row(tr);  // row
                  if (!row.child.isShown()) {
                     // The row is closed: open it by using class name 'row-child-abstract', highlight the search results and change symbol to (-)
                     row.child(format(row.data()), 'row-child-abstract').show();
                     row.child().highlight( $.trim( table.search().split(/\\s+/) ));
                     td.html(", quote(symbol_minus), ");
                     //tr.addClass('shown');
                     tr.addClass('selected');
                  } else {
                     // The row is opened: close it and change symbol to (+)
                     row.child.hide();
                     td.html(", quote(symbol_plus), ");
                     //tr.removeClass('shown');
                     tr.addClass('selected');
                  }
               });
            ", sep = ""))
         ) %>%

         # Format (+) and (-) symbols
         DT::formatStyle(columns = c(" "), fontSize = "18px", fontWeight = "extra bold", cursor = "pointer")
      }
   },
   server = TRUE)

##########