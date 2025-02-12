devtools::load_all()

ui <- fluidPage(
  shinyTimer("timer", "Countdown Timer:", 10),
  actionButton("start", "Start Timer")
)

server <- function(input, output, session) {
  observeEvent(input$start, {
    runTimer(input, output, session, "timer", 10)
  })
  
  observeEvent(input$timer_done, {
    showModal(modalDialog(
      title = "Time's Up!",
      "The countdown has finished.",
      easyClose = TRUE,
      footer = NULL
    ))
  })
}

shinyApp(ui, server)
