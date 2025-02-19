devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    shinyTimer(
      inputId = "shiny_timer",
      seconds = 0L, 
      format = "clock", 
      style = "font-weight: bold; font-size: 72px; text-align:center"
    ),
    shinyMobile::f7Block(
      shinyMobile::f7Button(
        "start_timer",
        label = "Start", 
        size = "large",
        rounded = TRUE,
        color = "green"
      ) |>
        htmltools::tagAppendAttributes(
          style="font-size:20px;"
        ),
      shinyMobile::f7Button(
        "stop_timer",
        label = "Stop", 
        size = "large",
        rounded = TRUE,
        color = "orange"
      ) |>
        htmltools::tagAppendAttributes(
          style="font-size:20px;"
        )
    )
    
  )
)

server <- function(input, output, session) {
  shiny::observeEvent(input$start_timer, {
    countUp(session, "shiny_timer")
  })
  shiny::observeEvent(input$stop_timer, {
    stopTimer(session, "shiny_timer")
  })
}

shinyApp(ui, server)
