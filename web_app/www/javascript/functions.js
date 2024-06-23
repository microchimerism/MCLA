/* ##############################
# Michael Gruber, 05.03.2023    #
# Medizinische Universität Graz #
# Lehrstuhl fuer Histologie     #
#################################
#
# Debug Javascript: use "console.log('let: ', 123)" and press F12 in Browser
# */

/* ########## Functions */

// Apply a fixed layout to header and sidebar so
// that both do not move, i.e. during table scrolling
$(document).on('shiny:connected', function(event) {
   $('body').addClass('fixed');
});

/* ########## Sidebar */

// Hide the sidebar elements after pressing
// the sidebar-toogle button (jQuery-function)
$(function() {
   $('.sidebar-toggle').on('click', function() {
      $('.div-sidebar-check-boxes').toggle();
      $('#export-buttons-datatable').toggle();
   });
});

// Disable the sidebar tile when hovered over
$('.disabled').click(function( event ) {
   event.preventDefault();
});

/* ########## Box */

// Define function to set height of box with
// id = 'box_for_network' and plot 'network_plot'
function setHeight() {
   let offset_box = 100
   let offset_network_plot = 100
   let window_height = $(window).height();
   let header_height = $('.main-header').height();
   let boxHeight = window_height - header_height - offset_box;

   $('#box_for_network').height(boxHeight);
   $('#network_plot').height(boxHeight - offset_network_plot);
};

// Set input$box_height when the connection is established
$(document).on('shiny:connected', function( event ) {
   setHeight();
});

// Refresh the box height on every window resize event    
$(window).on('resize', function() {
   setHeight();
});

/* ########## Data table */

// Extract used search terms from user input to highlight them
function searchStringToSearchTerms(search_str) {
   let clean_search_str = search_str.replace(/[^A-Za-z0-9 ]/g, '');  // Remove all characters except alphanumeric and spaces
   let search_terms = clean_search_str.trim().split(/\b(AND|OR|NOT)\b/g);  // Split at ANDs, ORs and NOTs
   search_terms = search_terms.map(str => str.trim());  // Trim terms
   search_terms = search_terms.filter(term => term && !['AND', 'OR', 'NOT'].includes(term));  // Filter out logical operators and empty strings
   //console.log('search_terms:', search_terms)
   return search_terms;
};

// Delay the search for some time after key press
//function searchDelay(fn, ms) {
//   let timer = 0;
//   return function(...args) {
//      clearTimeout(timer);
//      timer = setTimeout(fn.bind(this, ...args), ms || 0);
//   }
//};


// Global search: delay the search for some time after
// key up or start immediately if 'Enter' is pressed
//function initGlobalSearchDelay(ms) {
//   $(document).on('shiny:connected', function() {
//      let timer = 0;
//      $('#glo_search_str').on('keyup input', function(e) {
//         clearTimeout(timer);
//         if (e.type === 'keyup' && e.key === 'Enter') {
//            Shiny.setInputValue('glo_search_str_debounced', this.value, {priority: 'event'});
//         } else {
//            timer = setTimeout(() => {
//               Shiny.setInputValue('glo_search_str_debounced', this.value, {priority: 'event'});
//            }, ms);
//         }
//      });
//   });
//};

// Global search: after if 'Enter' is pressed and highlight the search terms
function initGlobalSearchEnter(ms) {
   $(document).on('shiny:connected', function() {
      const handler = $('.dataTables_filter input').closest('.dataTables_wrapper').find('.dataTable');  // Handler for the data table
      let search_terms_old = '';
      function highlightSearchTerms(search_str) {  // Function to handle the highlighting of search terms
         setTimeout(function() {
            handler.unhighlight(search_terms_old);
            let search_terms = searchStringToSearchTerms(search_str);
            handler.highlight(search_terms);
            search_terms_old = search_terms;
         }, ms);
      };

      $('#glo_search_str').on('keyup input', function(e) {  // Handle the global search input delay and highlighting
         let glo_search_str = this.value;
         if (e.type === 'keyup' && e.key === 'Enter') {  // If 'Enter' key is pressed set input value immediately
            Shiny.setInputValue('glo_search_str_debounced', glo_search_str, {priority: 'event'});
            highlightSearchTerms(glo_search_str);   // No additional delay when pressing Enter
         }
      });
   });
};

// Global search: delay the search for some time after
// key up or start immediately if 'Enter' is pressed
// and also the highlighting of the search terms
//function initGlobalSearchDelay(delay_search_ms, delay_highlight_ms) {
//   $(document).on('shiny:connected', function() {
//      const handler = $('.dataTables_filter input').closest('.dataTables_wrapper').find('.dataTable');  // Handler for the data table
//      let search_terms_old = '';
//      function highlightSearchTerms(search_str) {  // Function to handle the highlighting of search terms
//         setTimeout(function() {
//            handler.unhighlight(search_terms_old);
//            let search_terms = searchStringToSearchTerms(search_str);
//            handler.highlight(search_terms);
//            search_terms_old = search_terms;
//         }, delay_highlight_ms);
//      };
//
//      let timer = 0;
//      $('#glo_search_str').on('keyup input', function(e) {  // Handle the global search input delay and highlighting
//         let glo_search_str = this.value;
//
//         clearTimeout(timer);
//         if (e.type === 'keyup' && e.key === 'Enter') {  // If 'Enter' key is pressed set input value immediately
//            Shiny.setInputValue('glo_search_str_debounced', glo_search_str, {priority: 'event'});
//            highlightSearchTerms(glo_search_str);   // No additional delay when pressing Enter
//         } else {
//            timer = setTimeout(() => {  // Use the debounce delay to set the input value and then highlight search terms
//               Shiny.setInputValue('glo_search_str_debounced', glo_search_str, {priority: 'event'});
//               highlightSearchTerms(glo_search_str);
//            }, delay_search_ms);
//         }
//      });
//   });
//};


