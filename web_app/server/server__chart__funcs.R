##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Plot a warning

plot_warning = function() {

   plot(NULL, xlim = c(0, 1), ylim = c(0, 1), xlab = "", ylab = "",
        axes = FALSE, frame.plot = FALSE)
   text(x = 0.45, y = 0.5, cex = 2.0,
        label = "Plotting not possible - adjust filter settings.")
}

######### Build data frame for MeSH terms and keywords

build_df_meshterms = function(column) {

   vec_meshterms = strsplit(paste(column, collapse = ", "), split = ", ")  # build a single string and split into vector
   df_meshterms = data.frame(meshterms = unlist(vec_meshterms, use.names = FALSE)) %>%  # split mesh terms
      dplyr::filter(!meshterms %in% stringr::str_c(meshterms, "s")) %>%  # remove plural duplicates, e.g., 'humans' when 'human' is already present
      dplyr::count(meshterms) %>%  # count number of authors
      dplyr::rename(word = meshterms, freq = n) %>%
      dplyr::arrange(desc(freq))

   return(df_meshterms)
}

######### Build data frame for authors

build_df_authors = function(column) {

   vec_authors = strsplit(paste(column, collapse = ", "), split = ", ")  # build a single string and split into vector
   df_authors = data.frame(authors = unlist(vec_authors, use.names = FALSE)) %>%  # split authors
      dplyr::count(authors) %>%  # count number of authors
      dplyr::rename(word = authors, freq = n) %>%
      dplyr::arrange(desc(freq))

   return(df_authors)
}

######### Build data frame for journal names

build_df_journals = function(column) {

   df_journal_names = data.frame(journal_names = column) %>%
      dplyr::mutate(journal_names = gsub(":.*", "", journal_names)) %>%  # remove parts after ":"
      dplyr::mutate(journal_names = gsub("\\(.*", "", journal_names)) %>% # remove parts within parentheses
      dplyr::count(journal_names) %>%  # count number of authors
      dplyr::rename(word = journal_names, freq = n) %>%
      dplyr::arrange(desc(freq))

   return(df_journal_names)
}

########## Build data frame for paper titles

build_df_titles = function(column) {

   str_titles = paste(column, collapse = " ")  # build a single string
   str_titles = gsub("[[:punct:]]", "", str_titles)  # remove punctuation
   str_titles = tolower(str_titles)  # convert to lowercase
   vec_words = unlist(strsplit(str_titles, " "))  # split into words

   stop_words =
      c("a", "an", "the", "of", "in", "on", "for", "with", "to", "by", "at", "from",
        "using", "based", "through", "and", "or", "is", "are", "was", "were", "has",
        "have", "having", "been", "be", "can", "could", "may", "might", "shall", "should",
        "will", "would", "do", "does", "did", "doing", "about", "over", "under", "above",
        "below", "between", "among", "into", "within", "onto", "against", "towards", "during",
        "per", "among", "when", "where", "who", "which", "whom", "that", "this", "these",
        "those", "their", "our", "my", "your", "his", "her", "its", "their", "our", "all",
        "any", "some", "many", "several", "few", "most", "more", "less", "much", "fewer", "further",
        "least", "other", "another", "new", "old", "first", "second", "last", "high", "low", "big",
        "small", "large", "long", "short", "important", "essential", "major", "minor", "primary",
        "secondary", "significant", "relevant", "key", "general", "specific", "particular",
        "different", "similar", "common", "uncommon", "unique", "initial", "final", "early",
        "late", "recent", "next", "previous", "main", "important", "critical", "crucial",
        "major", "minor", "possible", "potential", "probable", "positive", "negative",
        "effective", "efficient", "successful", "unsuccessful", "promising", "preliminary",
        "present", "current", "previous", "published", "unpublished", "experimental",
        "theoretical", "practical", "clinical", "statistical", "computational",
        "analytical", "numerical", "qualitative", "quantitative", "empirical", "simulated",
        "synthetic", "real", "virtual", "novel", "traditional", "advanced", "state-of-the-art",
        "recent", "well-known", "known", "unknown", "future", "ongoing", "proposed", "developed",
        "designed", "implemented", "evaluated", "compared", "analyzed", "investigated",
        "studied", "reviewed", "discussed", "summarized", "explored", "demonstrated",
        "verified", "validated", "proven", "identified", "detected", "diagnosed", "measured",
        "characterized", "quantified", "predicted", "modeled", "optimized", "improved",
        "enhanced", "suggested", "recommended", "discussed", "addressed", "considered",
        "evaluated", "explained", "clarified", "elucidated", "defined", "introduced", "examined",
        "established", "compared", "contrasted", "illustrated", "concluded", "reported",
        "showed", "determined", "achieved", "obtained", "demonstrated", "found", "t", "as",
        "after")

   vec_words = vec_words[!vec_words %in% stop_words]  # remove stop words
   vec_words = vec_words[!grepl("[0-9]", vec_words)]  # remove numbers

   df_titles = data.frame(titles = unlist(vec_words, use.names = FALSE)) %>%  # split authors
      dplyr::filter(!titles %in% stringr::str_c(titles, "s")) %>%  # remove plural duplicates, e.g., 'cells' when 'cell' is already present
      dplyr::count(titles) %>%  # count number of authors
      dplyr::rename(word = titles, freq = n) %>%
      dplyr::arrange(desc(freq))

   return(df_titles)
}

