devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    shinyTimer(
      inputId = "shiny_timer",
      seconds = 10L, 
      type = "simple", 
      style = "font-weight: bold; font-size: 72px; text-align:center"
    )
  )
)

server <- function(input, output, session) {
  shiny::observe({
    countDown(session, "shiny_timer")
  })
}

shinyApp(ui, server)