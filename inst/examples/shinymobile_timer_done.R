devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    shinyTimer(
      inputId = "shiny_timer",
      seconds = 5L, 
      type = "simple", 
      color = "white",
      fill = "black",
      frame = "none",
      style = "font-weight: bold; font-size: 72px; text-align:center"
    ),
    shinyMobile::f7Button(
      "start_timer",
      label = "Start", 
      size = "large",
      rounded = TRUE,
      color = "orange"
    ) |>
      htmltools::tagAppendAttributes(
        style="font-size:20px;"
      )
  )
)

server <- function(input, output, session) {
  shiny::observeEvent(input$start_timer, {
    countDown("shiny_timer")
  })
  shiny::observeEvent(input$shiny_timer_done, {
    shinyMobile::f7Dialog(
      id = "dialog",
      title = "Time's Up!",
      text = ""
    )
  })
}

shinyApp(ui, server)
