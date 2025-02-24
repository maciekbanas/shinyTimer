devtools::load_all()

ui <- shinyMobile::f7Page(
  shinyMobile::f7Card(
    shinyTimer(
      inputId = "shiny_timer",
      seconds = 0L, 
      type = "mm:ss.cs", 
      style = "font-weight: bold; font-size: 72px; text-align:center"
    ),
    shiny::br(),
    shinyMobile::f7Block(
      shinyMobile::f7Button(
        "start_timer",
        label = "Run", 
        size = "large",
        rounded = TRUE,
        color = "green"
      ) |>
        htmltools::tagAppendAttributes(
          style="font-size:20px;"
        ),
      shinyMobile::f7Button(
        "pause_timer",
        label = "Pause", 
        size = "large",
        rounded = TRUE,
        color = "orange"
      ) |>
        htmltools::tagAppendAttributes(
          style="font-size:20px;"
        ),
      shinyMobile::f7Button(
        "resume_timer",
        label = "Reset", 
        size = "large",
        rounded = TRUE,
        color = "blue"
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
  shiny::observeEvent(input$pause_timer, {
    pauseTimer(session, "shiny_timer")
  })
  shiny::observeEvent(input$resume_timer, {
    resetTimer(session, "shiny_timer")
  })
}

shinyApp(ui, server)
