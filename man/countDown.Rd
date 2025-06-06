% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timer.R
\name{countDown}
\alias{countDown}
\title{Set shinyTimer in motion: count down}
\usage{
countDown(inputId, session = shiny::getDefaultReactiveDomain())
}
\arguments{
\item{inputId}{The input ID corresponding to the UI element.}

\item{session}{The session object from the shiny server function.}
}
\value{
No return value, called for side effects.
}
\description{
Set shinyTimer in motion: count down
}
\examples{
if (interactive()) {
  library(shiny)
  shinyApp(
    ui = fluidPage(
      shinyTimer("timer", label = "Countdown Timer", seconds = 20, type = "mm:ss"),
      actionButton("start", "Start Countdown")
    ),
    server = function(input, output, session) {
      observeEvent(input$start, {
        countDown("timer")
      })
    }
  )
}
}
