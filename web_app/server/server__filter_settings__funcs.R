##################################
# Michael Gruber, 24.06.2021     #
# Medizinische Universitaet Graz #
# Lehrstuhl fuer Histologie      #
##################################
#


######### Template to update select all / deselect all

select_all_none_template = function(session_, chkbox_id_, choices_, select_) {

   if (select_ == "all") {
      selected_ = seq(1, length(choices_))
   } else if (select_ == "none") {
      selected_ = list()
   }

   update = shiny::updateCheckboxGroupInput(session = session_,
                                            inputId = chkbox_id_,
                                            choiceNames = choices_,
                                            choiceValues = seq(1, length(choices_)),
                                            selected = selected_)
   return(update)
}

##########