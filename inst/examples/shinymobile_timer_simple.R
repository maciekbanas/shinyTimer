devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    htmltools::div(
      style = "display:flex; justify-content:center;",
      shinyTimer(
        inputId = "shiny_timer",
        seconds = 10L, 
        type = "simple", 
        frame = "circle",
        color = "green",
        style = "font-weight: bold; font-size: 72px;"
      )
    )
  )
)

server <- function(input, output, session) {
  shiny::observe({
    countDown("shiny_timer")
  })
}

shinyApp(ui, server)