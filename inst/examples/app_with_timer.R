devtools::load_all()

ui <- fluidPage(
  shinyTimer("shiny_timer", "Countdown Timer:", 10L, 
             format = "clock", 
             style = "font-weight: bold; font-size: 72px"),
  tags$div(style = "margin-top: 5px"),
  actionButton("start", "Start Timer")
)

server <- function(input, output, session) {
  observeEvent(input$start, {
    countDown(session, "shiny_timer")
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
