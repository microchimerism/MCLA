##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Settings

min_num_labels_every_2nd_year = 11  # in bar plot show year label every 2nd entry
min_num_labels_every_5th_year = 26  # in bar plot show year label every 5th entry

max_num_wordcloud_entries = 70
max_num_labels_barplot = 30
max_num_labels_heatmap = 20

colormap = c("#F5F5F5", rev(heat.colors(12)))

########## Create a dummy plot to display the color bar

# library(fields)
# plot(1, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1))
# image.plot(legend.only = TRUE, col = colormap, zlim = c(0, 1), horizontal = TRUE, legend.shrink = 0.7)

########## Source functions

source("server/server__chart__funcs.R", local = TRUE)

########## Flip box titles

shiny::observe({

   # Update the titles of the flip boxes
   output$title_flipBox_top_ranked_journals = shiny::renderUI({
      ifelse(input$flipBox_top_ranked_journals,
             paste("Heat map of ", max_num_labels_heatmap, " top ranked Journals (absolute values)", sep = ""),
             paste("Heat map of ", max_num_labels_heatmap, " top ranked Journals (row-wise normalized values)", sep = ""))
   })
   output$title_flipBox_techniques = shiny::renderUI({
      ifelse(input$flipBox_techniques,
             "Heat map Techniques (absolute values)",
             "Heat map Techniques (row-wise normalized values)")
   })
   output$title_flipBox_authors = shiny::renderUI({
      ifelse(input$flipBox_authors,
             "Word cloud Authors",
             paste("Bar plot of first ", max_num_labels_barplot, " Authors", sep = ""))
   })
   output$title_flipBox_journals = shiny::renderUI({
      ifelse(input$flipBox_journals,
             "Word cloud of Publishing Journals",
             paste("Bar plot of first ", max_num_labels_barplot, " Publishing Journals", sep = ""))
   })
   output$title_flipBox_meshterms = shiny::renderUI({
      ifelse(input$flipBox_meshterms,
             "Word cloud of associated MeSH Terms and Keywords",
             paste("Bar plot of first ", max_num_labels_barplot, " MeSH Terms and Keywords", sep = ""))
   })
   output$title_flipBox_titles = shiny::renderUI({
      ifelse(input$flipBox_titles,
             "Word cloud of essential Title Words",
             paste("Bar plot of first ", max_num_labels_barplot, " essential Title Words", sep = ""))
   })
})

########## Chart visualizations

