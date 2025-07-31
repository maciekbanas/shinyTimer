devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    shinyTimer(
      inputId = "shiny_timer",
      seconds = 10L, 
      type = "simple", 
      color = "white",
      frame = "none",
      style = "font-weight: bold; font-size: 72px; text-align:center"
    ),
    shinyMobile::f7Select(
      inputId = "timer_type",
      label = NULL,
      choices = c("simple", "mm:ss", "hh:mm:ss", "mm:ss.cs")
    ),
    shiny::br(),
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
  shiny::observeEvent(input$timer_type, {
    updateShinyTimer(
      session = session,
      inputId = "shiny_timer",
      type = input$timer_type
    )
  })
}

shiny::shinyApp(ui, server)
