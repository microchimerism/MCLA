##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Footer

footer =
   shinydashboardPlus::dashboardFooter(

      # Text: "Copyright 2023 © microchimerism.info. All Rights Reserved."
      left =
         paste("Copyright",
            c(format(Sys.Date(), "%Y")),
            stringi::stri_unescape_unicode(paste0("\\u","00A9")),
            "microchimerism.info. All Rights Reserved."
         )
   )

##########