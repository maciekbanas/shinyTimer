#' shinyTimer widget
#'
#' @param inputId The input id.
#' @param label The label to display above the countdown.
#' @param hours An integer, the starting time in hours for the countdown.
#' @param minutes An integer, the starting time in minutes for the countdown.
#' @param seconds An integer, the starting time in seconds for the countdown.
#' @param type The type of the countdown timer display ("simple", "mm:ss", "hh:mm:ss", "mm:ss.cs").
#' @param frame The shape of the timer's container ("none", "circle", "rectangle").
#' @param ... Any additional parameters you want to pass to the placeholder for the timer (`htmltools::tags$div`).
#'
#' @return A shiny UI component for the countdown timer.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       shinyTimer("timer", label = "Countdown Timer", seconds = 10)
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$start, {
#'         countDown("timer", session)
#'       })
#'     }
#'   )
#' }
#' @export
shinyTimer <- function(inputId, label = NULL, hours = 0, minutes = 0, seconds = 0, type = "simple", frame = "circle", ...) {
  shiny::addResourcePath("shinyTimer", system.file("www", package = "shinyTimer"))
  
  if (!type %in% c("simple", "mm:ss", "hh:mm:ss", "mm:ss.cs")) {
    stop("Invalid type. Choose 'simple', 'mm:ss', 'hh:mm:ss', or 'mm:ss.cs'.")
  }
  
  if (!frame %in% c("none", "circle", "rectangle")) {
    stop("Invalid frame. Choose 'none', 'circle', or 'rectangle'.")
  }
  
  totalseconds <- (hours * 3600) + (minutes * 60) + seconds
  
  initial_display <- switch(
    type,
    "simple" = as.character(totalseconds),
    "mm:ss" = sprintf("%02d:%02d", floor(totalseconds / 60), totalseconds %% 60),
    "hh:mm:ss" = sprintf("%02d:%02d:%02d", floor(totalseconds / 3600), floor((totalseconds %% 3600) / 60), totalseconds %% 60),
    "mm:ss.cs" = sprintf("%02d:%02d.%02d", floor(totalseconds / 60), floor(totalseconds %% 60), 0)
  )
  
  frame_class <- switch(
    frame,
    "circle" = "shiny-timer-circle",
    "rectangle" = "shiny-timer-rectangle",
    "none" = ""
  )
  
  shiny::tagList(
    if (!is.null(label)) htmltools::tags$label(label, `for` = inputId),
    htmltools::tags$div(
      id = inputId,
      class = paste("shiny-timer", frame_class),
      `data-start-time` = totalseconds,
      `data-type` = type,
      initial_display,
      ...
    ),
    htmltools::tags$script(src = "shinyTimer/timer.js"),
    htmltools::tags$style(shiny::HTML("
      .shiny-timer-circle {
        border: 3px solid #ccc;
        border-radius: 50%;
        width: 150px;
        height: 150px;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .shiny-timer-rectangle {
        border: 3px solid #ccc;
        width: 150px;
        height: 100px;
        display: flex;
        align-items: center;
        justify-content: center;
      }
    "))
  )
}

#' Update shinyTimer widget
#'
#' @param inputId The input ID corresponding to the UI element.
#' @param hours The new starting time in hours for the countdown.
#' @param minutes The new starting time in minutes for the countdown.
#' @param seconds The new starting time in seconds for the countdown.
#' @param type The new type of the countdown timer display ("simple", "mm:ss",
#'   "hh:mm:ss", "mm:ss.cs").
#' @param label The new label to be displayed above the countdown timer.
#' @param frame The new shape of the timer's container ("none", "circle", "rectangle").
#' @param session The session object from the shiny server function.
#'
#' @return No return value, called for side effects.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       shinyTimer("timer", label = "Countdown Timer", seconds = 10, type = "mm:ss"),
#'       actionButton("update", "Update Timer")
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$update, {
#'         updateShinyTimer("timer", seconds = 20, type = "hh:mm:ss")
#'       })
#'     }
#'   )
#' }
#' @export
updateShinyTimer <- function(inputId, hours = NULL, minutes = NULL, seconds = NULL, 
                             type = NULL, label = NULL, frame = NULL, 
                             session = shiny::getDefaultReactiveDomain()) {
  message <- list(inputId = inputId)
  
  if (!is.null(hours) || !is.null(minutes) || !is.null(seconds)) {
    total_seconds <- 0
    if (!is.null(hours)) total_seconds <- total_seconds + (hours * 3600)
    if (!is.null(minutes)) total_seconds <- total_seconds + (minutes * 60)
    if (!is.null(seconds)) total_seconds <- total_seconds + seconds
    message$start = total_seconds
  }
  
  if (!is.null(type)) message$type <- type
  if (!is.null(label)) message$label <- label
  if (!is.null(frame)) message$frame <- frame
  
  session$sendCustomMessage('updateShinyTimer', message)
}

#' Set shinyTimer in motion: count down
#'
#' @param inputId The input ID corresponding to the UI element.
#' @param session The session object from the shiny server function.
#'
#' @return No return value, called for side effects.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       shinyTimer("timer", label = "Countdown Timer", seconds = 20, type = "mm:ss"),
#'       actionButton("start", "Start Countdown")
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$start, {
#'         countDown("timer")
#'       })
#'     }
#'   )
#' }
#' @export
countDown <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage('countDown', list(inputId = inputId))
}

#' Set shinyTimer in motion: count up
#'
#' @inheritParams countDown
#'
#' @return No return value, called for side effects.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       shinyTimer("timer", label = "Count Up Timer", seconds = 0, type = "mm:ss.cs"),
#'       actionButton("start", "Start Counting Up")
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$start, {
#'         countUp("timer")
#'       })
#'     }
#'   )
#' }
#' @export
countUp <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage('countUp', list(inputId = inputId))
}

#' Pause shinyTimer
#'
#' @inheritParams countDown
#'
#' @return No return value, called for side effects.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       shinyTimer("timer", label = "Countdown Timer", seconds = 20, type = "mm:ss"),
#'       actionButton("start", "Start Countdown"),
#'       actionButton("pause", "Pause Countdown")
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$start, {
#'         countDown("timer")
#'       })
#'       observeEvent(input$pause, {
#'         pauseTimer("timer")
#'       })
#'     }
#'   )
#' }
#' @export
pauseTimer <- function(inputId, session = shiny::getDefaultReactiveDomain()) {
  session$sendCustomMessage('pauseTimer', list(inputId = inputId))
}

#' Reset shinyTimer
#'
#' @inheritParams countDown
#' @param hours The new reset time in hours.
#' @param minutes The new reset time in minutes.
#' @param seconds The new reset time in seconds.
#'
#' @return No return value, called for side effects.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       shinyTimer("timer", label = "Countdown Timer", seconds = 20, type = "mm:ss"),
#'       actionButton("reset", "Reset Timer")
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$reset, {
#'         resetTimer("timer", seconds = 20)
#'       })
#'     }
#'   )
#' }
#' @export
resetTimer <- function(inputId, hours = 0, minutes = 0, seconds = 0, session = shiny::getDefaultReactiveDomain()) {
  total_seconds <- (hours * 3600) + (minutes * 60) + seconds
  session$sendCustomMessage('resetTimer', list(inputId = inputId, start = total_seconds))
}
