devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    shinyTimer(
      inputId = "shiny_timer",
      format = "clock", 
      style = "font-weight: bold; font-size: 72px; text-align:center"
    ),
    shinyMobile::f7Slider(
      inputId = "minutes_slider",
      label = "Minutes",
      value = 0,
      min = 0,
      max = 60
    ),
    shinyMobile::f7Slider(
      inputId = "seconds_slider",
      label = "Seconds",
      value = 0,
      min = 0,
      max = 60
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
  shiny::observeEvent(c(input$seconds_slider, input$minutes_slider), {
    updateShinyTimer(
      session = session,
      inputId = "shiny_timer",
      startSeconds = input$seconds_slider,
      startMinutes = input$minutes_slider
    )
  })
  shiny::observeEvent(input$start_timer, {
    countDown(session, "shiny_timer")
  })
}

shinyApp(ui, server)