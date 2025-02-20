#' `shinyTimer` widget
#'
#' @param inputId The input id.
#' @param label The label to display above the countdown.
#' @param minutes An integer, the starting time in minutes for the countdown.
#' @param seconds An integer, the starting time in seconds for the countdown.
#' @param type The type of the countdown timer display ("simple", "mm:ss", "hh:mm:ss", "mm:ss.cs").
#' @param ... Any additional parameters you want to pass to the placeholder for the timer (`htmltools::tags$div`).
#'
#' @return A shiny UI component for the countdown timer.
#' @export
shinyTimer <- function(inputId, label = NULL, minutes = 0, seconds = 0, type = "simple", ...) {
  shiny::addResourcePath("shinyTimer", system.file("www", package = "shinyTimer"))
  
  if (!type %in% c("simple", "mm:ss", "hh:mm:ss", "mm:ss.cs")) {
    stop("Invalid type. Choose 'simple', 'mm:ss', 'hh:mm:ss', or 'mm:ss.cs'.")
  }
  
  totalseconds <- minutes * 60 + seconds
  
  initial_display <- switch(
    type,
    "simple" = as.character(totalseconds),
    "mm:ss" = sprintf("%02d:%02d", floor(totalseconds / 60), totalseconds %% 60),
    "hh:mm:ss" = sprintf("%02d:%02d:%02d", floor(totalseconds / 3600), floor((totalseconds %% 3600) / 60), totalseconds %% 60),
    "mm:ss.cs" = sprintf("%02d:%02d.%02d", floor(totalseconds / 60), floor(totalseconds %% 60), 0)
  )
  
  shiny::tagList(
    if (!is.null(label)) htmltools::tags$label(label, `for` = inputId),
    htmltools::tags$div(
      id = inputId,
      class = "shiny-timer",
      `data-start-time` = totalseconds,
      `data-type` = type,
      initial_display,
      ...
    ),
    htmltools::tags$script(src = "shinyTimer/timer.js")
  )
}

#' Update `shinyTimer` widget
#'
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#' @param minutes The new starting time in minutes for the countdown.
#' @param seconds The new starting time in seconds for the countdown.
#' @param type The new type of the countdown timer display ("simple", "mm:ss", "hh:mm:ss", "mm:ss.cs").
#' @param label The new label to be displayed above the countdown timer.
#'
#' @export
updateShinyTimer <- function(session, inputId, minutes = NULL, seconds = NULL, type = NULL, label = NULL) {
  message <- list(inputId = inputId)
  
  if (!is.null(minutes) && !is.null(seconds)) {
    message$start <- (minutes * 60) + seconds
  } else if (!is.null(minutes)) {
    message$start <- minutes * 60
  } else if (!is.null(seconds)) {
    message$start <- seconds
  }
  
  if (!is.null(type)) message$type <- type
  if (!is.null(label)) message$label <- label
  
  session$sendCustomMessage('updateShinyTimer', message)
}

#' Set `shinyTimer` in motion: count down
#'
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#'
#' @export
countDown <- function(session, inputId) {
  session$sendCustomMessage('countDown', list(inputId = inputId))
}

#' Set `shinyTimer` in motion: count up
#'
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#'
#' @export
countUp <- function(session, inputId) {
  session$sendCustomMessage('countUp', list(inputId = inputId))
}

#' Stop `shinyTimer`
#'
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#'
#' @export
stopTimer <- function(session, inputId) {
  session$sendCustomMessage('stopTimer', list(inputId = inputId))
}
