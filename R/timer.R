#' Countdown Timer UI Component
#'
#' @param inputId The input id.
#' @param label The label to display above the countdown.
#' @param startMinutes An integer, the starting time in minutes for the countdown.
#' @param startSeconds An integer, the starting time in seconds for the countdown.
#' @param format The format of the countdown timer display (either "simple" or "clock").
#' @param ... Any additional parameters you want to pass to the placeholder for the timer (`htmltools::tags$div`).
#'
#' @return A shiny UI component for the countdown timer.
#' @export
shinyTimer <- function(inputId, label = NULL, startMinutes = 0, startSeconds = 0, format = "simple", ...) {
  addResourcePath("shinyTimer", system.file("www", package = "shinyTimer"))
  
  if (!format %in% c("simple", "clock")) {
    stop("Invalid format. Choose either 'simple' or 'clock'.")
  }
  
  totalStartSeconds <- (startMinutes * 60) + startSeconds
  
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
      class = "countdown-timer",
      `data-start-time` = totalStartSeconds,
      `data-format` = format,
      formatTime(totalStartSeconds, format),
      ...
    ),
    htmltools::tags$script(src = "shinyTimer/timer.js")
  )
}

#' Update Countdown Timer
#'
#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#' @param startMinutes The new starting time in minutes for the countdown.
#' @param startSeconds The new starting time in seconds for the countdown.
#' @param format The new format of the countdown timer display (either "simple" or "clock").
#' @param label The new label to be displayed above the countdown timer.
#'
#' @export
updateShinyTimer <- function(session, inputId, startMinutes = NULL, startSeconds = NULL, format = NULL, label = NULL) {
  message <- list(inputId = inputId)
  
  if (!is.null(startMinutes) && !is.null(startSeconds)) {
    message$start <- (startMinutes * 60) + startSeconds
  } else if (!is.null(startMinutes)) {
    message$start <- startMinutes * 60
  } else if (!is.null(startSeconds)) {
    message$start <- startSeconds
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