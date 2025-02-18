devtools::load_all()

ui <- fluidPage(
  radioButtons(
    "format", "Choose Timer Format:",
    choices = list("Simple" = "simple", "Clock" = "clock"),
    selected = "clock"
  ),
  numericInput("startMinutes", "Start Minutes:", value = 0, min = 0),
  numericInput("startSeconds", "Start Seconds:", value = 0, min = 0),
  shinyTimer("timer", "Countdown Timer:", 
             startMinutes = 0L, 
             startSeconds = 0L, 
             format = "clock", 
             style = "font-size: 48px; font-weight: bold"),
  actionButton("update", "Update Timer"),
  actionButton("start", "Start Timer")
)

server <- function(input, output, session) {
  
  observeEvent(input$start, {
    countDown(session, "timer")
  })
  
  observeEvent(input$update, {
    updateShinyTimer(session, "timer", 
                     startMinutes = input$startMinutes, 
                     startSeconds = input$startSeconds, 
                     format = input$format)
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
