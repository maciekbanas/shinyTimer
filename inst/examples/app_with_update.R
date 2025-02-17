devtools::load_all()

ui <- fluidPage(
  radioButtons(
    "format", "Choose Timer Format:",
    choices = list("Simple" = "simple", "Clock" = "clock"),
    selected = "clock"
  ),
  numericInput("startTime", "New Start Time (seconds):", value = 600, min = 1),
  shinyTimer("timer", "Timer:", 600, format = "clock",
             style = "font-size: 48px; font-weight: bold"),
  actionButton("start", "Start Timer")
)

server <- function(input, output, session) {
  observeEvent(input$start, {
    countDown(session, "timer")
  })
  
  observeEvent(input$format, {
    updateShinyTimer(session, "timer", start = input$startTime, format = input$format, label = input$label)
  }, ignoreInit = TRUE)
  
  observeEvent(input$startTime, {
    updateShinyTimer(session, "timer", start = input$startTime, format = input$format, label = input$label)
  }, ignoreInit = TRUE)

}

shinyApp(ui, server)
