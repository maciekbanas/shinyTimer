#' Countdown Timer UI Component
#'
#' @param inputId The input id.
#' @param label The label to display above the countdown.
#' @param start An integer, the starting time in `secs` for the countdown.
#' @param format The format of the countdown timer display (either "simple" or
#'   "clock").
#' @param animate The animation type for the timer display (e.g., "roll-down", "fade", "slide", "flip", "bounce").
#' @param ... Any additional parameters you want to pass to the placeholder for
#'   the timer (`htmltools::tags$div()`).
#'
#' @return A shiny UI component for the countdown timer.
#' @export
shinyTimer <- function(inputId, label = NULL, start, format = "simple", animate = NULL, ...) {
  shiny::addResourcePath("shinyTimer", system.file("www", package = "shinyTimer"))

  if (!format %in% c("simple", "clock")) {
    stop("Invalid format. Choose either 'simple' or 'clock'.")
  }
  
  valid_animations <- c("roll-down", "fade", "slide", "flip", "bounce", NULL)
  if (!animate %in% valid_animations) {
    stop("Invalid animation. Choose 'roll-down', 'fade', 'slide', 'flip', 'bounce' or NULL.")
  }
  
  shiny::tagList(
    if (!is.null(label)) htmltools::tags$label(label, `for` = inputId),
    htmltools::tags$div(
      id = inputId,
      class = "countdown-timer",
      `data-start-time` = start,
      `data-format` = format,
      `data-animate` = animate,
      formatTime(start, format),
      ...
    ),
    htmltools::tags$script(src = "shinyTimer/timer.js")
  )
}

#' @param session The session object from the shiny server function.
#' @param inputId The input ID corresponding to the UI element.
#' @param start The new starting time for the countdown.
#' @param format The new format of the countdown timer display (either "simple" or "clock").
#' @param label The new label to be displayed above the countdown timer.
#' @param animate The animation type for the timer display (e.g., "roll-down", "fade", "slide", "flip", "bounce").
#'
#' @export
updateShinyTimer <- function(session, inputId, start = NULL, format = NULL, label = NULL, animate = NULL) {
  message <- list(inputId = inputId)
  
  if (!is.null(start)) message$start <- start
  if (!is.null(format)) message$format <- format
  if (!is.null(label)) message$label <- label
  if (!is.null(animate)) message$animate <- animate
  
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