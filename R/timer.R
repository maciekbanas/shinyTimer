#' Countdown Timer UI Component
#'
#' @param inputId The input id.
#' @param label The label to display above the countdown.
#' @param minutes An integer, the starting time in minutes for the countdown.
#' @param seconds An integer, the starting time in seconds for the countdown.
#' @param format The format of the countdown timer display (either "simple" or "clock").
#' @param ... Any additional parameters you want to pass to the placeholder for the timer (`htmltools::tags$div`).
#'
#' @return A shiny UI component for the countdown timer.
#' @export
shinyTimer <- function(inputId, label = NULL, minutes = 0, seconds = 0, format = "simple", ...) {
  addResourcePath("shinyTimer", system.file("www", package = "shinyTimer"))
  
  if (!format %in% c("simple", "clock")) {
    stop("Invalid format. Choose either 'simple' or 'clock'.")
  }
  
  totalseconds <- (minutes * 60) + seconds
  
  formatTime <- function(time, format) {
    if (format == "clock") {
      minutes <- floor(time / 60)
      seconds <- time %% 60
      return(sprintf("%02d:%02d", minutes, seconds))
    } else {
      return(as.character(time))
    }
  }
  
  shiny::tagList(
    if (!is.null(label)) htmltools::tags$label(label, `for` = inputId),
    htmltools::tags$div(
      id = inputId,
      class = "shiny-timer",
      `data-start-time` = totalseconds,
      `data-format` = format,
      formatTime(totalseconds, format),
      ...
    ),
    htmltools::tags$script(src = "shinyTimer/timer.js")
  )
}

#' Update Countdown Timer
#'
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#' @param minutes The new starting time in minutes for the countdown.
#' @param seconds The new starting time in seconds for the countdown.
#' @param format The new format of the countdown timer display (either "simple" or "clock").
#' @param label The new label to be displayed above the countdown timer.
#'
#' @export
updateShinyTimer <- function(session, inputId, minutes = NULL, seconds = NULL, format = NULL, label = NULL) {
  message <- list(inputId = inputId)
  
  if (!is.null(minutes) && !is.null(seconds)) {
    message$start <- (minutes * 60) + seconds
  } else if (!is.null(minutes)) {
    message$start <- minutes * 60
  } else if (!is.null(seconds)) {
    message$start <- seconds
  }
  
  if (!is.null(format)) message$format <- format
  if (!is.null(label)) message$label <- label
  
  session$sendCustomMessage('updateShinyTimer', message)
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

formatTime <- function(time, format) {
  if (format == "clock") {
    minutes <- floor(time / 60)
    seconds <- time %% 60
    return(sprintf("%02d:%02d", minutes, seconds))
  } else {
    return(as.character(time))
  }
}
