#' Countdown Timer UI Component
#'
#' @param inputId The input id.
#' @param label The label to display above the countdown.
#' @param start An integer, the starting time in `secs` for the countdown.
#' @param format The format of the countdown timer display (either "simple" or
#'   "clock").
#' @param ... Any additional parameters you want to pass to the placeholder for
#'   the timer (`htmltools::tags$div()`).
#'
#' @return A shiny UI component for the countdown timer.
#' @export
shinyTimer <- function(inputId, label = NULL, start, format = "simple", ...) {
  addResourcePath("shinyTimer", system.file("www", package = "shinyTimer"))

  if (!format %in% c("simple", "clock")) {
    stop("Invalid format. Choose either 'simple' or 'clock'.")
  }
  
  shiny::tagList(
    if (!is.null(label)) tags$label(label, `for` = inputId),
    htmltools::tags$div(
      id = inputId,
      class = "countdown-timer",
      `data-start-time` = start,
      `data-format` = format,
      formatTime(start, format),
      ...
    ),
    htmltools::tags$script(src = "shinyTimer/timer.js")
  )
}

#' Countdown Timer Server Logic
#'
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#'
#' @export
countDown <- function(session, inputId) {
  session$sendCustomMessage('startCountdown', list(inputId = inputId))
}

#' Helper
formatTime <- function(time, format) {
  if (format == "clock") {
    minutes <- floor(time / 60)
    seconds <- time %% 60
    return(sprintf("%02d:%02d", minutes, seconds))
  } else {
    return(as.character(time))
  }
}