// Column search: after if 'Enter' is pressed
function columnSearchEnter(fn) {
   return function(e, ...args) {
      if (e.type === 'keyup' && e.key === "Enter") {
         fn.apply(this, args);
      }
   };
};

// Column search: delay the search for some time after
// key up or start immediately if 'Enter' is pressed
//function columnSearchDelay(fn, ms) {
//   let timer = 0;
//   return function(...args) {
//      clearTimeout(timer);
//      const event = args[0];
//      if (event.type === 'keyup' && event.key === "Enter") {
//         fn.apply(this, args);
//      } else {
//         timer = setTimeout(() => fn.apply(this, args), ms);
//      }
//   };
//};

// Column search: create a logic
// regex string from the search string
function columnSearchStringToRegexString(search_str) {
   let clean_search_str = search_str.replace(/[^A-Za-z0-9 "]/g, '');  // Remove all characters except alphanumeric and spaces
   let parts = clean_search_str.trim().split(/\s+/);  // Trim string and split at spaces

   let num_open_quotes = 0;  // Check if double quotes are used correctly
   for (let part of parts) {
      let is_operator = /(AND|OR|NOT)/.test(part);
      if (num_open_quotes > 0 && is_operator) { return ''; }  // ERROR: operator with open double quotes
      for (let char of part) {
         if (char === '"') {
            num_open_quotes = num_open_quotes === 0 ? 1 : 0;
            if (num_open_quotes > 0 && is_operator) { return ''; }  // ERROR: operator with open double quotes
         }
      }
      if (num_open_quotes > 0 && is_operator) { return ''; }  // ERROR: operator with open double quotes
   }

   if (num_open_quotes === 0) {
      parts = parts.map(part => part.replace(/"/g, '\b')); // Replace double quotes with \b
   } else {
      return "";  // ERROR: unmatched double quotes
   }

   if (parts[0] === 'NOT') {
      regex_str = '^(?!.*(';
      parts.shift(); // Remove the first element
   } else {
      regex_str = '^(?=.*(';
   }

   let last_part = 'operator';
   for (let part of parts) {
      if ((['AND', 'OR', 'NOT'].includes(part)) && (last_part === 'operator')) { return ''; }  // Error: two operators after each other -> regex_str = ''
      if (part === 'AND') {
         regex_str += '))(?=.*(';  // 'term1 AND term2' => (?=.*term1)(?=.*term2)
      } else if (part === 'OR') {
         regex_str += '|';  // 'term1 OR term2' => (?=.*(term1|term2))
      } else if (part === 'NOT') {
         regex_str += '))(?!.*(';  // 'term1 NOT term2' => (?=.*term1)(?!.*term2)
      } else {
         regex_str += (last_part === 'term' ? '[[:space:]]' : '') + part;  // 'term1 term2' => (?=.*term1[[:space:]]term2)
      }
      last_part = ['AND', 'OR', 'NOT'].includes(part) ? 'operator' : 'term';
   }
   regex_str += '))';
   regex_str = regex_str.replace(/\(\?(\=|\!)\.\*\(\)\)/g, ''); // Clean up empty regex parts
   regex_str = regex_str.replace(/\|\)/g, ')'); // Correct trailing OR condition
   //console.log('search_str:', search_str, ', regex_str:', regex_str);
   return regex_str;
}

// Export the filtered data table as per button, e.g. '.buttons-csv'
function exportDatatablePerButton( button ) {
  $( button ).click();
};

// Place the data table export functions in the sidebar
// into a section with the id sidebar-table-buttons
// callback = DT::JS('placeExportButtonsInSidebar();'')
//function placeExportButtonsInSidebar() {
//   $('#export-buttons-datatable').append($('div.dt-buttons'));
//}

// Do not search after each typed character, better wait
// a defined time till the user stopped typing
//$(document).ready(function() {
//   let mainSearchWait = 0;
//   let columnSearchWait = [];
//   let searchDelayInterval = 1000;
//
//   let table = $('#shiny_table').DataTable();
//
//   // Main search bar
//   $('#shiny_table_filter input')
//     .unbind('keyup')
//     .bind('keyup', function() {
//       clearTimeout(mainSearchWait);
//       mainSearchWait = setTimeout(function() {
//         let searchTerm = $(this).val();
//         table.search(searchTerm).draw();
//       }, searchDelayInterval);
//     });
//
//   // Column-specific search bars
//   $('.column-filter')
//     .unbind('keyup')
//     .bind('keyup', function() {
//       let searchTerm = $(this).val();
//       let columnIndex = $(this).data('column-index');
//       clearTimeout(columnSearchWait[columnIndex]);
//       columnSearchWait[columnIndex] = setTimeout(function() {
//         if (columnIndex === 1) { // Title column
//           table.columns(columnIndex).search(searchTerm, true, false).draw();
//         } else if (columnIndex === 2) { // Authors column
//           table.columns(columnIndex).search(searchTerm, true, false).draw();
//         } else if (columnIndex === 4) { // Journal column
//           table.columns(columnIndex).search(searchTerm, true, false).draw();
//         }
//       }, searchDelayInterval);
//     });
//});

/* ########## */