########## Build vector with n highest ranked publishing journals

build_vec_highest_ranked_journals = function(df, max_num_labels_heatmap) {

   journals = df$word[1:max_num_labels_heatmap]
   journals = journals[!is.na(journals)]  # remove NA

   return(journals)
}

########## Plot value box

plot_valuebox = function(number, title, color, symbol, is_table_empty) {

   if (is_table_empty == TRUE) {
      number = 0
   }
   shinydashboard::renderValueBox({
      shinydashboard::valueBox(
         formatC(number, format = "d", big.mark = ","),
         title,
         color = color,
         icon = tags$i(class = symbol,
                       style = "font-size: 45px; color: white; opacity: 0.4; padding-right: 30px;")
      )
   })
}

########## Plot histogram

plot_barplot = function(freq, x_ticks, x_label, add_margin_bottom) {

   label_font = 2  # 1..normal, 2..bold, 3..italic, 4..bold italic
   label_size = 1.2
   par_mai = par()$mai
   par(mai = c(par_mai[1] + add_margin_bottom, par_mai[2], par_mai[3], par_mai[4]))
   barplot(height = freq, xlab = x_label, ylab = "Frequency",
           font.lab = label_font, cex.lab = label_size, las = 1,
           width = 0.90, space = 0.11, col = "#007bc2", border = "white", xaxt = "n")  # "n" do not plot x-axis
   seq_x_ticks = seq(from = 1, to = length(x_ticks), by = 1)
   shift_xlabel_x = -0.4
   shift_xlabel_y = -0.2
   rotation_degree = 60  # degree
   adj = 1.0  # alignment: 0..left, 0.5..center, 1..right
   text(x = seq_x_ticks + shift_xlabel_x, y = par("usr")[3] + shift_xlabel_y,
        labels = x_ticks, srt = rotation_degree, adj = adj, xpd = TRUE)  # expand labels beyond plot region
}

########## Plot word cloud

plot_wordcloud = function(df, max_num_entries, is_table_empty, font_size_fac = 0.8) {

   if (is_table_empty == TRUE) {
      df = data.frame(word = c("Plotting is not possible - adjust filter settings."), 
                      freq = c(10))
   }
   wordcloud2::renderWordcloud2({
      hover_js = ""
      df %>%
         dplyr::slice_head(n = max_num_entries) %>%
         dplyr::mutate(freq = freq / max(freq)) %>%  # norm all count values
         wordcloud2::wordcloud2(., size = font_size_fac,   # with a larger font size, the most frequent words are left out
                                hoverFunction = "function(item, dimension, event) {}")  # disable hover functionality
   })
}

########## Plot histogram instead of a word cloud

plot_barplot_wordcloud = function(df, max_num_labels_barplot, add_margin_bottom, is_table_empty) {

   if (is_table_empty == TRUE) {
      shiny::renderPlot({ plot_warning() })
   } else {
      shiny::renderPlot({
         if (nrow(df) > max_num_labels_barplot) { df = df[1:max_num_labels_barplot, ] }
         plot_barplot(df$freq, df$word, "", add_margin_bottom)
      })
   }
}

########## Create the matrix for the heat map plot over years for a filter

