##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## R string in javascript

quote = function(text) {
   return (paste("'", text, "'", sep = ""))
}

########## Determine the position of a column in the filtered table

position_column = function(table, column_name) {
   position =
      grep(column_name, colnames(table)) %>%
      as.numeric(.)
   return(position)
}

########## Columns to hide

table_columns_to_hide =
   shiny::reactive({
      all_names_table[!(all_names_table %in% input$chkbox_table_columns_show)]
   })

########## Create a logic regex string from the global search string

global_search_string_to_regex_string = function(search_str) {
   clean_search_str = gsub('[^A-Za-z0-9 "]', "", search_str)  # remove all characters except alphanumeric, spaces and double quotes
   parts = strsplit(trimws(clean_search_str), "\\s+")[[1]]  # trim string and split at spaces

   num_open_quotes = 0  # check if double quotes are used correctly
   for (part in parts) {
      is_operator = any(grepl("(AND|OR|NOT)", part))
      if ((num_open_quotes > 0) && is_operator) { return("") }  # ERROR: operator with open double quotes -> regex_str = ""
      chars = strsplit(part, "")[[1]]
      for (char in chars) {
         if (char == '"') {
            num_open_quotes = ifelse(num_open_quotes == 0, 1, 0)
            if ((num_open_quotes > 0) && is_operator) { return("") }  # ERROR: operator with open double quotes -> regex_str = ""
         }
      }
      if ((num_open_quotes > 0) && is_operator) { return("") }  # ERROR: operator with open double quotes -> regex_str = ""
   }
   if (num_open_quotes == 0) {
      parts = gsub('"', '\\\\b', parts)  # replace double quotes with \\b
   } else {
      return("")  # ERROR: operator with open double quotes -> regex_str = ""
   }
   if (parts[[1]] == "NOT") {
      regex_str = "^(?!.*("
      parts = parts[-1]  # remove first element
   } else {
      regex_str = "^(?=.*("
   }

   last_part = "operator"
   for (part in parts) {
      if ((part %in% c("AND", "OR", "NOT")) && (last_part == "operator")) { return("") }  # ERROR: two operators after each other -> regex_str = ""
      if (part == "AND") {
         regex_str = paste0(regex_str, "))(?=.*(")  # "term1 AND term2" => (?=.*term1)(?=.*term2)
      } else if (part == "OR") {
         regex_str = paste0(regex_str, "|")  # "term1 OR term2" => (?=.*(term1|term2))
      } else if (part == "NOT") {
         regex_str = paste0(regex_str, "))(?!.*(")  # "term1 NOT term2" => (?=.*term1)(?!.*term2)
      } else {
         if (last_part == "term") {
            regex_str = paste0(regex_str, "[[:space:]]", part)  # "term1 term2" => (?=.*term1[[:space:]]term2)
         } else {
            regex_str = paste0(regex_str, part)
         }
      }
      last_part = ifelse(part %in% c("AND", "OR", "NOT"), "operator", "term")  # was last part operator or term
   }
   regex_str = paste0(regex_str, "))")
   regex_str = gsub("\\(\\?(\\=|\\!)\\.\\*\\(\\)\\)", "", regex_str)  # remove empty (?=.*()) or (?!.*()) regex parts
   regex_str = gsub("\\|\\)", ")", regex_str)  # remove empty (?=.*(term|)) regex parts
   #cat("search_str:", search_str, ", regex_str:", regex_str, "\n")
   return(regex_str)
}

########## Perform the global logical regex search

table_filtered_search = shiny::reactive({
   if (is.null(input$glo_search_str_debounced) || (input$glo_search_str_debounced == "")) {
      table_rows_show = rep(TRUE, nrow(table_filtered()))  # show all table rows
   } else {
      glo_search_str = trimws(input$glo_search_str_debounced)
      glo_regex_str = global_search_string_to_regex_string(glo_search_str)
      table_rows_show = grepl(glo_regex_str, do.call(paste, table_filtered()[search_columns]), perl = TRUE, ignore.case = TRUE)  # caseInsensitive regex search
   }
   table_filtered()[table_rows_show, ]
})

##########