shiny::observe({

   # Only if tabulator network is selected
   if (input$tabs_navbar == "tab_chart") {

      # Check if filtered table is empty
      is_table_empty = nrow(table_filtered_search()) == 0

      #### Calculate necessary information for charts

      if (is_table_empty == FALSE) {
         num_articles = sum(table_filtered_search()$Type == "Article")
         num_reviews = sum(table_filtered_search()$Type == "Review")
         df_authors = build_df_authors(table_filtered_search()$Authors)
         num_authors = nrow(df_authors)
         df_meshterms = build_df_meshterms(table_filtered_search()$MeSH_Keywords)
         df_titles = build_df_titles(table_filtered_search()$Title)
         df_journals = build_df_journals(table_filtered_search()$Journal)
         mat_techniques = build_matrix_filter(table_filtered_search(), "Te", filters_techniques,
                                              min_num_labels_every_2nd_year, min_num_labels_every_5th_year)
         journal_names = build_vec_highest_ranked_journals(df_journals, max_num_labels_heatmap)  # highest n ranked publishing journals
         mat_top_journals = build_matrix_column(table_filtered_search(), "Journal", journal_names,
                                                min_num_labels_every_2nd_year, min_num_labels_every_5th_year)
      }

      #### Plot value boxes

      # Value box for the number of published articles
      output$value_box_number_articles =
         plot_valuebox(num_articles, "Number of Articles", "blue", "fa fa-pencil", is_table_empty)
      # Value box for the number of published articles
      output$value_box_number_reviews =
         plot_valuebox(num_reviews, "Number of Reviews", "orange", "fa fa-magnifying-glass", is_table_empty)
      # Value box for the number of published articles
      output$value_box_number_authors =
         plot_valuebox(num_authors, "Number of Authors", "purple", "fa fa-user", is_table_empty)

      #### Chart plots

      # Plot a histogram of publications per year
      output$plot_barplot_publications =
         if ((is_table_empty == TRUE) || (length(table_filtered_search()$Year) == 0)) {
            shiny::renderPlot({ plot_warning() })
         } else {
            shiny::renderPlot({
               years = table_filtered_search()$Year
               min_years = min(years)
               max_years =  max(years)
               seq_years = seq(min_years, max_years, by = 1)
               x_ticks = vector()
               for (year in seq_years) {
                  if ((length(seq_years) >= min_num_labels_every_5th_year &&
                       (year %% 5) != 0) ||
                      (length(seq_years) < min_num_labels_every_5th_year &&
                       length(seq_years) >= min_num_labels_every_2nd_year &&
                       (year %% 2) != 0)) {
                     x_ticks[length(x_ticks) + 1] = ""
                  } else {
                     x_ticks[length(x_ticks) + 1] = sprintf("%d", year)
                  }
               }
               breaks = seq(min_years, max_years + 1, by = 1) - 0.5
               hist_years = hist(years, breaks = breaks, plot = FALSE)
               plot_barplot(hist_years$counts, x_ticks, "Year", 0.0)
            })
         }

      # Plot a heat map of the techniques over time with scaling none
      output$plot_heatmap_top_ranked_journals_front =
         plot_heatmap(mat_top_journals, "none", is_table_empty)
      # Plot a heat map of the techniques over time with scaling row
      output$plot_heatmap_top_ranked_journals_back =
         plot_heatmap(mat_top_journals, "row", is_table_empty)

      # Plot a heat map of the techniques over time with scaling none
      output$plot_heatmap_techniques_front =
         plot_heatmap(mat_techniques, "none", is_table_empty)
      # Plot a heat map of the techniques over time with scaling row
      output$plot_heatmap_techniques_back =
         plot_heatmap(mat_techniques, "row", is_table_empty)

      # Plot a heat map of the journals over time with scaling none
      output$plot_heatmap_techniques_front =
         plot_heatmap(mat_techniques, "none", is_table_empty)
      # Plot a heat map of the techniques over time with scaling row
      output$plot_heatmap_techniques_back =
         plot_heatmap(mat_techniques, "row", is_table_empty)

      # Plot a histogram of the authors
      output$plot_barplot_authors =
         plot_barplot_wordcloud(df_authors, max_num_labels_barplot, 0.0, is_table_empty)
      # Plot a word cloud of the authors
      output$plot_wordcloud_authors =
         plot_wordcloud(df_authors, max_num_wordcloud_entries, is_table_empty, font_size_fac = 0.5)

      # Plot a histogram of the journal names
      output$plot_barplot_journals =
         plot_barplot_wordcloud(df_journals, max_num_labels_barplot, 2.0, is_table_empty)
      # Plot a word cloud of the journal names
      output$plot_wordcloud_journals =
         plot_wordcloud(df_journals, max_num_wordcloud_entries, is_table_empty, font_size_fac = 0.6)

      # Plot a histogram of the MeSH terms and keywords
      output$plot_barplot_meshterms =
         plot_barplot_wordcloud(df_meshterms, max_num_labels_barplot, 1.0, is_table_empty)
      # Plot a word cloud of the MeSH terms and keywords
      output$plot_wordcloud_meshterms =
         plot_wordcloud(df_meshterms, max_num_wordcloud_entries, is_table_empty)

      # Plot a histogram of the titles
      output$plot_barplot_titles =
         plot_barplot_wordcloud(df_titles, max_num_labels_barplot, 0.0, is_table_empty)
      # Plot a word cloud of the titles
      output$plot_wordcloud_titles =
         plot_wordcloud(df_titles, max_num_wordcloud_entries, is_table_empty)
   }
})

##########