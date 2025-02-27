devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    shinyTimer(
      inputId = "shiny_timer",
      type = "hh:mm:ss", 
      style = "font-weight: bold; font-size: 72px; text-align:center"
    ),
    shinyMobile::f7Slider(
      inputId = "hours_slider",
      label = "Hours",
      value = 0,
      min = 0,
      max = 24
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
  shiny::observe({
    updateShinyTimer(
      inputId = "shiny_timer",
      hours = input$hours_slider,
      minutes = input$minutes_slider,
      seconds = input$seconds_slider,
      type = "hh:mm:ss"
    )
  })
  
  shiny::observeEvent(input$start_timer, {
    countDown("shiny_timer")
  })
}

shiny::shinyApp(ui, server)
