#' Countdown Timer UI Component
#'
#' @param inputId The input id.
#' @param label The label to display above the countdown.
#' @param startTime The starting time for the countdown.
#'
#' @return A shiny UI component for the countdown timer.
#' @export
shinyTimer <- function(inputId, label = NULL, startTime = 10) {
  addResourcePath('shinyTimer', system.file('www', package = 'shinyTimer'))
  
  tagList(
    if (!is.null(label)) tags$label(label, `for` = inputId),
    htmltools::tags$div(id = inputId, class = "countdown-timer", startTime),
    htmltools::tags$script(src = "shinyTimer/timer.js")
  )
}

#' Countdown Timer Server Logic
#'
#' @param input The input object from the shiny server function.
#' @param output The output object from the shiny server function.
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#' @param startTime The starting time for the countdown.
#' @export
runTimer <- function(input, output, session, inputId, startTime) {
  session$sendCustomMessage(
    'startCountdown', 
    list(startTime = startTime, timerId = inputId)
  )
}
