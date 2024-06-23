##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Tabulator filter settings

tab_item_chart =
   shinydashboard::tabItem(

      # Tabulator id
      tabName = "tab_chart",

      # 1st fluid row: value boxes
      shiny::fluidRow(
         shinydashboard::valueBoxOutput(outputId = "value_box_number_articles",
                                        width = 4),
         shinydashboard::valueBoxOutput(outputId = "value_box_number_reviews",
                                        width = 4),
         shinydashboard::valueBoxOutput(outputId = "value_box_number_authors",
                                        width = 4)
      ),

      # 2nd fluid row: histogram and heat map
      shiny::fluidRow(
         shinydashboardPlus::box(
            title = "Number of Publications per Year",
            status = "info",
            width = 6,  # all widths should sum up to 12
            height = "100%",
            boxToolSize = "xs",
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,

            # Show histogram with busy icon
            shinycssloaders::withSpinner(
              shiny::plotOutput(outputId = "plot_barplot_publications")
            )
         ),
         shinydashboardPlus::box(
            title = shiny::uiOutput("title_flipBox_top_ranked_journals"),
            status = "success",
            width = 6,  # all widths should sum up to 12
            height = "100%",
            boxToolSize = "xs",
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,

            # Show heat maps as flip boxes with busy icon
            shinydashboardPlus::flipBox(
               id = "flipBox_top_ranked_journals",
               trigger = "click",
               width = 12,
               front =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_heatmap_top_ranked_journals_front")
                  ),
               back =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_heatmap_top_ranked_journals_back")
                  )
            )
         )
      ),

      # 3rd fluid row: heat map, word clouds and histograms
      shiny::fluidRow(
         shinydashboardPlus::box(
            title = shiny::uiOutput("title_flipBox_techniques"),
            status = "warning",
            width = 6,  # all widths should sum up to 12
            height = "100%",
            boxToolSize = "xs",
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,
            
            # Show heat maps as flip boxes with busy icon
            shinydashboardPlus::flipBox(
               id = "flipBox_techniques",
               trigger = "click",
               width = 12,
               front =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_heatmap_techniques_front")
                  ),
               back =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_heatmap_techniques_back")
                  )
            )
         ),
         shinydashboardPlus::box(
            title = shiny::uiOutput("title_flipBox_authors"),
            status = "danger",
            width = 6,  # all widths should sum up to 12
            height = "100%",
            boxToolSize = "xs",
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,

            # Show word cloud and histogram as flip boxes with busy icon
            shinydashboardPlus::flipBox(
               id = "flipBox_authors",
               trigger = "click",
               width = 12,
               front =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_barplot_authors")
                  ),
               back =
                  shinycssloaders::withSpinner(
                     wordcloud2::wordcloud2Output(outputId = "plot_wordcloud_authors")
                  )
            )
         )
      ),

      # 4th fluid row: word clouds and histograms
      shiny::fluidRow(
         shinydashboardPlus::box(
            title = shiny::uiOutput("title_flipBox_journals"),
            status = "success",
            width = 6,  # all widths should sum up to 12
            height = "100%",
            boxToolSize = "xs",
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,
            
            # Show word cloud and histogram as flip boxes with busy icon
            shinydashboardPlus::flipBox(
               id = "flipBox_journals",
               trigger = "click",
               width = 12,
               front =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_barplot_journals")
                  ),
               back =
                  shinycssloaders::withSpinner(
                     wordcloud2::wordcloud2Output(outputId = "plot_wordcloud_journals")
                  )
            )
         ),
         shinydashboardPlus::box(
            title = shiny::uiOutput("title_flipBox_meshterms"),
            status = "info",
            width = 6,  # all widths should sum up to 12
            height = "100%",
            boxToolSize = "xs",
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,

            # Show word cloud and histogram as flip boxes with busy icon
            shinydashboardPlus::flipBox(
               id = "flipBox_meshterms",
               trigger = "click",
               width = 12,
               front =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_barplot_meshterms")
                  ),
               back =
                  shinycssloaders::withSpinner(
                     wordcloud2::wordcloud2Output(outputId = "plot_wordcloud_meshterms")
                  )
            )
         )
      ),

      # 5th fluid row: word clouds and histograms
      shiny::fluidRow(
         shinydashboardPlus::box(
            title = shiny::uiOutput("title_flipBox_titles"),
            status = "danger",
            width = 6,  # all widths should sum up to 12
            height = "100%",
            boxToolSize = "xs",
            solidHeader = TRUE,
            closable = FALSE,
            collapsible = FALSE,
            
            # Show word cloud and histogram as flip boxes with busy icon
            shinydashboardPlus::flipBox(
               id = "flipBox_titles",
               trigger = "click",
               width = 12,
               front =
                  shinycssloaders::withSpinner(
                     shiny::plotOutput("plot_barplot_titles")
                  ),
               back =
                  shinycssloaders::withSpinner(
                     wordcloud2::wordcloud2Output(outputId = "plot_wordcloud_titles")
                  )
            )
         )
      )
   )

##########