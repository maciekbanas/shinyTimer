devtools::load_all()

ui <- fluidPage(
  shinyMobile::f7Badge(
    shinyTimer(
      inputId = "shiny_timer", 
      label = "Countdown:", 
      startSeconds = 10L, 
      format = "simple", 
      style = "font-weight: bold; font-size: 72px"
    )
  )
)

server <- function(input, output, session) {
  shiny::observe({
    countDown(session, "shiny_timer")
  })
}

shinyApp(ui, server)