build_matrix_filter = function(table, abbrev_filter_in_table, df_filter,
                               min_num_labels_every_2nd_year, min_num_labels_every_5th_year) {

   df = table %>%
      dplyr::select(Year, contains(abbrev_filter_in_table)) %>%  # see table, e.g., "Te" for technologies
      dplyr::mutate_all(~as.numeric(.))  # convert logical values to numeric

   min_year = min(df$Year)
   max_year = max(df$Year)
   span_year = max_year - min_year + 1
   step_size = ifelse(span_year >= min_num_labels_every_5th_year, 5,  # step sizes are 1, 2 or 5
                      ifelse(span_year >= min_num_labels_every_2nd_year, 2, 1))
   breaks = seq(min_year, max_year, by = step_size)
   if(max(breaks) != max_year) { breaks = c(breaks, max_year) }

   suppressMessages({
      if (step_size == 1) {
         df = df %>%  # count entries
            dplyr::group_by(Year) %>%
            dplyr::summarise(across(everything(), list(sum))) %>%  # summarize for years
            tidyr::complete(., Year) %>%  # complete missing intervals
            replace(is.na(.), 0) %>%
            as.data.frame(.)
         rownames(df) = sprintf("%d", breaks[1:length(breaks)])
         colnames(df) = c("Year", df_filter$labels)
         df = df %>%
            dplyr::select(-Year)
      } else {
         df$Interval = cut(df$Year, breaks = breaks, include.lowest = TRUE, right = FALSE)
         df = df %>%
            dplyr::group_by(Interval) %>%
            dplyr::summarize(across(everything(), sum)) %>%  # summarize for year intervals
            tidyr::complete(., Interval) %>%  # complete missing intervals
            replace(is.na(.), 0) %>%
            as.data.frame(.)
         rownames(df) = sprintf("%d - %d", breaks[1:length(breaks)-1], breaks[2:length(breaks)])
         colnames(df) = c("Interval", "Year", df_filter$labels)
         df = df %>%
            dplyr::select(-Interval, -Year)
      }
   })

   return(t(as.matrix(df)))  # transpose matrix
}

########## Create the matrix for the heat map plot over years for a table column

build_matrix_column = function(table, column_name, column_items,
                               min_num_labels_every_2nd_year, min_num_labels_every_5th_year) {

   df = table %>%
      dplyr::select(Year, column_name) %>%
      dplyr::filter(!!sym(column_name) %in% column_items)

   min_year = min(df$Year)
   max_year = max(df$Year)
   span_year = max_year - min_year + 1
   step_size = ifelse(span_year >= min_num_labels_every_5th_year, 5,  # step sizes are 1, 2 or 5
                      ifelse(span_year >= min_num_labels_every_2nd_year, 2, 1))
   breaks = seq(min_year, max_year, by = step_size)
   if(max(breaks) != max_year) { breaks = c(breaks, max_year) }

   suppressMessages({
      if (step_size == 1) {
         col_names = sprintf("%d", breaks[1:length(breaks)])
         pivot_table = df %>%
            dplyr::group_by(!!sym(column_name), Year) %>%
            dplyr::summarise(Count = n()) %>%
            tidyr::pivot_wider(names_from = Year, values_from = Count,
                               values_fill = list(Count = 0), names_expand = TRUE)
      } else {
         col_names = sprintf("%d - %d", breaks[1:length(breaks)-1], breaks[2:length(breaks)])
         df$Interval = cut(df$Year, breaks = breaks, include.lowest = TRUE, right = FALSE)
         pivot_table = df %>%
            dplyr::group_by(!!sym(column_name), Interval) %>%
            dplyr::summarise(Count = n()) %>%
            tidyr::pivot_wider(names_from = Interval, values_from = Count,
                               values_fill = 0, names_expand = TRUE)
      }
   })

   matrix = as.matrix(pivot_table[, -1])
   rownames(matrix) = pivot_table[[column_name]]
   colnames(matrix) = col_names

   return(matrix)
}

########## Plot heat map

plot_heatmap = function (matrix, scale, is_table_empty) {

   if ((is_table_empty == TRUE) || (ncol(matrix) < 2)) {  # at least 2 columns are necessary for heatmap plot
      shiny::renderPlot({ plot_warning() })
   } else {
      if (scale == "row") {
         matrix = t(apply(matrix, 1, function(row) row / max(row)))  # row-wise maximum value
      } else {
         matrix = matrix / max(matrix)  # absolute maximum value
      }
      shiny::renderPlot({
         heatmap(matrix, Rowv = NA, Colv = NA, col = colormap, scale = "none",  # scale: "none"..use absolute vales
                 cexRow = 1.2, cexCol = 1.2, margins = c(7.0, 8.0))  # cexRow, cexCol..font sizes ticks, margins..for column and row names
      })
   }
}

##########
