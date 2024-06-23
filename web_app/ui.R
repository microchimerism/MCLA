##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


########## Debug

# observe({ print( table_filtered() ) })  # print reactive value
# observe({ print( input$chkbox_other_terms ) })

########## Demo

# shinydashboardPlusGallery()

########## Source UI parts

source("ui/ui__body.R", local = TRUE)
source("ui/ui__footer.R", local = TRUE)
source("ui/ui__header.R", local = TRUE)
source("ui/ui__sidebar.R", local = TRUE)

########################
########## UI ##########
########################

ui =
   shinydashboardPlus::dashboardPage(

      # Activate MaterialDesign+AdminLTE
      md = FALSE,

      # Skin color (theme)
      skin = "blue",

      # AdminLTE options as list
      #options = list(sidebarExpandOnHover = TRUE),

      # Browser title and favicon
      title =
         shiny::tags$head(
            shiny::HTML("<title>MC Literature Atlas</title> <link rel='icon' type='icon' href='images/logo/favicon.ico'>")
         ),

      # Assemble the program structure
      header,
      sidebar,  # left navbar
      controlbar = NULL,  # disable right navbar
      body,
      footer
   )

##########
